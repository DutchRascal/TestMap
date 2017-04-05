//
//  Functions.swift
//  TestAlamofire
//
//  Created by Andre Boevink on 04/03/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit
import MapKit

class Utils: UIViewController
{
    
    class func checkFileExists(file: String) -> Bool
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(file)?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            return true
        } else
        {
            return false
        }
    }
    
    class func updateCoordinates(location: CLLocation)
    {
        let currentLocation = location
        Location.sharedInstance.latitude = currentLocation.coordinate.latitude
        Location.sharedInstance.longitude = currentLocation.coordinate.longitude
        CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics"
        FORECAST_URL  = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics"
        FORECAST3HR_URL  = "http://api.openweathermap.org/data/2.5/forecast?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics"
    }
    
    class func kelvinToCelsius(temperature: Double) -> Double
    {
        return (Double(round(10 * (temperature - 273.15))) / 10)
    }


}
