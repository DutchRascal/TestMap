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
        if _date == nil {
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
            }
            if let max = temperture["max"] as? Double
            {
                let temperatureCelsius = Utils.kelvinToCelsius(temperature: max)
                self._maxTemp = "\(temperatureCelsius)"
            }
        }
        if let weather = forecastDictionary["weather"] as? [Dictionary<String,Any>]
        {
            if let main = weather[0]["main"] as? String{
                self._weatherDescription = main
            }
            if let icon = weather[0]["icon"] as? String
            {
                self._icon = icon
            }
        }
        if let date = forecastDictionary["dt"] as? Double
        {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()


        }
    }
}

extension Date
{
    func dayOfTheWeek() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
        
    }
}
