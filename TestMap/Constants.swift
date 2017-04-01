//
//  Constants.swift
//  rainyshinycloudy
//
//  Created by Andre Boevink on 28/01/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import Foundation

struct Constants
{
    static var allowForecastToBeLoaded = true
}

typealias DownloadComplete = () -> ()

var CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics"

var FORECAST_URL  = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics"

var FORECAST3HR_URL  = "http://api.openweathermap.org/data/2.5/forecast?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics"

