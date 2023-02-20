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
    // Original rotation of the current node
    var currentRotationOffset : Float = 0.0
    // Whether to constrain the model to the camera
    var lookAtCamera = false
    // Create and initialize the AVAudioPlayer object
    var player: AVAudioPlayer!
    // File name of a page's corresponding audio
    var fileName = ""
    
    // Light
    let lightSource = SCNLight()
    // Ambient light color
    var lightTemp : CGFloat!
    
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
        
        lightSource.type = .ambient
        sceneView.autoenablesDefaultLighting = true
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
        
        // Add the light to the scene
        let lightNode = SCNNode()
        lightNode.light = lightSource
        sceneView.scene.rootNode.addChildNode(lightNode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Runs once per frame
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if lookAtCamera && currentNode != nil{
            currentNode.eulerAngles.y = -sceneView.session.currentFrame!.camera.eulerAngles.y + currentRotationOffset
        }
        if sceneView.session.currentFrame != nil{
            if sceneView.session.currentFrame!.lightEstimate != nil{
                lightTemp = sceneView.session.currentFrame!.lightEstimate!.ambientColorTemperature
                lightSource.temperature = lightTemp
                //print("Color Temp: \(lightTemp!)")
            }
        }
    }
    
    // Runs everytime a node is added to the scene
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if lookAtCamera{
            currentRotationOffset = currentNode.eulerAngles.y
        }
    }
    
    // Runs once per recognized image
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        node.eulerAngles.x = .pi/2.0
        
        // Is the anchor an image?
        if let imageAnchor = anchor as? ARImageAnchor{
            
            clearPage()
            
            if imageAnchor.referenceImage.name == "BookCover" {
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_cover.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_01", recursively: false)!
                eleNode.eulerAngles.y = -.pi/4.0
                eleNode.worldPosition = SCNVector3(-0.026, 0.0, 0.06)
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_01", recursively: false)!
                pigNode.worldPosition = SCNVector3(0.05, 0.0, 0.08)
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "Cover"
            } else {
                // else branch used for numbered paths
                
                // partial paths
                var modelPath = "art.scnassets/Models/mesh_pg"
                var elePath = "Gerald_"
                var pigPath = "Piggie_"
                var audioPath = "page"
                
                // grab page number from image name and convert to string
                var image = imageAnchor.referenceImage.name
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
                    node.addChildNode(eleNode)
                }
                
                // execute only if pig node exists
                if let pigNode = modelScene.rootNode.childNode(withName: pigPath + pgNum, recursively: false) {
                    node.addChildNode(pigNode)
                }
                
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = audioPath+pgNum
            }
        } else {
            print("Page not found")
        }
        
        return node
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
        currentRotationOffset = 0.0
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
