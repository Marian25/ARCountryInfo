//
//  ViewController.swift
//  Advanced HitTest
//
//  Created by Marian Stanciulica on 06/04/2018.
//  Copyright © 2018 Marian Stanciulica. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import CoreLocation
import Alamofire
import SwiftyJSON

class EarthSimulationViewController: UIViewController, ARSCNViewDelegate, UIWebViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var webView: UIWebView?
    
    var pinNode: SCNNode?
    var earthNode: SCNNode?
    var cloudsNode: SCNNode?
    var countryPlane: SCNPlane?
    var countryInformationNode: SCNNode?
    
    var countryLabel: UILabel?
    var cloudsEnableButton: UIButton?
    var cloudsEnabled = true
    
    private let earthRadius: CGFloat = 0.2
    private let cloudsOffset: CGFloat = 0.001
    private let earthPosition = SCNVector3(0, 0, -0.6)
    private let countryInformationPosition = SCNVector3(0.4, 0, -0.6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        self.setupCountryLabel()
        self.setupCloudsEnableButton()
        self.setupCountryInformationNode()
        self.setupNodesInScene()
        
        sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sceneViewTapped)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func setupCountryInformationNode() {
        let phoneWidth = UIScreen.main.bounds.width
        let phoneHeight = UIScreen.main.bounds.height
        
        self.countryPlane = SCNPlane(width: phoneHeight / 1000, height: phoneWidth / 1000)
        self.countryInformationNode = SCNNode(geometry: self.countryPlane)
        self.countryInformationNode?.position = self.countryInformationPosition
        
        self.webView = UIWebView(frame: CGRect(x: 0, y: 0, width: phoneHeight, height: phoneWidth))
        self.webView?.delegate = self
    }
    
    func setupNodesInScene() {
        self.earthNode = SCNNodeFactory.constructEarthNode(earthRadius: earthRadius)
        self.earthNode?.position = self.earthPosition
        
        let axisNode = SCNNode()
        sceneView.scene.rootNode.addChildNode(axisNode)
        axisNode.addChildNode(earthNode!)
        
        self.cloudsNode = SCNNodeFactory.constructCloudsNode(earthRadius: earthRadius, cloudsOffset: cloudsOffset)
        
        if cloudsEnabled {
            earthNode?.addChildNode(cloudsNode!)
        }
        
        earthNode?.rotation = SCNVector4(0, 1, 0, 0)
        cloudsNode?.rotation = SCNVector4(0, 1, 0, 0)
        
        earthNode?.addAnimation(CABasicAnimationFactory.addEarthAnimation(), forKey: "rotate the earth")
        cloudsNode?.addAnimation(CABasicAnimationFactory.addCloudsAnimation(), forKey: "slowly move the clouds")
    }
    
    func requestInfo(countryName: String, completionBlock: @escaping (_ requestedURL: String) -> Void) {
        let parameters: [String:String] = [
            "format" : "json",
            "action" : "opensearch",
            "search" : "\(countryName) Geography"
        ]
        
        Alamofire.request(Utils.WIKIPEDIA_URL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let countryJSON: JSON = JSON(response.result.value!)
                
                if let jsonArray = countryJSON.array {
                    let url = jsonArray[jsonArray.count - 1][0].stringValue
                    completionBlock(url)
                }
            }
        }
    }
    
    func loadCountryInformationNodeInScene(withLocation location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            guard error == nil else { return }
            guard let country = placemarks?.first?.country else { return }
        
            self.countryLabel?.text = "Country: \(country)"
            
            DispatchQueue.main.async {
                self.requestInfo(countryName: country) { (requestedURL) in
                    let url = URL(string: requestedURL)
                    let myRequest = URLRequest(url: url!)
                    self.webView?.loadRequest(myRequest)
                    
                    self.countryPlane?.firstMaterial?.diffuse.contents = self.webView
                    self.sceneView.scene.rootNode.addChildNode(self.countryInformationNode!)
                }
            }
        }
    }
    
}

