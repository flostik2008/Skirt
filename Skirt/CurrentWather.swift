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
    var _currentTemp: Int!
    var _rainChance: Int!
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
    
    var currentTemp: Int {
        if _currentTemp == nil {
            _currentTemp = 0
        }
        return _currentTemp
    }
    
    var rainChance: Int {
        if _rainChance == nil {
            _rainChance = 0
        }
        return _rainChance
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
                            
                        }
                        
                        if let icon = dataDict[0]["icon"] as? String {
                            self._weatherTypeIcon = icon
                            
                        }
                        
                        if let precipProbability = dataDict[0]["precipProbability"] as? Double {
                            let probabilityInPercents = precipProbability * 100
                            let probabilityInt: Int = Int(probabilityInPercents)
                            self._rainChance = probabilityInt
                            
                        }
                    }
                }
                
                if let currentlyDict = dict["currently"] as? Dictionary<String,AnyObject> {
                    if let currentTemp = currentlyDict["temperature"] as? Int{
                        self._currentTemp = currentTemp
                        
                    }
                }
            }
        completed()
        }
    
    }
    
    
}





















