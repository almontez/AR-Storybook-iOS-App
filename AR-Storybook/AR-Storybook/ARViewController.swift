//
//  ViewController.swift
//  AR-Storybook
//
//  Created by Angela Li Montez on 1/26/23.
//  Based on AR code template from Apple
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var soundButton: UIButton!
    
    
    // Information of the current page
    var currentAnchor : ARImageAnchor!
    var currentNode : SCNNode!
    
    // Whether to constrain the model to the camera
    var lookAtCamera = false
    
    // Create and initialize the AVAudioPlayer object
    var player: AVAudioPlayer!
    // File name of a page's corresponding audio
    var fileName = ""
    
    // Light
    let lightSource = SCNLight()
    // Light pivot node
    let lightPivotNode = SCNNode()
    
    // Runs once when the session loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Circle Button
        soundButton.layer.cornerRadius = soundButton.frame.width / 2
        soundButton.layer.masksToBounds = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        lightSource.type = .omni
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // Bundle.main is current directory
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "BookPages", bundle: Bundle.main){
            
            configuration.trackingImages = imageToTrack
            // If using WorldTracking, use configuration.detectionImages instead
            configuration.maximumNumberOfTrackedImages = 1
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
        
        if sceneView.scene.rootNode.childNode(withName: "lightPivot", recursively: false) == nil{
            // This if block prevents lights from being duplicated
            // when the user navigates from and back to the camera
            lightPivotNode.name = "lightPivot"
            
            // Add lights to the scene
            let lightNode = SCNNode()
            lightNode.light = lightSource
            lightNode.worldPosition = SCNVector3(x: 0.0, y: 0.3, z: 0.2)
            lightPivotNode.addChildNode(lightNode)
            
            let ambLightNode = SCNNode()
            let ambLight = SCNLight()
            ambLight.type = .ambient
            ambLight.intensity = 300
            ambLightNode.light = ambLight
            lightPivotNode.addChildNode(ambLightNode)
            
            sceneView.scene.rootNode.addChildNode(lightPivotNode)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Runs once per frame
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if currentNode != nil{
            // Keep the light between the camera and the models
            lightPivotNode.worldPosition = currentNode.worldPosition
            lightPivotNode.eulerAngles.y = sceneView.session.currentFrame!.camera.eulerAngles.y
        }
        if lookAtCamera && currentNode != nil{
            // Rotate the models to always look at the camera
            currentNode.childNode(withName: "group", recursively: false)!.eulerAngles.y = sceneView.session.currentFrame!.camera.eulerAngles.y -
                                                                                          currentNode.eulerAngles.y
        }
        if sceneView.session.currentFrame != nil{
            // Update light intensity and color
            if sceneView.session.currentFrame!.lightEstimate != nil{
                let lightEstimate = sceneView.session.currentFrame!.lightEstimate!
                lightSource.intensity = lightEstimate.ambientIntensity
                lightSource.temperature = lightEstimate.ambientColorTemperature
            }
        }
    }
    
    // Runs once per recognized image
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // The node to attach to the scene
        let baseNode = SCNNode()
        baseNode.eulerAngles.x = .pi/2.0
        
        // The node with clean transforms, to contain the characters
        let grpNode = SCNNode()
        grpNode.name = "group"
        baseNode.addChildNode(grpNode)
        
        // Is the anchor an image?
        if let imageAnchor = anchor as? ARImageAnchor{
            
            clearPage()
            
            if imageAnchor.referenceImage.name == "BookCover" {
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_cover.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_01", recursively: false)!
                grpNode.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_01", recursively: false)!
                grpNode.addChildNode(pigNode)

                updatePage(node: baseNode, imageAnchor: imageAnchor)
                fileName = "Cover"
            } else {
                // else branch used for numbered paths
                
                // partial paths
                let modelPath = "art.scnassets/Models/mesh_pg"
                let elePath = "Gerald_"
                let pigPath = "Piggie_"
                let audioPath = "page"
                
                // grab page number from image name and convert to string
                let image = imageAnchor.referenceImage.name
                var pgNum = String(image!.suffix(2))
                
                // debug statements
                // print("Debug modelPath:", modelPath+pgNum+".scn")
                // print("Debug elePath:", elePath+pgNum)
                // print("Debug pgiPath:", pigPath+pgNum)
                // print("Debug audioPath:", audioPath+pgNum)
                
                // always execute
                let modelScene = SCNScene(named: modelPath + pgNum + ".scn")!
                
                // execute only if elephant node exists
                if let eleNode = modelScene.rootNode.childNode(withName: elePath + pgNum, recursively: false) {
                    grpNode.addChildNode(eleNode)
                }
                
                // execute only if pig node exists
                if let pigNode = modelScene.rootNode.childNode(withName: pigPath + pgNum, recursively: false) {
                    grpNode.addChildNode(pigNode)
                }
                
                // Call unique page functions here
                if rotationTable[image!]! == 1{
                    lookAtCamera = true
                }
                if pgNum == "18" || pgNum == "19"{
                    pgNum = "18_19"
                }
                
                // Update info on current page
                updatePage(node: baseNode, imageAnchor: imageAnchor)
                fileName = audioPath + pgNum
            }
            if lookAtCamera{
                // If the model needs to face the camera, rotate it accordingly when it first appears
                grpNode.eulerAngles.y = sceneView.session.currentFrame!.camera.eulerAngles.y
            }
        } else {
            print("Page not found")
        }
        
        return baseNode
    }
    
    // Reset current page info when a different page is detected
    func clearPage(){
        // Removes the current anchor so it can be added again later
        if currentAnchor != nil{
            sceneView.session.remove(anchor: currentAnchor)
        }
        // Removes the previous node from the scene
        if currentNode != nil{
            currentNode.removeFromParentNode()
        }
        // Reset look-at variables
        lookAtCamera = false
        // Reset fileName variable to empty string
        fileName = ""
    }
    
    // Save information about the current page
    func updatePage(node: SCNNode, imageAnchor: ARImageAnchor){
        node.name = imageAnchor.referenceImage.name
        currentNode = node
        currentAnchor = imageAnchor
    }
    
    // MARK: - UI Functionalities
    
    // Changes color of button when pressed down - UI feature ONLY
    @IBAction func soundButtonPressedDown(_ sender: UIButton) {
        soundButton.backgroundColor = UIColor(red: 138/255, green: 255/255, blue: 138/255, alpha: 1.0)
    }
    
    // Play audio for tutorial
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        if fileName != "" {
            let url = Bundle.main.url(forResource: fileName, withExtension: "m4a")
            
            // Do not do anything if the url is empty
            guard url != nil else {
                return
            }
            
            do {
                player = try AVAudioPlayer(contentsOf:url!)
                player?.play()
            } catch {
                print("Error: Cannot play the audio.")
            }
        }
        // change color of button back to gray when released
        soundButton.backgroundColor = .gray
    }
}
