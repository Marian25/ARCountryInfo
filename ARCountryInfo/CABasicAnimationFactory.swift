
//
//  CABasicAnimationFactory.swift
//  Advanced HitTest
//
//  Created by Marian Stanciulica on 06/11/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import UIKit

class CABasicAnimationFactory {
    
    class func addEarthAnimation() -> CABasicAnimation {
        let rotate = CABasicAnimation(keyPath: "rotation.w")
        rotate.byValue = 2 * Double.pi
        rotate.duration = 50.0
        rotate.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        rotate.repeatCount = Float.infinity
        
        return rotate
    }
    
    class func addCloudsAnimation() -> CABasicAnimation {
        let rotateClouds = CABasicAnimation(keyPath: "rotation.w")
        rotateClouds.byValue = -2 * Double.pi
        rotateClouds.duration = 150.0
        rotateClouds.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        rotateClouds.repeatCount = Float.infinity
        
        return rotateClouds
    }
    
}
