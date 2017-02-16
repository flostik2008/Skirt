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
    
        Alamofire.request(CURRENT_WEATHER_URL, method: .get).responseJSON {response in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                if let dailyDict = dict["daily"] as? Dictionary<String,AnyObject> {
                    if let dataDict = dailyDict["data"] as? [Dictionary<String,AnyObject>]{
                        if let summary = dataDict[0]["summary"] as? String {
                            self._weatherSummery = summary
                            print("Zhenya: Summery is \(self._weatherSummery!)")
                        }
                    }
                }
            }
        completed()
        }
    
    }
    
    
}





















