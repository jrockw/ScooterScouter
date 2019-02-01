//
//  ride.swift
//  adamapp
//
//  Created by Jacob Rockwell on 1/6/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

import Foundation
import MapKit

struct tainerz: Decodable {
    let data: bikz
}
struct bikz: Decodable {
    let bikes: [jumpBike]
}

class jumpBike: NSObject, MKAnnotation, Decodable {
    let bike_id: String
    let name: String
    let jump_ebike_battery_level: String
    let lon: Double
    let lat: Double
    let coordinate: CLLocationCoordinate2D
    
    init(bike_id: String, name: String, jump_ebike_battery_level: String, lon: Double, lat: Double) {
        self.bike_id = bike_id
        self.name = name
        self.jump_ebike_battery_level = jump_ebike_battery_level
        self.lon = lon
        self.lat = lat
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        super.init()
    }
    
    enum MyKeys: String, CodingKey {
        case bike_id = "bike_id"
        case name = "name"
        case jump_ebike_battery_level = "jump_ebike_battery_level"
        case lon = "lon"
        case lat = "lat"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyKeys.self)
        let bike_id: String = try container.decode(String.self, forKey: .bike_id)
        let name: String = try container.decode(String.self, forKey: .name)
        let jump_ebike_battery_level: String = try container.decode(String.self, forKey: .jump_ebike_battery_level)
        let lon: Double = try container.decode(Double.self, forKey: .lon)
        let lat: Double = try container.decode(Double.self, forKey: .lat)
        self.init(bike_id: bike_id, name: name, jump_ebike_battery_level: jump_ebike_battery_level, lon: lon, lat: lat)
        
    }
    var subtitle: String? {
        return jump_ebike_battery_level
    }
}

