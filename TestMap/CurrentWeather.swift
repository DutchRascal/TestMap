//
//  CurrentWeather.swift
//  TestMap
//
//  Created by Andre Boevink on 19/02/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit
import Alamofire


class CurrentWeather {
    var _cityName: String!
    var _icon: String!
    var _date: String!
    var _time: String!
    var _temperature: Double!
    var _minTemperature: Double!
    var _maxTemperature: Double!
    var _direction: String!
    var _speed: Double!
    var _weatherDescription: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var icon: String {
        if _icon == nil {
            _icon = ""
        }
        return _icon
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var time: String {
        if _time == nil {
            _time = ""
        }
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeFormatter.dateFormat = "k:mm"
        let timeZone = NSTimeZone(name: "CET") as TimeZone?
        timeFormatter.timeZone = timeZone
        let currentTime = timeFormatter.string(from: Date())
        self._time = currentTime
        return _time
    }
    
    var temperature: Double {
        if _temperature == nil {
            _temperature = 0.0
        }
        return _temperature
    }
    
    var minTemperature: Double {
        if _minTemperature == nil {
            _minTemperature = 0.0
        }
        return _minTemperature
    }
    
    var maxTemperature: Double {
        if _maxTemperature == nil {
            _maxTemperature = 0.0
        }
        return _maxTemperature
    }
    
    var speed: Double {
        if _speed == nil {
            _speed = 0.0
        }
        return _speed
    }
    
    var direction: String {
        if _direction == nil {
            _direction = "?"
        }
        return _direction
    }
    
    var weatherDescription: String {
        if _weatherDescription == nil {
            _weatherDescription = ""
        }
        return _weatherDescription
    }
    
    func downloadCurrentWeather(completed: @escaping DownloadComplete)
    {
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            if let currentWeatherDictionary = result.value as? Dictionary<String, Any>
            {
                if let _ = currentWeatherDictionary["cod"] as? Double
                {
                    self._cityName = "Service unavailable ..."
                }
                if let name = currentWeatherDictionary["name"] as? String {
                    self._cityName = name.capitalized
                }
                
                if let weather = currentWeatherDictionary["weather"] as? [Dictionary<String, Any>]
                {
                    if let icon = weather[0]["icon"] as? String
                    {
                        self._icon = icon
                    }
                    if let weatherDescription = weather[0]["main"] as? String
                    {
                        self._weatherDescription = weatherDescription
                    }
                }
                if let main = currentWeatherDictionary["main"] as? Dictionary<String, Any>
                {
                    if let temperature = main["temp"] as? Double
                    {
                        self._temperature = self.kelvinToCelsius(temperature: temperature)
                    }
                    if let minTemperature = main["temp_min"] as? Double
                    {
                        self._minTemperature = self.kelvinToCelsius(temperature: minTemperature)
                    }
                    if let maxTemperature = main["temp_max"] as? Double
                    {
                        self._maxTemperature = self.kelvinToCelsius(temperature: maxTemperature)
                    }
                }
                if let windInformation = currentWeatherDictionary["wind"] as? Dictionary<String, Any>
                {
                    if let speed = windInformation["speed"] as? Double
                    {
                        self._speed = speed
                    }
                    if let deg = windInformation["deg"] as? Double
                    {
                        self._direction = self.windDirection(windDirection: deg)
                    } 
                }
                
                
            }
            completed()
        }
    }
    
    func kelvinToCelsius(temperature: Double) -> Double
    {
        return (Double(round(10 * (temperature - 273.15))) / 10)
    }
    
    func windDirection(windDirection: Double) -> String
    {
        var winDir = ""
        
        switch windDirection
        {
        case 0..<11.25 :
            winDir = "N"
        case 11.25..<33.75 :
            winDir = "NNE"
        case 33.75..<56.25 :
            winDir = "NE"
        case 56.25..<78.75:
            winDir = "ENE"
        case 78.75..<101.25:
            winDir = "E"
        case 101.25..<123.75:
            winDir = "ESE"
        case 123.75..<146.25:
            winDir = "SE"
        case 146.25..<168.75:
            winDir = "SSE"
        case 168.75..<191.25:
            winDir = "S"
        case 191.255..<213.75:
            winDir = "SSW"
        case 213.75..<236.25:
            winDir = "SW"
        case 236.255..<258.75:
            winDir = "WSW"
        case 258.75..<281.25:
            winDir = "W"
        case 281.25..<303.75:
            winDir = "WNW"
        case 303.75..<326.25:
            winDir = "NW"
        case 326.25..<348.75:
            winDir = "NNW"
        case 348.75...360 :
            winDir = "N"
        default:
            winDir = "?"
        }
        
        return winDir
    }
}


