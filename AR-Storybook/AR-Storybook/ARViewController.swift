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
            configuration.maximumNumberOfTrackedImages = 2
            
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
        
        // Is the anchor an image?
        if let imageAnchor = anchor as? ARImageAnchor{
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height
            )
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.0)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            switch imageAnchor.referenceImage.name{
            case "BookCover":
                if let eleScene = SCNScene(named: "art.scnassets/Gerald_Cover.scn"){
                    if let eleNode = eleScene.rootNode.childNodes.first{
                        eleNode.eulerAngles.x = .pi
                        planeNode.addChildNode(eleNode)
                    }
                }
                if let pigScene = SCNScene(named: "art.scnassets/Piggie_Cover.scn"){
                    if let pigNode = pigScene.rootNode.childNodes.first{
                        pigNode.eulerAngles.x = .pi
                        planeNode.addChildNode(pigNode)
                    }
                }
            case "page2":
                if let eleScene = SCNScene(named: "art.scnassets/Gerald_02.scn"){
                    if let eleNode = eleScene.rootNode.childNodes.first{
                        eleNode.eulerAngles.x = .pi
                        planeNode.addChildNode(eleNode)
                    }
                }
                if let pigScene = SCNScene(named: "art.scnassets/Piggie_02.scn"){
                    if let pigNode = pigScene.rootNode.childNodes.first{
                        pigNode.eulerAngles.x = .pi
                        planeNode.addChildNode(pigNode)
                    }
                }
            case "page3":
                if let eleScene = SCNScene(named: "art.scnassets/Gerald_03.scn"){
                    if let eleNode = eleScene.rootNode.childNodes.first{
                        eleNode.eulerAngles.x = .pi
                        planeNode.addChildNode(eleNode)
                    }
                }
                if let pigScene = SCNScene(named: "art.scnassets/Piggie_03.scn"){
                    if let pigNode = pigScene.rootNode.childNodes.first{
                        pigNode.eulerAngles.x = .pi
                        planeNode.addChildNode(pigNode)
                    }
                }
            default:
                print("Page not found")
            }
            
        }
        
        return node
    }
    
    // MARK: - UI Functionalities
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        print("AR View Sound Button Pressed")
    }
}
