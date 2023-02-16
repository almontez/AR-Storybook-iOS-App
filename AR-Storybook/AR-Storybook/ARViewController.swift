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
                print("Color Temp: \(lightTemp!)")
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
            switch imageAnchor.referenceImage.name{
            case "BookCover":
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
            case "page2":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg02.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_02", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_02", recursively: false)!
                node.addChildNode(pigNode)
                
                lookAtCamera = true
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page2"
            case "page3":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg03.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_03", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_03", recursively: false)!
                node.addChildNode(pigNode)

                lookAtCamera = true
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page3"
            case "page4":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg04.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_04", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_04", recursively: false)!
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page4"
            case "page5":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg05.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_05", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_05", recursively: false)!
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page5"
            case "page6":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg06.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_06", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_06", recursively: false)!
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page6"
            case "page7":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg07.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_07", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_07", recursively: false)!
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = ""
            case "page8":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg08.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_08", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_08", recursively: false)!
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page8"
            case "page9":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg09.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_09", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_09", recursively: false)!
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page9"
            case "page10":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg10.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_10", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_10", recursively: false)!
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page10"
            case "page11":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg11.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_11", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_11", recursively: false)!
                node.addChildNode(pigNode)
                
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page11"
            case "page12":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg12.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_12", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_12", recursively: false)!
                node.addChildNode(pigNode)
            
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page12"
            case "page13":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg13.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_13", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_13", recursively: false)!
                node.addChildNode(pigNode)

                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page13"
            case "page14":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg14.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_14", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_14", recursively: false)!
                node.addChildNode(pigNode)
            
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page14"
            case "page15":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg15.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_15", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_15", recursively: false)!
                node.addChildNode(pigNode)
            
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page15"
            case "page16":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg16.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_16", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_16", recursively: false)!
                node.addChildNode(pigNode)
                
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page16"
            case "page17":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg17.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_17", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_17", recursively: false)!
                node.addChildNode(pigNode)
            
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page17"
            case "page18":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg18.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_18", recursively: false)!
                node.addChildNode(eleNode)
            
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page18_19"
            case "page19":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg19.scn")!
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_19", recursively: false)!
                node.addChildNode(pigNode)
            
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page18_19"
            case "page20":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg20.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_20", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_20", recursively: false)!
                node.addChildNode(pigNode)
            
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page20"
            case "page21":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg21.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_21", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_21", recursively: false)!
                node.addChildNode(pigNode)
                
                updatePage(node: node, imageAnchor: imageAnchor)
                fileName = "page21"
            default:
                print("Page not found")
            }
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
