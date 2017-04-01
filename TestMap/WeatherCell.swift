//
//  WeatherCell.swift
//  TestMap
//
//  Created by Andre Boevink on 26/02/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    
    
    func configureCellInformation(forecast: ForeCast3Hrs)
    {
        var documentsDirectory: String?
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var file: String?
        
        dateTimeLabel.text = forecast.date
        temperature.text = forecast.temperature
        weatherDescription.text = forecast.weather
        let url = URL(string: "http://openweathermap.org/img/w/\(forecast.icon).png")
        let iconToFetch = "\(forecast.icon).png"
        if paths.count > 0
        {
            documentsDirectory = paths[0]
            file = documentsDirectory! + "/\(iconToFetch)"
            if !Utils.checkFileExists(file: iconToFetch)
            {
                let data = NSData(contentsOf: url!)
                FileManager.default.createFile(atPath: file!, contents: data! as Data, attributes: nil)
            }
            weatherIcon.image = UIImage(named: file!)
        }
    }
}
