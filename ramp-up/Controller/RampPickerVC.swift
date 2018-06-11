//
//  RampPickerVC.swift
//  ramp-up
//
//  Created by Robert Møller on 11/06/2018.
//  Copyright © 2018 Robert Møller. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {

    var sceneView: SCNView!
    var size: CGSize!
    weak var rampPlacerVC: RampPlacerVC!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        
        //Pipe
        let pipeObj = SCNScene(named: "art.scnassets/pipe.dae")!
        let pipe = pipeObj.rootNode.childNode(withName: "pipe", recursively: true)!
        pipe.runAction(rotate)
        pipe.scale = SCNVector3Make(0.0022, 0.0022, 0.0022)
        pipe.position = SCNVector3Make(-1, 0.7, -1)
        scene.rootNode.addChildNode(pipe)

        //Pyramid
        let pyramidObj = SCNScene(named: "art.scnassets/pyramid.dae")!
        let pyramid = pyramidObj.rootNode.childNode(withName: "pyramid", recursively: true)!
        pyramid.runAction(rotate)
        pyramid.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        pyramid.position = SCNVector3Make(-1, -0.45, -1)
        scene.rootNode.addChildNode(pyramid)
        
        //Pyramid
        let quarterObj = SCNScene(named: "art.scnassets/quarter.dae")!
        let quarter = quarterObj.rootNode.childNode(withName: "quarter", recursively: true)!
        quarter.runAction(rotate)
        quarter.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        quarter.position = SCNVector3Make(-1, -2.2, -1)
        scene.rootNode.addChildNode(quarter)
        
        preferredContentSize = size
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let p = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        
        if hitResults.count > 0 {
            let node = hitResults[0].node
            rampPlacerVC.onRampSelected(node.name!)
        }
    }

}
