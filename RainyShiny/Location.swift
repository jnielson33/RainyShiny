//
//  Location.swift
//  RainyShiny
//
//  Created by Jared Nielson on 10/25/16.
//  Copyright © 2016 Jared Nielson. All rights reserved.
//

import CoreLocation

class Location {
    
    static var sharedInstance = Location()
    
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
