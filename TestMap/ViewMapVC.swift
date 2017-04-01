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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(location)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 750, 750)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
}
