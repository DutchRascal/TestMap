//
//  Location.swift
//  rainyshinycloudy
//
//  Created by Andre Boevink on 29/01/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
