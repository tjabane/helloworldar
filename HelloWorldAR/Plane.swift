//
//  Plane.swift
//  HelloWorldAR
//
//  Created by Tiisetso Tjabane on 2019/04/17.
//  Copyright © 2019 Tiisetso Tjabane. All rights reserved.
//
import SceneKit
import ARKit
import Foundation


class Plane:SCNNode{
    
    var planeAnchor: ARPlaneAnchor
    var planeGeometry: SCNPlane
    var planeNode: SCNNode
    
    
    
    init(_ anchor: ARPlaneAnchor) {
        self.planeAnchor = anchor;
        let grid = UIImage(named: "grid");
        
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z));
        let material = SCNMaterial();
        material.diffuse.contents = grid;
        self.planeGeometry.materials = [material];
        self.planeGeometry.firstMaterial?.transparency = CGFloat(0.5);
        self.planeNode = SCNNode(geometry: self.planeGeometry);
        self.planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        super.init()
        self.addChildNode(planeNode);
        self.position = SCNVector3(anchor.center.x, -0.002, anchor.center.z)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ anchor: ARPlaneAnchor) {
        self.planeAnchor = anchor
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        self.position = SCNVector3Make(anchor.center.x, -0.002, anchor.center.z)
    }
    
    func setPlaneVisibility(_ visible: Bool) {
        self.planeNode.isHidden = !visible
    }
    
    
    
    
    
    
}
