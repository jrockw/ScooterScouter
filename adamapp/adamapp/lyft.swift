//
//  lyft.swift
//  adamapp
//
//  Created by Jacob Rockwell on 2/4/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

import Foundation
import MapKit

class lyftScooter: Scooter {
    let battery_level: Int
    let lat: Double
    let long: Double
    var title: String? = NSLocalizedString("Lyft", comment: "Lyft Scooter")
    init(battery_level: Int, lat: Double, long: Double) {
        self.battery_level = battery_level
        self.lat = lat
        self.long = long
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        super.init(scooter: Scooter.ScooterType.lyft, coordinate: coordinate, bat: Double(battery_level))
    }
}

var lyftGang = [lyftScooter]()

func getLyft(mapView: MKMapView) {
    // TODO: adapt back to request, I want battery charge for all scooters
    let url = URL(string: "https://s3.amazonaws.com/lyft-lastmile-production-iad/lbs/lax/free_bike_status.json")
    
    do {
        let responseData = try String(contentsOf: url!).data(using: .utf8)
        //print(responseData)
        let responseString = String(data: responseData!, encoding: .utf8)
        print("Lyft session begin")
        let jsonResponse = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions()) as? NSDictionary
        //var j = birdInfo(battery_level: jsonResponse["birds"][0]["battery_level"], lat: jsonResponse[0][0][4][1], long: jsonResponse[0][0][4][0])
        var jsonData = jsonResponse!["data"] as! NSDictionary?
        var jsonArry = jsonData!["bikes"] as! [NSDictionary?]
        var jsonDict: NSDictionary?
        
        var jsonLat: Double?
        var jsonLon: Double?
        var jsonBat = 55
        
        for scooter in jsonArry {
            jsonLat = scooter!["lat"] as! Double?
            jsonLon = scooter!["lon"] as! Double?
            lyftGang.append(lyftScooter(battery_level: jsonBat, lat: jsonLat!, long: jsonLon!))
        }
        mapView.addAnnotations(lyftGang)
    }
    catch _ {
        print("ERROR: Lyft JSON Parsing")
    }
    
}

