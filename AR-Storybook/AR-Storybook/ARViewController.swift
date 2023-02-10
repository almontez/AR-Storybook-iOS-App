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

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var soundButton: UIButton!
    
    // Information of the current page
    var currentAnchor : ARAnchor!
    var currentNode : SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Circle Button
        soundButton.layer.cornerRadius = soundButton.frame.width / 2
        soundButton.layer.masksToBounds = true
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
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
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        node.eulerAngles.x = .pi/2.0
        
        // Is the anchor an image?
        if let imageAnchor = anchor as? ARImageAnchor{
            
            switch imageAnchor.referenceImage.name{
            case "BookCover":
                clearCurrent()
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_cover.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_01", recursively: false)!
                eleNode.eulerAngles.y = -.pi/4.0
                eleNode.worldPosition = SCNVector3(-0.026, 0.0, 0.06)
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_01", recursively: false)!
                pigNode.worldPosition = SCNVector3(0.05, 0.0, 0.08)
                node.addChildNode(pigNode)

                node.name = imageAnchor.referenceImage.name
                currentNode = node
                currentAnchor = anchor
                print("Cover detected")
            case "page2":
                clearCurrent()
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg02.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_02", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_02", recursively: false)!
                node.addChildNode(pigNode)

                node.name = imageAnchor.referenceImage.name
                currentNode = node
                currentAnchor = anchor
                print("Page 2 detected")
            case "page3":
                clearCurrent()
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg03.scn")!

                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_03", recursively: false)!
                node.addChildNode(eleNode)

                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_03", recursively: false)!
                node.addChildNode(pigNode)

                node.name = imageAnchor.referenceImage.name
                currentNode = node
                currentAnchor = anchor
                print("Page 3 detected")
            case "page11":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg11.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_11", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_11", recursively: false)!
                node.addChildNode(pigNode)
                
            case "page12":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg12.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_12", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_12", recursively: false)!
                node.addChildNode(pigNode)
            
            case "page13":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg13.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_13", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_13", recursively: false)!
                node.addChildNode(pigNode)

            case "page14":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg14.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_14", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_14", recursively: false)!
                node.addChildNode(pigNode)
            
            case "page15":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg15.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_15", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_15", recursively: false)!
                node.addChildNode(pigNode)
            
            case "page16":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg16.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_16", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_16", recursively: false)!
                node.addChildNode(pigNode)
                
            case "page17":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg17.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_17", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_17", recursively: false)!
                node.addChildNode(pigNode)
            
            case "page18":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg18.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_18", recursively: false)!
                node.addChildNode(eleNode)
            
            case "page19":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg19.scn")!
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_19", recursively: false)!
                node.addChildNode(pigNode)
            
            case "page20":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg20.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_20", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_20", recursively: false)!
                node.addChildNode(pigNode)
            
            case "page21":
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_pg21.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_21", recursively: false)!
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_21", recursively: false)!
                node.addChildNode(pigNode)
                
            default:
                print("Page not found")
            }
        }
        
        return node
    }
    
    func clearCurrent(){
        if currentAnchor != nil{
            sceneView.session.remove(anchor: currentAnchor)
        }
    }
    
    // MARK: - UI Functionalities
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        print("AR View Sound Button Pressed")
    }
}
