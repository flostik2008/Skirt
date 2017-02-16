//
//  CurrentWather.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/10/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    var _cityName: String!
    var _weatherTypeIcon: String!
    var _currentTemp: Double!
    var _weatherSummery: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }

    var weatherTypeIcon: String {
        if _weatherTypeIcon == nil {
            _weatherTypeIcon = ""
        }
        return _weatherTypeIcon
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    var weatherSummery: String {
        if _weatherSummery == nil {
            _weatherSummery = ""
        }
        return _weatherSummery
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
    
        // build a url link. call Alamofire.request(   )
        Alamofire.request(CURRENT_WEATHER_URL, method: .get).responseJSON {response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                
                
                
                
            }
        completed()
        }
    
    }
    
    
}





















