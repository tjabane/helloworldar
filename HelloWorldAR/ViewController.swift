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
    var visibleGrid: Bool = true
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        registerGestureRecognizer()
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.addPlane(node: node, anchor: planeAnchor)
                self.feedbackGenerator.impactOccurred()
                
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
    
    //Mark: private Methods
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        plane.setPlaneVisibility(self.visibleGrid)
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
        var minVec = SCNVector3Zero;
        var maxVec = SCNVector3Zero;
        (minVec, maxVec) =  textNode.boundingBox
        textNode.pivot = SCNMatrix4MakeTranslation(
            minVec.x + (maxVec.x - minVec.x)/2,
            minVec.y,
            minVec.z + (maxVec.z - minVec.z)/2
        )
        return textNode;
    }
    
    func addText(_ hitResult: ARHitTestResult){
        let textNode = createTextNode(string: "Dumela  Lefatshe");
        textNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                       hitResult.worldTransform.columns.3.y,
                                       hitResult.worldTransform.columns.3.z
                                       )
        self.sceneView.scene.rootNode.addChildNode(textNode);
    }
    
    func registerGestureRecognizer(){
        let tapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2;
        doubleTapGestureRecognizer.numberOfTouchesRequired = 1;
        
        self.sceneView.addGestureRecognizer(doubleTapGestureRecognizer);
        self.sceneView.addGestureRecognizer(tapGestureRecognizer);
    }
    
    @objc func doubleTapped(recognizer: UITapGestureRecognizer){
        self.visibleGrid = !self.visibleGrid
        planes.forEach({ (_, plane) in
            plane.setPlaneVisibility(self.visibleGrid)
        })
    }
    
    @objc func tapped(recognizer: UITapGestureRecognizer){
        let sceneView = recognizer.view as! ARSCNView;
        let touchLocation = recognizer.location(in: sceneView);
        let hitRTestRetsult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent);
        if !hitRTestRetsult.isEmpty {
            guard let hitResult = hitRTestRetsult.first else{
                return
            }
            addText(hitResult);
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
