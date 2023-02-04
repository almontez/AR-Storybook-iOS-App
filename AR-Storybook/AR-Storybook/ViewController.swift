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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            if imageAnchor.referenceImage.name == "BookCover" {
                let modelScene = SCNScene(named: "art.scnassets/Models/mesh_cover.scn")!
                
                let eleNode = modelScene.rootNode.childNode(withName: "Gerald_01", recursively: false)!
                eleNode.eulerAngles = SCNVector3(.pi/2, -.pi/4.0, 0.0)
                eleNode.worldPosition = SCNVector3(-0.026, 0.0, 0.06)
                node.addChildNode(eleNode)
                
                let pigNode = modelScene.rootNode.childNode(withName: "Piggie_01", recursively: false)!
                pigNode.eulerAngles = SCNVector3(.pi/2, 0.0, 0.0)
                pigNode.worldPosition = SCNVector3(0.05, 0.0, 0.08)
                node.addChildNode(pigNode)
            } else if imageAnchor.referenceImage.name == "page2" {
                if let eleScene = SCNScene(named: "art.scnassets/Gerald_02.scn"){
                    if let eleNode = eleScene.rootNode.childNodes.first{
                        eleNode.eulerAngles.x = .pi
                        node.addChildNode(eleNode)
                    }
                }
                if let pigScene = SCNScene(named: "art.scnassets/Piggie_02.scn"){
                    if let pigNode = pigScene.rootNode.childNodes.first{
                        pigNode.eulerAngles.x = .pi
                        node.addChildNode(pigNode)
                    }
                }
            } else if imageAnchor.referenceImage.name == "page3" {
                if let eleScene = SCNScene(named: "art.scnassets/Gerald_03.scn"){
                    if let eleNode = eleScene.rootNode.childNodes.first{
                        eleNode.eulerAngles.x = .pi
                        node.addChildNode(eleNode)
                    }
                }
                if let pigScene = SCNScene(named: "art.scnassets/Piggie_03.scn"){
                    if let pigNode = pigScene.rootNode.childNodes.first{
                        pigNode.eulerAngles.x = .pi
                        node.addChildNode(pigNode)
                    }
                }
            }
        }
        
        return node
    }
}
