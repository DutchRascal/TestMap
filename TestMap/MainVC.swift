//
//  ViewController.swift
//  TestMap
//
//  Created by Andre Boevink on 18/02/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class MainVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var forecastButton: UIButton!
    @IBOutlet weak var cityDetailButton: UIButton!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var haveFix = false
    var timeoutTimer: Timer?
    var updateTimer: Timer?
    var currentWeather: CurrentWeather!
    var allowedUpdate = true
    var forecast: Forecast!
    var forecasts = [Forecast]()
    var backFromSegue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
        cityDetailButton.isEnabled = false
        forecastButton.isEnabled = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationAuthStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if backFromSegue
        {
            //            updateAllowedDownload()
        }
    }
    
    func updateAllowedDownload ()
    {
        allowedUpdate = true
        updateTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector (updateAllowedDownload), userInfo: nil, repeats: false)
        startStopLocationMangager(state: "start")
        getLocation(location: currentLocation!)
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
//            print("*** \(String(describing: currentWeather?.time)) Start updating ***")
        } else if state == "stop" {
            if let timer = timeoutTimer {
                timer.invalidate()
            }
            locationManager.stopUpdatingLocation()
//            print("*** \(String(describing: currentWeather?.time)) Stop updating ***")
        }
    }
    
    func timeOutDetected() {
        startStopLocationMangager(state: "stop")
        print("No fix ....")
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            if let currentLocation = locationManager.location
            {
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
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
        if location.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if location.horizontalAccuracy < 0 {
            return
        }
        
        if location.horizontalAccuracy <= locationManager.desiredAccuracy {
            centerMapOnLocation(location: location)
            Utils.updateCoordinates(location: location)
            haveFix = true
            mapButton.isEnabled = true
            print("*** We have a fix! ***")
        }
        centerMapOnLocation(location: location)
        currentLocation = location
        
    }
    
    func handleDownloadWeather() {
        
        var documentsDirectory: String?
        var file: String?
        
        if allowedUpdate
        {
            var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            currentWeather = CurrentWeather()
            currentWeather.downloadCurrentWeather {
                
                let icon = "\(self.currentWeather.icon).png"
                let url = URL(string: "http://openweathermap.org/img/w/\(icon)")
                
                if self.currentWeather.icon != ""
                {
                    if paths.count > 0
                    {
                        self.cityDetailButton.isEnabled = true
                        self.forecastButton.isEnabled = true
                        documentsDirectory = paths[0]
                        file = documentsDirectory! + "/\(icon)"
//                        print(file!)
                        if !Utils.checkFileExists(file: icon)
                        {
                            let data = NSData(contentsOf: url!)
                            FileManager.default.createFile(atPath: file!, contents: data! as Data, attributes: nil)
                        }
                    }
                    self.weatherSymbol.image = UIImage(named: file!)
                    self.forecasts.removeAll()
                    self.downloadForecast {
//                        print("Download Forecast")
                    }
                }
                self.updateDisplay()
                
            }
        }
    }
    
    func willEnterForeground() {
        if allowedUpdate
        {
            startStopLocationMangager(state: "start")
//            print("Enter ForeGround")
        }
    }
    
    func willEnterBackground() {
        startStopLocationMangager(state: "stop")
//        print("Enter Background")
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
        if segue.identifier == "ViewMap"
        {
            let viewController = segue.destination as! ViewMapVC
            viewController.location = currentLocation
        }
        else if segue.identifier == "ShowForecast"
            
        {
            let navigation = segue.destination as! UINavigationController
            let viewController = navigation.topViewController as! WeatherTableVC
            viewController.location = currentLocation
            backFromSegue = true
        }
        else if segue.identifier == "CityDetail"
        {
            let viewController = segue.destination as! cityVC
            viewController.cityName = currentWeather.cityName
            viewController.sunrise = currentWeather.sunrise
            viewController.sunset = currentWeather.sunset
            viewController.pressure = currentWeather.pressure
        }
    }
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as? ForecastCell
        {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        }
        else
        {
            return ForecastCell()
        }
    }
    
    func downloadForecast(completion: @escaping () -> () ) {
        Utils.updateCoordinates(location: currentLocation!)
        Alamofire.request(
            FORECAST_URL
            )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    self.currentCityName.text = "Service unavailable ...."
                    completion( () )
                    return
                }
                let result = response.result
                if let forecastDictionary = result.value as? Dictionary<String, Any>
                {
                    if let list = forecastDictionary["list"] as? [Dictionary<String,Any>]
                    {
                        for object in list
                        {
                            let forecast = Forecast(forecastDictionary: object)
                            self.forecasts.append(forecast)
                        }
                        self.forecasts.remove(at: 0)
                        self.tableView.reloadData()
                    }
                }
                completion( () )
        }
    }
    
}

