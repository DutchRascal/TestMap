//
//  weatherTableVC.swift
//  TestMap
//
//  Created by Andre Boevink on 25/02/2017.
//  Copyright © 2017 Andre Boevink. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class WeatherTableVC: UITableViewController  {
    
    var location: CLLocation!
    var forecast: ForeCast3Hrs!
    var forecasts = [ForeCast3Hrs]()
    var weatherDictionaryFile: Dictionary<String,Any> = [:]
    var myTimer: Timer?
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        print("Download allowed : \(Constants.allowForecastToBeLoaded)")
        if Constants.allowForecastToBeLoaded
        {
            downloadForecast
                {
                    Constants.allowForecastToBeLoaded = false
                    self.myTimer = Timer.scheduledTimer(timeInterval: self.calculateTimeout(), target: self, selector: #selector (self.enableDownload), userInfo: nil, repeats: false)
//                    self.myTimer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector (self.enableDownload), userInfo: nil, repeats: false)
                    
            }
        }
        else
        {
            let weatherDictionary = FileSaveHelper(fileName: "3HrForecast", fileExtension: .json, subDirectory: "3HrForecast", directory: .documentDirectory)
            do
            {
                
                weatherDictionaryFile = try weatherDictionary.getJSONData()
                handleData(weatherDictionary: weatherDictionaryFile)
                tableView.reloadData()
                print("reload data \(forecasts.count)")
            }
            catch
            {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func saveTheData(weatherDictionary: Dictionary<String,Any>)
    {
        let forecastsFile = FileSaveHelper(fileName: "3HrForecast", fileExtension: .json, subDirectory: "3HrForecast", directory: .documentDirectory)
        do
        {
            try forecastsFile.saveFileWith(dataForJson: weatherDictionary as AnyObject)
            self.handleData(weatherDictionary: weatherDictionary)
        }
        catch
        {
            print(error)
        }
    }
    
    
    func downloadForecast(completion: @escaping () -> () ) {
        Utils.updateCoordinates(location: location)
        Alamofire.request(
            FORECAST3HR_URL
            //            "http://api.openweathermap.org/data/2.5/forecast?q=Hengelo&mode=json&appid=ae4bfc24515b92974e0bd30b3ae046ec&units=metrics&cnt=12"
            )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching data: \(String(describing: response.result.error))")
                    completion( () )
                    return
                }
                print("Alamofire")
                
                if let weatherDictionary = response.result.value as? Dictionary<String, Any>
                {
                    self.saveTheData(weatherDictionary: weatherDictionary)
                }
                completion( () )
        }
    }
    
    func handleData(weatherDictionary: Dictionary<String,Any>)
    {
        if let weatherList = weatherDictionary["list"] as? [Dictionary<String, Any>]
        {
            for object in weatherList
            {
                let forecast = ForeCast3Hrs(forecastDictionary: object)
                self.forecasts.append(forecast)
            }
        }
        
    }
    
    func enableDownload()
    {
        print("enableDownload \(Constants.allowForecastToBeLoaded) \(Date())")
        Constants.allowForecastToBeLoaded = true
                self.myTimer = Timer.scheduledTimer(timeInterval: self.calculateTimeout(), target: self, selector: #selector (self.enableDownload), userInfo: nil, repeats: false)
//        self.myTimer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector (self.enableDownload), userInfo: nil, repeats: false)
        
        if Constants.allowForecastToBeLoaded
        {
            downloadForecast
                {
                    Constants.allowForecastToBeLoaded = false                    
            }
        }

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(forecasts.count)
        return forecasts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell
        {
            let forecast = forecasts[indexPath.row]
            cell.configureCellInformation(forecast: forecast)
            return cell
        }
        return WeatherCell()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)
        return nil
    }
    
    func calculateTimeout() -> Double
    {
        let hour = Calendar.current.component(.hour, from: Date())
        var timeoutNextReloadAllowed = 0.0
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        
        let dateFormatter = DateFormatter()
        let dateStringNow = "\(year)-\(month)-\(day)"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let beginTime = dateFormatter.date(from: dateFormatter.string(from: NSDate() as Date))?.timeIntervalSince1970
        
        switch hour{
        case 1..<4:
            print("Between 1 and 3")
            let endTime = (dateFormatter.date(from: "\(dateStringNow) 4:00:00")?.timeIntervalSince1970)
            timeoutNextReloadAllowed = endTime! - beginTime!
        case 4..<7:
            print("Between 4 and 7")
            let endTime = (dateFormatter.date(from: "\(dateStringNow) 7:00:00")?.timeIntervalSince1970)
            timeoutNextReloadAllowed = endTime! - beginTime!
        case 7..<10:
            print("Between 7 and 10")
            let endTime = (dateFormatter.date(from: "\(dateStringNow) 10:00:00")?.timeIntervalSince1970)
            timeoutNextReloadAllowed = endTime! - beginTime!
        case 10..<13:
            print("Between 10 and 13")
            let endTime = (dateFormatter.date(from: "\(dateStringNow) 13:00:00")?.timeIntervalSince1970)
            timeoutNextReloadAllowed = endTime! - beginTime!
        case 13..<16:
            print("Between 13 and 16")
            let endTime = (dateFormatter.date(from: "\(dateStringNow) 16:00:00")?.timeIntervalSince1970)
            timeoutNextReloadAllowed = endTime! - beginTime!
        case 16..<19:
            print("Between 16 and 19")
            let endTime = (dateFormatter.date(from: "\(dateStringNow) 19:00:00")?.timeIntervalSince1970)
            timeoutNextReloadAllowed = endTime! - beginTime!
        case 19..<22:
            print("Between 19 and 22")
            let endTime = (dateFormatter.date(from: "\(dateStringNow) 22:00:00")?.timeIntervalSince1970)
            timeoutNextReloadAllowed = endTime! - beginTime!
        default:
            print(">22")
            let endTime = (dateFormatter.date(from: "\(dateStringNow) 23:59:59")?.timeIntervalSince1970)
            timeoutNextReloadAllowed = endTime! - beginTime! + 3601
        }
        print(timeoutNextReloadAllowed)
        return timeoutNextReloadAllowed + 15
    }
}
