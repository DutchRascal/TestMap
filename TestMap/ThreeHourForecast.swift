//
//  ThreeHourForecast.swift
//  TestMap
//
//  Created by Andre Boevink on 25/02/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.


import UIKit
import MapKit
import Alamofire

class ThreeHourForecast: UIViewController
{
    
    var forecast: ForeCast3Hrs!
    var forecasts = [ForeCast3Hrs]()
    var dateText = ""
    
    
    func downloadForecastData(completed: @escaping DownloadComplete)
    {
        Alamofire.request(FORECAST3HR_URL).responseJSON
            { response in
                let result = response.result
                if let forecast3HrDictionary = result.value as? Dictionary<String, Any>
                {
                    if let list = forecast3HrDictionary["list"] as? [Dictionary<String, Any>]
                    {
                        for object in list
                        {
                                                        let forecast = ForeCast3Hrs(forecastDict: object)
                            self.forecasts.append(forecast)
                        }
                    }
                }
                completed()
        }
    }
}
