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
import GeoFire

class MainFeedVC: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate  {

    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var weatherTypeImg: UIImageView!
    @IBOutlet weak var rainChanceLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherSummeryLbl: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    
    var currentWeather: CurrentWeather!

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!

    var posts = [Post]()
    var nearbyPostsKeys = [String]()
    
    var users = [User]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    var isConvertedToCel = false
    
    var avatarUrlRef: FIRDatabaseReference!
    var usernameRef: FIRDatabaseReference!
    var genderRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationAuthStatus()
        
        currentWeather = CurrentWeather()
        
        addGradient(color: UIColor.clear, view: gradientView)

        let tempLblTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainFeedVC.convertDegrees))
        tempLblTap.delegate = self
        tempLblTap.numberOfTapsRequired = 1
        self.tempLbl.isUserInteractionEnabled = true
        self.tempLbl.addGestureRecognizer(tempLblTap)
        
        let leftSwipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MainFeedVC.showPostPicVC))
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        let rightSwipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(MainFeedVC.showUserVC))
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)
        
   NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name:NSNotification.Name(rawValue: "postWasLiked"), object: nil)

    }
    
   
    func reloadTableView(_ notification: NSNotification){
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check if user has username/userpic/gender chosen. no -> go to CreasteUsernameVC.
        avatarUrlRef = DataService.ds.REF_USER_CURRENT.child("avatarUrl")
        
        avatarUrlRef.observe(.value, with:{ (snapshot) in
            let snapshotValue = snapshot.value as? String
            
            if snapshotValue == nil || snapshotValue == "" {
                self.performSegue(withIdentifier: "FeedVCtoCreateUsernameVC", sender: nil)
                print("Zhenya: didn't find avatar for this user")
            }
            
            self.usernameRef = DataService.ds.REF_USER_CURRENT.child("username")
            self.usernameRef.observe(.value, with:{ (snapshot) in
                let snapshotValue = snapshot.value as? String
                
                if snapshotValue == nil || snapshotValue == "" {
                    
                    print("Zhenya: didn't find username for this user")
                    self.performSegue(withIdentifier: "FeedVCtoCreateUsernameVC", sender: nil)
                }
                
                self.genderRef = DataService.ds.REF_USER_CURRENT.child("gender")
                self.genderRef.observe(.value, with:{ (snapshot) in
                    let snapshotValue = snapshot.value as? String
                    
                    if snapshotValue == nil || snapshotValue == "" {
                        
                        print("Zhenya: didn't find gender for this user")
                        self.performSegue(withIdentifier: "FeedVCtoCreateUsernameVC", sender: nil)
                    }
                })
            })
        })
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationAuthStatus()
        
        posts.removeAll()
        users.removeAll()
        
        // get only local posts (letter: also created today)
        // call for function that is declared outside of viewDidLoad, that populates 'posts'.
        //populate 'posts' based on 'nearby..'
        
        let theGeoFire = GeoFire(firebaseRef: DB_BASE.child("posts_location"))
        let location = CLLocation(latitude: Location.sharedInstance.currentLatitude, longitude: Location.sharedInstance.currentLongitude)
        let circleQuery = theGeoFire!.query(at: location, withRadius: 6.0)
        
        _ = circleQuery!.observe(.keyEntered, with: { (key, location) in
            
            _ = DataService.ds.REF_POSTS.child(key!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    let post = Post(postKey: key, postData: postDict)
                    self.posts.append(post)
                    
                    
                    let userId = postDict["userKey"] as! String
                    
                    _ = DataService.ds.REF_USERS.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let userDict = snapshot.value as? Dictionary<String,AnyObject>{
                            let key = snapshot.key
                            let user = User(userKey: key, userData: userDict)
                            self.users.append(user)
                        }
                        self.tableView.reloadData()
                    })
                }
                self.posts.sort(by:{ $0.date > $1.date })
                
            })
        })
        
        tableView.reloadData()
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
            if currentWeather != nil {
                currentWeather.downloadWeatherDetails{
                    self.updateMainUI()
                }
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
        
        let key = post1.userKey
        let user1 = users.filter({$0.userKey == key}).first!
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? PostCell {
          
             if let img = MainFeedVC.imageCache.object(forKey: post1.imageUrl as NSString) {
             
             cell.configureCell(user: user1, post: post1, img: img)
             return cell
             } else {
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
    
    func showPostPicVC() {
        self.performSegue(withIdentifier: "customSegueToPostVC", sender: self)
    }
    
    func showUserVC(){
        self.performSegue(withIdentifier: "UserVCFromFeedVC", sender: self)
    }
    
    
    @IBAction func returnPostPicVCSegue(sender: UIStoryboardSegue){
        
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
        if let id = identifier {
            if id == "customSegueToPostVCUnwind" {
                let unwindSegue = SwipeToLeftSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            } else if id == "customSegueToUserVCUnwind" {
                let unwindSegue = SwipeToRightSegueUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: {()-> Void in
                    
                
                })
                return unwindSegue
            }
        }
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)
    }
    
    @IBAction func returnUserVCSegue(sender: UIStoryboardSegue) {
    
    }

    
    
    func convertDegrees(sender: UITapGestureRecognizer){
       /*
        let currentTemp = tempLbl.text
        let currentTempJustDigits = currentTemp!.substring(to: currentTemp!.index(before: currentTemp!.endIndex))
            
       
        let currentTempAsDouble = Double(currentTempJustDigits)
        
        if isConvertedToCel{
            //convert to far (C * 9/5) + 32
            let convertedToFar = (currentTempAsDouble! * (9/5)) + 32
            let convertedToFarInt = Int(convertedToFar)
            let convertedToFarString = String(convertedToFarInt) + String("˚")
            tempLbl.text = convertedToFarString
            isConvertedToCel = false
            print("Zhenya: while 'isConvertedToCel' = \(isConvertedToCel), conv from F to C = \(convertedToFarString)")
            
        } else {
            //convert to cel (F - 32) * 5/9
            let convertedToCel = (currentTempAsDouble! - 32) * (5/9)
            let convertedToCelInt = Int(convertedToCel)
            let convertedToCelString = String(convertedToCelInt) + String("˚")
            tempLbl.text = convertedToCelString
            isConvertedToCel = true
            print("Zhenya: while 'isConvertedToCel' = \(isConvertedToCel), conv from F to C = \(convertedToCelString)")
        }
    }
    */
        
        if isConvertedToCel{
        
            tempLbl.text = "\(currentWeather.currentTemp)°"
            isConvertedToCel = false
        } else {
            
            let currentTemp = tempLbl.text
            let currentTempJustDigits = currentTemp!.substring(to: currentTemp!.index(before: currentTemp!.endIndex))
            let currentTempAsInt = Int(currentTempJustDigits)
            print("Zhenya: currentTempAsInt is \(currentTempAsInt)")
            
            let tempInC = currentWeather.convertToC(temp: currentTempAsInt!)
            
            print("Zhenya: tempInC is \(tempInC)")

            tempLbl.text = "\(tempInC)°"
            isConvertedToCel = true
        }
    }
}












