//
//  Constants.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 2/10/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import Foundation

// https://api.darksky.net/forecast/1b942a63046402bdfd204924e57119aa/37.8267,-122.4233
// https://api.darksky.net/forecast/[key]/[latitude],[longitude]


let BASE_URL = "https://api.darksky.net/forecast/"

let API_KEY = "1b942a63046402bdfd204924e57119aa"

typealias DownloadComplete = ()->()

let CURRENT_WEATHER_URL = "https://api.darksky.net/forecast/\(API_KEY)/\(Location.sharedInstance.currentLatitude!),\(Location.sharedInstance.currentLongitude!)"

