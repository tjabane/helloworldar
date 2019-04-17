//
//  ViewController.swift
//  HelloWorldAR
//
//  Created by Tiisetso Tjabane on 2019/04/17.
//  Copyright © 2019 Tiisetso Tjabane. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    var planes = [ARPlaneAnchor: Plane]()
    
    
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal;
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
     Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.addPlane(node: node, anchor: planeAnchor)
                
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.updatePlane(anchor: planeAnchor)
                
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    
    
    //Mark: private Methods
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        planes[anchor] = plane
        node.addChildNode(plane)
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
    
    
    func createTextNode (string: String) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.1);
        text.font = UIFont.systemFont(ofSize: 1.0);
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white;
        
        let textNode = SCNNode(geometry: text);
        let fontSize = Float(0.04);
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize);
        return textNode;
    }
    
    func addText(string: String, parent: SCNNode){
        let textNode = createTextNode(string: string);
        textNode.position = SCNVector3Zero
        parent.addChildNode(textNode);
    }
    
    func registerGestureRecognizer(){
        let tapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer);
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer){
        let sceneView = recognizer.view as! ARSCNView;
        let touchLocation = recognizer.location(in: sceneView);
        let hitRTestRetsult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent);
        if !hitRTestRetsult.isEmpty {
            guard let hitResult = hitRTestRetsult.first else{
                return
            }
        }
    }
    
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
