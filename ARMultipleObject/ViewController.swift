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
import Combine

class ViewController: UIViewController, ConstraintRelatableTarget {
    
    @IBOutlet var arView: ARView!
    
    let config = ARWorldTrackingConfiguration()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.color = .white
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingView)
        
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return loadingView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up configuration
        arView.automaticallyConfigureSession = false
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        arView.session.run(config)
        
        //call func to remove object
        arView.enableObjectRemoval()
        
        
        
        
        let contentView = UIView()
        contentView.backgroundColor = .separator
        contentView.layer.cornerRadius = 10
        
        
        func buttonDetail() -> UIButton {
            let button = UIButton()
            button.layer.cornerRadius = 10
            button.imageView!.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(loadModel(sender:)), for: .touchUpInside)
            return button
        }
        
        
        let buttonChair = buttonDetail()
        buttonChair.tag = 1
        buttonChair.setBackgroundImage(UIImage (named: "chair"), for: UIControl.State.normal)
        
        let buttonTeapot = buttonDetail()
        buttonTeapot.tag = 2
        buttonTeapot.setBackgroundImage(UIImage (named: "teapot"), for: UIControl.State.normal)
        
        
        let buttonRetroTV = buttonDetail()
        buttonRetroTV.tag = 3
        buttonRetroTV.setBackgroundImage(UIImage (named: "retroTV"), for: UIControl.State.normal)
        
        let buttonGramophone = buttonDetail()
        buttonGramophone.tag = 4
        buttonGramophone.setBackgroundImage(UIImage (named: "gramophone"), for: UIControl.State.normal)
        
        
        
        
        
        //adding views
        arView.addSubview(contentView)
        contentView.addSubview(buttonChair)
        contentView.addSubview(buttonTeapot)
        contentView.addSubview(buttonRetroTV)
        contentView.addSubview(buttonGramophone)
        
        
        
        //        making constraint
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(arView)
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
            make.left.equalTo(317)
            make.bottom.equalTo(-30)
            
        }
        
        
    }
    
    
    
    
    @objc func loadModel(sender:UIButton) {
        
        //buat switch untuk nama tiap button biar bisa load modelnyaa
        var modelName = ""
        switch sender.tag {
        case 1:
            modelName = "chairReality"
        case 2:
            modelName = "teapotReality"
        case 3:
            modelName = "retroTVReality"
        case 4:
            modelName = "gramophoneReality"
        default:
            modelName = ""
        }
        
        //Show loading Indicatior
        loadingView.isHidden = false
        
        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.addAnchor(anchor)
        
        // Load model Asynchoronously so the camera doesn't have to freeze
        // Using Combine framework
        var cancellableRequest: AnyCancellable? = nil
        cancellableRequest = ModelEntity.loadModelAsync(named: modelName)
            .sink(receiveCompletion: { error in
                print("Unexpected error: \(error)")
                // cancel the request
                self.loadingView.isHidden = true
                cancellableRequest?.cancel()
            }, receiveValue: { entity in
                entity.generateCollisionShapes(recursive: true)
                
                anchor.addChild(entity)
                
                self.arView.installGestures(.all, for: entity)
                // finish the request
                self.loadingView.isHidden = true
                cancellableRequest?.cancel()
            })
        
        
    }
    
    
}

extension ARView {
    
    
    func enableObjectRemoval() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        self.addGestureRecognizer(longPressGesture)
    
        
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        
        let location = recognizer.location(in: self)
        
        
        if let entity = self.entity(at: location) {
            if let anchorEntity = entity.anchor {
                anchorEntity.removeFromParent()
            }
            
        }
        
    }
    
}




