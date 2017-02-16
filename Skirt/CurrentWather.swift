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
    var _outfitForWeather: String!
    
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
    
    var outfitForWeather: String {
        if _outfitForWeather == nil {
            _outfitForWeather = ""
        }
        return _outfitForWeather
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
                    }
                }
                
                if let hourlyDict = dict["hourly"] as? Dictionary<String,AnyObject> {
                    if let dataDict = hourlyDict["data"] as? [Dictionary<String,AnyObject>]{
                        if let icon = dataDict[0]["icon"] as? String {
                            self._weatherTypeIcon = icon
                            print(icon)
                        }
                        
                        if let precipProbability = dataDict[0]["precipProbability"] as? Double {
                            let probabilityInPercents = precipProbability * 100
                            let probabilityInt: Int = Int(probabilityInPercents)
                            self._rainChance = probabilityInt
                            print(probabilityInt)
                        }                    }
                }
                
                if let currentlyDict = dict["currently"] as? Dictionary<String,AnyObject> {
                    if let currentTemp = currentlyDict["temperature"] as? Int{
                        self._currentTemp = currentTemp
                        self.setOutfit()
                        
                    }
                }
            }
        completed()
        }
    
    }
    
    func setOutfit () {
        if self._currentTemp >= 74 {
            if self._weatherTypeIcon == "rain"{
                self._outfitForWeather = "1.7w"
            }
            else {
                let x = Int(arc4random_uniform(6)+1)
                self._outfitForWeather = "1.\(x)w"
            }
        } else if self.currentTemp < 74 && self.currentTemp >= 62{
            
            if self._weatherTypeIcon == "rain"{
                self._outfitForWeather = "2.7w"
            }
            else {
                let x = Int(arc4random_uniform(6)+1)
                self._outfitForWeather = "2.\(x)w"
            }
            
        } else if self.currentTemp < 62 && self.currentTemp >= 53{
            
            if self._weatherTypeIcon == "rain"{
                self._outfitForWeather = "3.7w"
            }
            else {
                let x = Int(arc4random_uniform(6)+1)
                self._outfitForWeather = "3.\(x)w"
            }
            
        } else if self.currentTemp < 53 && self.currentTemp >= 41{
            
            if self._weatherTypeIcon == "rain"{
                self._outfitForWeather = "4.7w"
            }
            else {
                let x = Int(arc4random_uniform(6)+1)
                self._outfitForWeather = "4.\(x)w"
            }
            
        } else if self.currentTemp < 41 && self.currentTemp >= 32{
            
            if self._weatherTypeIcon == "rain"{
                self._outfitForWeather = "5.7w"
            }
            else {
                let x = Int(arc4random_uniform(6)+1)
                self._outfitForWeather = "5.\(x)w"
            }
            
        } else if self.currentTemp < 32 && self.currentTemp >= 19{
            let x = Int(arc4random_uniform(6)+1)
            self._outfitForWeather = "6.\(x)w"
        } else if self.currentTemp < 19 && self.currentTemp >= 5{
            let x = Int(arc4random_uniform(7)+1)
            self._outfitForWeather = "7.\(x)w"
        } else if self.currentTemp < 5 {
            self._outfitForWeather = "8w"
        }
        
        
    }
}





















