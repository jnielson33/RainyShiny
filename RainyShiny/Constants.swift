//
//  Constants.swift
//  RainyShiny
//
//  Created by Jared Nielson on 10/19/16.
//  Copyright © 2016 Jared Nielson. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "62e500b51a542543aaa12797c3968b1d"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)-36\(LONGITUDE)123\(APP_ID)\(API_KEY)"

