//
//  SCNNodeFactory.swift
//  Advanced HitTest
//
//  Created by Marian Stanciulica on 06/11/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import SceneKit

class SCNNodeFactory {

    class func constructEarthNode(earthRadius: CGFloat) -> SCNNode {
        let earth = SCNSphere(radius: earthRadius)
        let earthMaterial = SCNMaterial()
        
        earthMaterial.diffuse.contents = UIImage(named: "art.scnassets/earth_diffuse_4k.jpg")
        earthMaterial.specular.contents = UIImage(named: "art.scnassets/earth_specular_1k.jpg")
        earthMaterial.emission.contents = UIImage(named: "art.scnassets/earth_lights_4k.jpg")
        earthMaterial.normal.contents = UIImage(named: "art.scnassets/earth_normal_4k.jpg")
        earthMaterial.multiply.contents = UIColor(white: 0.7, alpha: 1.0)
        earthMaterial.shininess = 0.05
        
        earth.firstMaterial = earthMaterial
        
        return SCNNode(geometry: earth)
    }
    
    class func constructCloudsNode(earthRadius: CGFloat, cloudsOffset: CGFloat) -> SCNNode {
        let clouds = SCNSphere(radius: earthRadius + cloudsOffset)
        clouds.segmentCount = 144
        
        let cloudsMaterial = SCNMaterial()
        cloudsMaterial.diffuse.contents = UIColor.white
        cloudsMaterial.locksAmbientWithDiffuse = true
        cloudsMaterial.transparent.contents = UIImage(named: "art.scnassets/clouds_transparent_2k.jpg")
        cloudsMaterial.transparencyMode = .rgbZero
        cloudsMaterial.writesToDepthBuffer = false
        
        guard let url = Bundle.main.url(forResource: Utils.ATMOSPHERE_SHADER_NAME, withExtension: "glsl") else {
            fatalError(Utils.ATMOSPHERE_SHADER_NAME + " doesn't exist!")
        }
        
        let shaderSource = try! String(contentsOf: url, encoding: .utf8)
        cloudsMaterial.shaderModifiers = [.fragment: shaderSource]
        clouds.firstMaterial = cloudsMaterial
        
        return SCNNode(geometry: clouds)
    }
    
    class func constructPinNode(bodyHeight: CGFloat, bodyRadius: CGFloat, headRadius: CGFloat) -> SCNNode {
        let body = SCNCylinder(radius: bodyRadius, height: bodyHeight)
        let head = SCNSphere(radius: headRadius)
        
        let bodyMaterial = SCNMaterial()
        let headMaterial = SCNMaterial()
        
        headMaterial.diffuse.contents = UIColor.red
        headMaterial.emission.contents = UIColor(red: 0.2, green: 0, blue: 0, alpha: 1)
        headMaterial.specular.contents = UIColor.white
        bodyMaterial.specular.contents = UIColor.white
        bodyMaterial.emission.contents = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        bodyMaterial.shininess = 100
        
        body.firstMaterial = bodyMaterial
        head.firstMaterial = headMaterial
        
        let bodyNode = SCNNode(geometry: body)
        bodyNode.position = SCNVector3Make(0, Float(bodyHeight / 2), 0)
        let headNode = SCNNode(geometry: head)
        headNode.position = SCNVector3Make(0, Float(bodyHeight), 0)
        
        let pinNode = SCNNode()
        pinNode.addChildNode(bodyNode)
        pinNode.addChildNode(headNode)
        
        return pinNode
    }

}
