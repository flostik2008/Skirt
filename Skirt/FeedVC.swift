//
//  ViewController.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/7/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

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

    var posts = [Post]()
    var users = [User]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false

    
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
        
        // Getting posts data into users array:
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.posts.reverse()
        })
        
        // Getting users data into users array:
        DataService.ds.REF_USERS.observe(.value, with: { (snapshot) in
            self.users = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let userDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let user = User(userKey: key, userData: userDict)
                        self.users.append(user)
                    }
                }
            }
            self.tableView.reloadData()
        } )
        
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FeedVC.showPostPicVC))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
       
         let post1 = posts[indexPath.row]
        // do i save userKeys? i don't think so.
         let key = post1.userKey
         let user1 = users.filter({$0.userKey == key}).first!
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PostCell {
          
             if let img = FeedVC.imageCache.object(forKey: post1.imageUrl as NSString) {
             
             cell.configureCell(user: user1, post: post1, img: img)
             return cell
             } else {
             print("Zhenya: loading feed with user \(user1.avatarUrl) and post \(post1.imageUrl)")
             
             cell.configureCell(user: user1, post: post1)
             }
             return cell
             
            } else {
            return PostCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // custom segue methods
    func showPostPicVC() {
        self.performSegue(withIdentifier: "customSegueToPostVC", sender: self)
    }
    
    @IBAction func returnPostPicVCSegue(sender: UIStoryboardSegue){
        
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
        if let id = identifier {
            if id == "customSegueToPostVCUnwind" {
                let unwindSegue = SwipeToLeftSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)
    }
}












