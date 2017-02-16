//
//  Location.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/9/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import CoreLocation

class Location {

    static var sharedInstance = Location()
    let mainVC = MainVC()
    
    private init (){}
    
    
    var currentLatitude: Double!
    var currentLongitude: Double!
    var currentLocation: String!
    var currentCity: String!
    
    func getLocationName(completionHandler: @escaping (_ success: Bool) -> Void) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                completionHandler(false)
                return
            }
            if let city = addressDict["City"] as? String {
                self.currentCity = city
                print(city)
            }
            if let zip = addressDict["ZIP"] as? String {
                print(zip)
            }
            if let country = addressDict["Country"] as? String {
                print(country)
            }
            completionHandler(true)
            //self.nowUpdateUI()
        })
    }
}






