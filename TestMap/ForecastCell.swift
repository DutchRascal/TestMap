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
        minTemp.text = "\(forecast.minTemp)"
        maxTemp.text = "\(forecast.maxTemp)"
        weatherDescription.text = "\(forecast.weatherDescription)"
//        weatherImage = UIImage(named: forecast.weatherDescription)
        dateLabel.text = forecast.date
    }
}
