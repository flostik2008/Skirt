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
    private init (){}
    
    var latitude: Double!
    var longitude: Double!
}
