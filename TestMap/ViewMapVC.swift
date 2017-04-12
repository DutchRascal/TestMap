//
//  ViewMapVC.swift
//  TestMap
//
//  Created by Andre Boevink on 24/02/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit
import MapKit

class ViewMapVC: UIViewController
{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation!
    var addressText = ""

    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil
            {
                print("There was an error")
            }
            else
            {
                if let place = placemark?[0]
                {
                    if let thoroughfare = place.thoroughfare
                    {
                        self.addressText += "\(thoroughfare)"
                    }
                    if let city = place.locality
                    {
                        self.addressText += "\n\(city)"
                    }
                    self.addressLabel.text = self.addressText
                }
            }
        }
//        print(location)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 750, 750)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}
