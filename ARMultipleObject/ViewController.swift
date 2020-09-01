//
//  ViewController.swift
//  ARMultipleObject
//
//  Created by alberta adeline marvel on 01/09/20.
//  Copyright © 2020 alberta adeline marvel. All rights reserved.
//

import UIKit
import RealityKit
import SnapKit
import ARKit

class ViewController: UIViewController, ConstraintRelatableTarget {
    
    @IBOutlet var arView: ARView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //buttons
        let contentView = UIView()
        contentView.backgroundColor = .separator
        contentView.layer.cornerRadius = 10
        
        
        
        let buttonChair = UIButton()
        buttonChair.setBackgroundImage(UIImage (named: "chair"), for: UIControl.State.normal)
        buttonChair.layer.cornerRadius = 10
        buttonChair.imageView!.layer.cornerRadius = 10
        buttonChair.clipsToBounds = true
        buttonChair.addTarget(self, action: #selector(loadChair), for: .touchUpInside)
        
        
        let buttonTeapot = UIButton()
        buttonTeapot.setBackgroundImage(UIImage (named: "teapot"), for: UIControl.State.normal)
        buttonTeapot.layer.cornerRadius = 10
        buttonTeapot.imageView!.layer.cornerRadius = 10
        buttonTeapot.clipsToBounds = true
        
        
        
        
        let buttonRetroTV = UIButton()
        buttonRetroTV.setBackgroundImage(UIImage (named: "retroTV"), for: UIControl.State.normal)
        buttonRetroTV.layer.cornerRadius = 10
        buttonRetroTV.imageView!.layer.cornerRadius = 10
        buttonRetroTV.clipsToBounds = true
        
        
        
        
        let buttonGramophone = UIButton()
        buttonGramophone.setBackgroundImage(UIImage (named: "gramophone"), for: UIControl.State.normal)
        buttonGramophone.layer.cornerRadius = 10
        buttonGramophone.imageView!.layer.cornerRadius = 10
        buttonGramophone.clipsToBounds = true
        
        
        
        //adding views
        arView.addSubview(contentView)
        contentView.addSubview(buttonChair)
        contentView.addSubview(buttonTeapot)
        contentView.addSubview(buttonRetroTV)
        contentView.addSubview(buttonGramophone)
        
        
        //making constraint
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(414)
            make.height.equalTo(125)
            make.bottom.equalTo(arView)
        }
        
        buttonChair.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(17)
            make.bottom.equalTo(-30)
            
        }
        
        buttonTeapot.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(117)
            make.bottom.equalTo(-30)
            
        }
        
        buttonRetroTV.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(217)
            make.bottom.equalTo(-30)
            
        }
        
        buttonGramophone.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.right.equalTo(-17)
            make.bottom.equalTo(-30)
            
        }
        
        //set up config
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = .horizontal
        arView.session.run(arConfiguration)
        
    }
    
    @objc private func loadChair() {
        
        let chairModelEntity = try! ModelEntity.load(named: "chairReality")
        chairModelEntity.generateCollisionShapes(recursive: true)
        
        
        let anchorEntity = AnchorEntity(plane: .horizontal)
        anchorEntity.addChild(chairModelEntity)
        
        
//        let entityBounds = anchorEntity.visualBounds(relativeTo: chairModelEntity)
//        chairModelEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
//
//        arView.installGestures(.all, for: anchorEntity as! HasCollision )
        arView.scene.addAnchor(anchorEntity)
        
    }
}
