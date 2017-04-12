//
//  cityVC.swift
//  TestMap
//
//  Created by Andre Boevink on 04/04/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit

class cityVC: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    var cityName: String!
    var sunrise: String!
    var sunset: String!
    var pressure: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = cityName
        sunriseLabel.text = sunrise
        sunsetLabel.text = sunset
        pressureLabel.text = "\(pressure!)"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
