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
    @IBOutlet weak var outfitImg: UIImageView!
    @IBOutlet weak var currentWeatherImg: UIImageView!
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
            
            if Location.sharedInstance.currentLatitude != nil {
                Location.sharedInstance.currentLatitude = currentLocation.coordinate.latitude
            } else {
                Location.sharedInstance.currentLatitude = 37.773972
            }
            if Location.sharedInstance.currentLongitude != nil {
                Location.sharedInstance.currentLongitude = currentLocation.coordinate.longitude
            } else {
                Location.sharedInstance.currentLongitude = -122.431297
            }
            
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
        rainChanceLbl.text = "%\(currentWeather.rainChance)"
        tempLbl.text = "\(currentWeather.currentTemp)°"
        weatherSummeryLbl.text = currentWeather.weatherSummery
        
        currentWeatherImg.image = UIImage(named: currentWeather.weatherTypeIcon)
    
        outfitImg.image = UIImage(named: currentWeather.outfitForWeather)
    }
    
    
    func addGradient(color: UIColor, view: UIView) {
        
        /*
         let gradient = CAGradientLayer()
         let gradientOrigin = view.bounds.origin
         let huy = UIScreen.main.bounds.width
         let gradientSize = CGSize(width: huy, height: CGFloat(100))
         gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
         
         let bottomColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:0.9)
         gradient.colors = [color.cgColor, bottomColor.cgColor]
         
         view.layer.insertSublayer(gradient, at: 0)
         */
        
        let gradient = CAGradientLayer()
        let gradientOrigin = view.bounds.origin
        let gradientWidth = UIScreen.main.bounds.width
        let gradientHeight = view.bounds.height
        let gradientSize = CGSize(width: gradientWidth, height: gradientHeight)
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        
        let bottomColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:0.7)
        gradient.colors = [color.cgColor, bottomColor.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
}
