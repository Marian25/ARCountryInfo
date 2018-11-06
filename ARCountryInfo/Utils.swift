//
//  Utils.swift
//  Advanced HitTest
//
//  Created by Marian Stanciulica on 06/11/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import SceneKit
import CoreLocation

class Utils {
    
    static let ORIGINAL_CLOUD_IMAGE_NAME = "art.scnassets/cloud.png"
    static let WIKIPEDIA_URL = "https://en.wikipedia.org//w/api.php"
    static let ATMOSPHERE_SHADER_NAME = "AtmosphereHalo"

}

extension SCNVector3 {

    static func dotProduct(vectorA: SCNVector3, vectorB:SCNVector3) -> Float {
        return (vectorA.x * vectorB.x) + (vectorA.y * vectorB.y) + (vectorA.z * vectorB.z)
    }

    static func crossProduct(vectorA: SCNVector3, vectorB: SCNVector3) -> SCNVector3 {
        let computedX = (vectorA.y * vectorB.z) - (vectorA.z * vectorB.y)
        let computedY = (vectorA.z * vectorB.x) - (vectorA.x * vectorB.z)
        let computedZ = (vectorA.x * vectorB.y) - (vectorA.y * vectorB.x)
        
        return SCNVector3(computedX, computedY, computedZ)
    }
}

extension CLLocation {

    convenience init(coordinateFromPoint point: CGPoint) {
        let u = Double(point.x)
        let v =  Double(point.y)
        
        let lat: CLLocationDegrees = (0.5 - v) * 180.0
        let lon: CLLocationDegrees = (u - 0.5) * 360.0
        
        self.init(latitude: lat, longitude: lon)
    }
}
