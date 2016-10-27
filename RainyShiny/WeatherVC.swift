//
//  WeatherVC.swift
//  RainyShiny
//
//  Created by Jared Nielson on 10/19/16.
//  Copyright © 2016 Jared Nielson. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire


//When using a tableView, you must always have the UITableViewDelegate and UITableViewDataSource extended in the class.
class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //Links all of the labels and images to the code
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    
    var currentWeather = CurrentWeather()
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationAuthStatus()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        //these must be declared in order for the tableView information to appear on the screen.
        tableView.delegate = self
        tableView.dataSource = self
        
       
        currentWeather = CurrentWeather()
        
    }

    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                
                self.downloadForecastData() {
                    
                    //Setup UI to load downloaded data
                    self.updateMainUI()
                    
                }
            }
            print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }

    //These three functions are required in order for a tableView to work. 
    
    //This first function specifies how many sections the tableView will have.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    //This second function specifies how many rows will be in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return forecasts.count
    }

    //The third function lets the cell know what information to display. The weatherCell identifer is what I called the cell in the Main.storyboard table view cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
        
        if currentWeather.weatherType == "Clear" {
            
            backgroundImage.image = UIImage(named: "sunny.jpg")
            
        }
        
        else if currentWeather.weatherType == "Clouds" {
            
            backgroundImage.image = UIImage(named: "cloudy.jpg")
            
        }
        
        else if currentWeather.weatherType == "Rain" {
            
            backgroundImage.image = UIImage(named: "rainy.jpg")
            
        }
        
        else {
            
            backgroundImage.image = UIImage(named: "snowy.jpg")
        }
        
    }

 }


