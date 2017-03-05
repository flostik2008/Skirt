//
//  ViewController.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import CoreLocation

class FeedVC: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var weatherTypeImg: UIImageView!
    @IBOutlet weak var rainChanceLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherSummeryLbl: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentWeather: CurrentWeather!

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!

    var posts = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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

//            if Location.sharedInstance.currentLongitude != nil {
//                Location.sharedInstance.currentLongitude = currentLocation.coordinate.longitude
//            } else {
//                Location.sharedInstance.currentLongitude = -149.863129
//            }
            
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
    
    //    outfitImg.image = UIImage(named: currentWeather.outfitForWeather)
    }
    
    func addGradient(color: UIColor, view: UIView) {
        
        let gradient = CAGradientLayer()
        let gradientOrigin = view.bounds.origin
        let gradientWidth = UIScreen.main.bounds.width
        let gradientHeight = view.bounds.height
        let gradientSize = CGSize(width: gradientWidth, height: gradientHeight)
        gradient.frame = CGRect(origin: gradientOrigin, size: gradientSize)
        
        let bottomColor = UIColor(red:0.07, green:0.07, blue:0.07, alpha:0.5)
        gradient.colors = [color.cgColor, bottomColor.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return posts.count
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

}












