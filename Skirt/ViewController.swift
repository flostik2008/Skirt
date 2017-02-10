//
//  ViewController.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var gradientView: UIView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        gradientForDitailsVC(color: UIColor.clear, view: gradientView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location
            
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            // download data from Dark Sky API
        
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func gradientForDitailsVC(color: UIColor, view: UIView) {
        let gradient = CAGradientLayer()
        
        let gradientOrigin = view.bounds.origin
        let gradientWidth = view.bounds.width
        let gradientHeight = view.bounds.height
        let gradientSize = CGSize(width: gradientWidth, height: gradientHeight)
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        
        let bottomColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:0.5)
        gradient.colors = [color.cgColor, bottomColor.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}
