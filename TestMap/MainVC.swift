//
//  ViewController.swift
//  TestMap
//
//  Created by Andre Boevink on 18/02/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit
import MapKit

class MainVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var weatherSymbol: UIImageView!
    @IBOutlet weak var timeLastUpdated: UILabel!
    @IBOutlet weak var dateToday: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var weatherDesription: UILabel!
    @IBOutlet weak var windDescription: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    
    let locationManager = CLLocationManager()
    var currenLocation: CLLocation?
    var haveFix = false
    var timeoutTimer: Timer?
    var updateTimer: Timer?
    var currentWeather: CurrentWeather!
    var allowedUpdate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .standard
        currentCityName.text = "Looking for a fix ..."
        locationManager.delegate = self
        mapView.delegate = self
        startStopLocationMangager(state: "start")
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.willEnterBackground),
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
        if !haveFix
        {
            updateTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector (updateAllowedDownload), userInfo: nil, repeats: false)
        }
        mapButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationAuthStatus()
        
    }
    
    func updateAllowedDownload ()
    {
        allowedUpdate = true
        updateTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector (updateAllowedDownload), userInfo: nil, repeats: false)
        startStopLocationMangager(state: "start")
        getLocation(location: currenLocation!)
        if haveFix
        {
            handleDownloadWeather()
            allowedUpdate = false
            startStopLocationMangager(state: "stop")
        }
        
    }
    
    func startStopLocationMangager(state: String) {
        if state == "start" {
            locationManager.startUpdatingLocation()
            timeoutTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(timeOutDetected), userInfo: nil, repeats: false)
            print("*** \(currentWeather?.time) Start updating ***")
        } else if state == "stop" {
            if let timer = timeoutTimer {
                timer.invalidate()
            }
            locationManager.stopUpdatingLocation()
            print("*** \(currentWeather?.time) Stop updating ***")
        }
    }
    
    func timeOutDetected() {
        startStopLocationMangager(state: "stop")
        print("No fix ....")
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            if let currenLocation = locationManager.location
            {
                Location.sharedInstance.longitude = currenLocation.coordinate.longitude
                Location.sharedInstance.latitude = currenLocation.coordinate.latitude
            }
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 4000, 4000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        getLocation(location: location)
        if haveFix
        {
            handleDownloadWeather()
            allowedUpdate = false
            startStopLocationMangager(state: "stop")
        }
        
    }
    
    func getLocation(location: CLLocation)
    {
        haveFix = false
        mapButton.isEnabled = false
        //        print(location)
        //        centerMapOnLocation(location: location)
        
        
        if location.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if location.horizontalAccuracy < 0 {
            return
        }
        
        if location.horizontalAccuracy <= locationManager.desiredAccuracy {
            centerMapOnLocation(location: location)
            updateCoordinates(location: location)
            haveFix = true
            mapButton.isEnabled = true
            //            allowedUpdate = false
            print("*** We have a fix! ***")
        }
        centerMapOnLocation(location: location)
        
    }
    
    func updateCoordinates(location: CLLocation)
    {
        currenLocation = location
        Location.sharedInstance.latitude = currenLocation?.coordinate.latitude
        Location.sharedInstance.longitude = currenLocation?.coordinate.longitude
        CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics"
        FORECAST_URL  = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics"
        
    }
    
    func handleDownloadWeather() {
        if allowedUpdate
        {
            currentWeather = CurrentWeather()
            currentWeather.downloadCurrentWeather {
                self.downloadImage()
                self.updateDisplay()
            }
        }
    }
    
    func willEnterForeground() {
        if allowedUpdate
        {
            startStopLocationMangager(state: "start")
            print("Enter ForeGround")
        }
    }
    
    func willEnterBackground() {
        startStopLocationMangager(state: "stop")
        print("Enter Background")
    }
    
    
    func downloadImage() {
        
        let icon = self.currentWeather.icon
        let myUrl = URL(string: "http://openweathermap.org/img/w/\(icon).png")
        let task = URLSession.shared.dataTask(with: myUrl!)
        {
            (data, response, error) in
            let responseString = "\(response)"
            if responseString.range(of: "status code: 404") == nil
            {
                var documentsDirectory: String?
                var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                if paths.count > 0
                {
                    documentsDirectory = paths[0]
                    let savePath = documentsDirectory! + "/\(icon).png"
                    FileManager.default.createFile(atPath: savePath, contents: data, attributes: nil)
                    DispatchQueue.main.async
                        {
                            self.weatherSymbol.image = UIImage(named: savePath)
                    }
                }
            }
        }
        task.resume()
    }
    
    func updateDisplay()
    {
        currentCityName.text = currentWeather.cityName
        timeLastUpdated.text = currentWeather.time
        dateToday.text = currentWeather.date
        currentTemp.text = "\(currentWeather.temperature)°C"
        minTemp.text = "\(currentWeather.minTemperature)"
        maxTemp.text = "\(currentWeather.maxTemperature)"
        windDescription.text = "\(currentWeather.direction) • \(currentWeather.speed)"
        windDescription.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        if currentWeather.speed > 8.0
        {
            windDescription.backgroundColor = UIColor.orange
        } else if currentWeather.speed > 17.2
        {
            windDescription.backgroundColor = UIColor.red
        }
        weatherDesription.text = "\(currentWeather.weatherDescription)"
        print("\(currentWeather.cityName) \(currentWeather.date) \(currentWeather.temperature) \(currentWeather.direction)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ViewMapVC"
        {
            if let ViewMap = segue.destination as? ViewMapVC
            {
                ViewMap.location = currenLocation
            }
        }
        startStopLocationMangager(state: "stop")
    }
}

