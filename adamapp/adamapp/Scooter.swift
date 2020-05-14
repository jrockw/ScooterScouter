//
//  Scooter.swift
//  adamapp
//
//  Created by Jacob Rockwell on 8/15/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

import Foundation
import MapKit

class Scooter: NSObject, MKAnnotation {
    enum ScooterType {
        case jump
        case bird
        case lyft
        case lime
    }
    var type: ScooterType
    
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    private var battery_level: Double?
    var coordinate: CLLocationCoordinate2D 
   
    init(scooter:ScooterType, coordinate:CLLocationCoordinate2D, bat: Double?) {
        self.type = scooter
        self.coordinate = coordinate
        self.battery_level = bat
    }
}
