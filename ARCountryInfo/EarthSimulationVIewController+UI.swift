//
//  EarthSimulationVIewController+UI.swift
//  Advanced HitTest
//
//  Created by Marian Stanciulica on 06/11/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit
import CoreLocation
import SceneKit

extension EarthSimulationViewController {
    
    func setupCountryLabel() {
        self.countryLabel = UILabel()
        self.countryLabel?.text = "Tap on EARTH"
        self.countryLabel?.backgroundColor = UIColor(white: 0, alpha: 0.4)
        self.countryLabel?.textAlignment = .center
        self.countryLabel?.textColor = .white
        self.countryLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        self.sceneView.addSubview(self.countryLabel!)
        
        self.countryLabel?.leftAnchor.constraint(equalTo: self.sceneView.leftAnchor, constant: 8).isActive = true
        self.countryLabel?.rightAnchor.constraint(equalTo: self.sceneView.rightAnchor, constant: -8).isActive = true
        self.countryLabel?.bottomAnchor.constraint(equalTo: self.sceneView.bottomAnchor, constant: -8).isActive = true
        self.countryLabel?.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    func setupCloudsEnableButton() {
        self.cloudsEnableButton = UIButton()
        self.cloudsEnableButton?.setImage(UIImage(named: Utils.ORIGINAL_CLOUD_IMAGE_NAME), for: .normal)
        self.cloudsEnableButton?.translatesAutoresizingMaskIntoConstraints = false
        
        self.sceneView.addSubview(self.cloudsEnableButton!)
        
        self.cloudsEnableButton?.rightAnchor.constraint(equalTo: self.sceneView.rightAnchor, constant: -8).isActive = true
        self.cloudsEnableButton?.topAnchor.constraint(equalTo: self.sceneView.topAnchor, constant: 8).isActive = true
        self.cloudsEnableButton?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.cloudsEnableButton?.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.cloudsEnableButton?.addTarget(self, action: #selector(cloudsEnableButtonTapped), for: .touchUpInside)
    }
    
    @objc func cloudsEnableButtonTapped() {
        if cloudsEnabled {
            self.earthNode?.addChildNode(cloudsNode!)
            self.cloudsEnableButton?.setImage(UIImage(named: Utils.ORIGINAL_CLOUD_IMAGE_NAME), for: .normal)
        } else {
            cloudsNode?.removeFromParentNode()
            let tintedImage = UIImage(named: Utils.ORIGINAL_CLOUD_IMAGE_NAME)?.withRenderingMode(.alwaysTemplate)
            self.cloudsEnableButton?.setImage(tintedImage, for: .normal)
            self.cloudsEnableButton?.tintColor = UIColor(white: 1, alpha: 0.4)
        }
        
        cloudsEnabled = !cloudsEnabled
    }
    
    @objc func sceneViewTapped(_ gesture: UITapGestureRecognizer) {
//        self.countryInformationNode?.removeFromParentNode()
        
        let eventLocation = gesture.location(in: self.sceneView)
        let hitResults = sceneView.hitTest(eventLocation, options: [.rootNode: self.earthNode!, .ignoreChildNodes: true])
        
        guard let hit = hitResults.first else { return }
        
        let textureCoordinate = hit.textureCoordinates(withMappingChannel: 0)
        let location =  CLLocation(coordinateFromPoint: textureCoordinate)
        
        self.loadCountryInformationNodeInScene(withLocation: location)
        
        self.pinNode?.removeFromParentNode()
        self.pinNode = SCNNodeFactory.constructPinNode(bodyHeight: 0.005, bodyRadius: 0.0002, headRadius: 0.001)
        self.earthNode?.addChildNode(pinNode!)
        self.pinNode?.position = hit.localCoordinates
        
        let pinDirection = SCNVector3Make(0, 1, 0)
        let normal = hit.localNormal
        
        let rotationAxis = SCNVector3.crossProduct(vectorA: pinDirection, vectorB: normal)
        let cosAngle = SCNVector3.dotProduct(vectorA: pinDirection, vectorB: normal)
        
        self.pinNode?.rotation = SCNVector4Make(rotationAxis.x, rotationAxis.y, rotationAxis.z, acos(cosAngle))
    }
    
}
