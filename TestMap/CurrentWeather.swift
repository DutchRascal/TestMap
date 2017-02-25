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
        let timeZone = NSTimeZone(name: "CET") as? TimeZone
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
            _direction = ""
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
//            debugPrint(response)
            let result = response.result
            if let currentWeatherDictionary = result.value as? Dictionary<String, Any>
            {
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
        if windDirection >= 348.75 && windDirection < 11.25
        {
            winDir = "N"
        }
        if windDirection >= 11.25 && windDirection < 33.75
        {
            winDir = "NNE"
        }
        if windDirection >= 33.75 && windDirection < 56.25
        {
            winDir = "NE"
        }
        if windDirection >= 56.25 && windDirection < 78.75
        {
            winDir = "ENE"
        }
        if windDirection >= 78.75 && windDirection < 101.25
        {
            winDir = "E"
        }
        if windDirection >= 101.25 && windDirection < 123.75
        {
            winDir = "ESE"
        }
        if windDirection >= 123.75 && windDirection < 146.25
        {
            winDir = "SE"
        }
        if windDirection >= 146.25 && windDirection < 168.75
        {
            winDir = "SSE"
        }
        if windDirection >= 168.75 && windDirection < 191.25
        {
            winDir = "S"
        }
        if windDirection >= 191.255 && windDirection < 213.75
        {
            winDir = "SSW"
        }
        if windDirection >= 213.75 && windDirection < 236.25
        {
            winDir = "SW"
        }
        if windDirection >= 236.255 && windDirection < 258.75
        {
            winDir = "WSW"
        }
        if windDirection >= 258.75 && windDirection < 281.25
        {
            winDir = "W"
        }
        if windDirection >= 281.25 && windDirection < 303.75
        {
            winDir = "WNW"
        }
        if windDirection >= 303.75 && windDirection < 326.25
        {
            winDir = "NW"
        }
        if windDirection >= 326.25 && windDirection < 348.75
        {
            winDir = "NNW"
        }
        return winDir
    }
}


