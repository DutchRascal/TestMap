//
//  Forecast.swift
//  TestMap
//
//  Created by Andre Boevink on 20/03/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit

class Forecast {
    
    var _date: String!
    var _weatherDescription: String!
    var _maxTemp: String!
    var _minTemp: String!
    var _icon: String!
    
    var date: String {
        if _date == "" {
            _date = ""
        }
        return _date
    }
    
    var weatherDescription: String {
        if _weatherDescription == nil {
            _weatherDescription = ""
        }
        return _weatherDescription
    }
    
    var minTemp: String {
        if _minTemp == nil {
            _minTemp = ""
        }
        return _minTemp
    }
    
    var maxTemp: String {
        if _maxTemp == nil {
            _maxTemp = ""
        }
        return _maxTemp
    }
    
    var icon: String {
        if _icon == nil {
            _icon = ""
        }
        return _icon
    }
    
    init(forecastDictionary: Dictionary<String, Any>)
    {
        if let temperture = forecastDictionary["temp"] as? Dictionary<String,Any>
        {
            if let min = temperture["min"] as? Double
            {
                let temperatureCelsius = Utils.kelvinToCelsius(temperature: min)
                self._minTemp = "\(temperatureCelsius)"
                print("Min: \(_minTemp)")
            }
            if let max = temperture["max"] as? Double
            {
                let temperatureCelsius = Utils.kelvinToCelsius(temperature: max)
                self._maxTemp = "\(temperatureCelsius)"
                print("Max: \(_maxTemp)")
            }
            
        }
        if let weather = forecastDictionary["weather"] as? [Dictionary<String,Any>]
        {
            if let main = weather[0]["main"] as? String{
                self._weatherDescription = main
                print("Description: \(_weatherDescription)")
            }
        }
    }
    
    
}
