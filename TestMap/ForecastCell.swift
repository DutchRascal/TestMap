//
//  ForecastCell.swift
//  TestMap
//
//  Created by Andre Boevink on 19/03/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    func configureCell(forecast: Forecast){
        
        var documentsDirectory: String?
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        var file: String?
        let iconToFetch = "\(forecast.icon).png"
        let url = URL(string: "http://openweathermap.org/img/w/\(iconToFetch)")
        
        if paths.count > 0
        {
            documentsDirectory = paths[0]
            file = documentsDirectory! + "/\(iconToFetch)"
            if !Utils.checkFileExists(file: iconToFetch)
            {
                let data = NSData(contentsOf: url!)
                FileManager.default.createFile(atPath: file!, contents: data! as Data, attributes: nil)
            }
        }
        weatherImage.image = UIImage(named: file!)
        
        minTemp.text = "\(forecast.minTemp)"
        maxTemp.text = "\(forecast.maxTemp)"
        
        
        weatherDescription.text = "\(forecast.weatherDescription)"
        dateLabel.text = forecast.date
    }
}
