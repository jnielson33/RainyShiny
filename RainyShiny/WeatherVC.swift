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
    
    var currentWeather = CurrentWeather()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //these must be declared in order for the tableView information to appear on the screen.
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
        currentWeather.downloadWeatherDetails {
            
            //Setup UI to load downloaded data
            self.updateMainUI()
            
        }
    }

    //These three functions are required in order for a tableView to work. 
    
    //This first function specifies how many sections the tableView will have.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    //This second function specifies how many rows will be in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }

    //The third function lets the cell know what information to display. The weatherCell identifer is what I called the cell in the Main.storyboard table view cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        
        return cell
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }

}

