//
//  CurrentWeather.swift
//  RainyShiny
//
//  Created by Jared Nielson on 10/19/16.
//  Copyright © 2016 Jared Nielson. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    
    //These each check to see if there is a value stored in the variables. If there is nothing then it will assign a blank string or 0.0 for the value to keep the program from crashing.
    
    var cityName: String{
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        //Creates the date formatter which will display the date as Today, October 19, 2016
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }

    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }


    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Alamofire download
        
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result

            
            
            //Creates a Dictionary called dict that stores the results of the JSON in the dictionary. The String item in the dictionary is the key and the AnyObject is the value.
            if let dict = result.value as? Dictionary<String, AnyObject> {
               
                //This is pulling the information for the key called "name" in the dictionary
                if let name = dict["name"] as? String {
                   
                    //This stores the value assoicated with "name" in _cityName and prints it
                    self._cityName = name.capitalized
                    print(self._cityName)
                    
                }
                
                //This is pulling the information for the key called "weather" in the dictionary
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                   
                    //Since the "weather" key has an array for its value, we are requesting the first item in the array.
                    if let main = weather[0]["main"] as? String {
                        
                        //Stores the value in _weatherType and prints it
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                    
                }
                
                //This is pulling the information for the key called "main" in the dictionary
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    
                    //This stores the value in a Double variable called currentTemperature
                    if let currentTemperature = main["temp"] as? Double {
                        
                        //The JSON is storing the temperature as a kelvin number so here we are converting it to farenheit
                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                        
                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                        
                        //Stores the farenheit value to _currentTemp and prints it
                        self._currentTemp = kelvinToFarenheit
                        print(self._currentTemp)
                        
                    }
                }
                
            }
        
        completed()
            
        }
        
    }
    
}
