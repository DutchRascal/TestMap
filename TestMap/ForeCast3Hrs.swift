//
//  ForeCast3HrsClass.swift
//  TestMap
//
//  Created by Andre Boevink on 26/02/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit

class ForeCast3Hrs
{
    var _date: String!
    var _temperature: String!
    var _weather: String!
    var _icon: String!
    
    var date: String
    {
        if _date == nil
        {
            _date = ""
        }
        return _date
    }
    
    var temperature: String
    {
        if _temperature == nil
        {
            _temperature = ""
        }
        return _temperature
    }
    
    var weather: String
    {
        if _weather == nil
        {
            _weather = ""
        }
        return _weather
    }
    
    var icon: String
    {
        if _icon == nil
        {
            _icon = ""
        }
        return _icon
    }
    
    init(forecastDictionary: Dictionary<String, Any>)
    {
        if let main = forecastDictionary["main"] as? Dictionary<String, Any>
        {
            if let temp = main["temp"] as? Double
            {
                self._temperature = "\(Double(round(10 * (temp - 273.15))) / 10)"
            }
        }
        if let date = forecastDictionary["dt"] as? Double {
            let dateConverted = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .full
            let localTimeZone = TimeZone.current.abbreviation() ?? "UTC"
            dateFormatter.timeZone = NSTimeZone(abbreviation: localTimeZone) as TimeZone!
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = dateFormatter.string(from: dateConverted)
            self._date = dateString
        }
        
        if let weatherDescription = forecastDictionary["weather"] as? [Dictionary<String, Any>]
        {
            if let description = weatherDescription[0]["description"] as? String
            {
                self._weather = description
            }
            if let icon = weatherDescription[0]["icon"] as? String
            {
                self._icon = icon
            }
        }
    }
}

