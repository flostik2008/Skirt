//
//  ViewController.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import CoreLocation

class MainVC: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var weatherTypeImg: UIImageView!
    @IBOutlet weak var rainChanceLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherSummeryLbl: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    
    var currentWeather: CurrentWeather!

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather()
        
        addGradient(color: UIColor.clear, view: gradientView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location
            
            Location.sharedInstance.currentLatitude = currentLocation.coordinate.latitude
            Location.sharedInstance.currentLongitude = currentLocation.coordinate.longitude
            
            Location.sharedInstance.getLocationName { (success) in
                if success {
                        self.updateLocatinLabel()
                }
            }
            
            currentWeather.downloadWeatherDetails{
                 self.updateMainUI()
            }
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func updateLocatinLabel() {
            cityLbl.text = Location.sharedInstance.currentCity
    }
    
    func updateMainUI() {
        // update UI based on currentWeather properties.
        // 
        
        
    }
    
    func addGradient(color: UIColor, view: UIView) {
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
