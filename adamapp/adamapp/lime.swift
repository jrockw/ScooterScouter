//
//  lime.swift
//  adamapp
//
//  Created by Jacob Rockwell on 1/12/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

import Foundation
import MapKit

class limeySlimy: Scooter {
    let battery_level: Int
    let lat: Double
    let long: Double
    var title: String? = NSLocalizedString("Lime", comment: "Lime Scooter")
    init(battery_level: Int, lat: Double, long: Double) {
        self.battery_level = battery_level
        self.lat = lat
        self.long = long
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        super.init(scooter: Scooter.ScooterType.lime, coordinate: coordinate, bat: Double(battery_level))
    }
}


var limeGang = [limeySlimy]()

func getLimey(mapView: MKMapView) {
    let url = URL(string: "https://data.lime.bike/api/partners/v1/gbfs/los_angeles/free_bike_status")
    
    do {
        let responseData = try String(contentsOf: url!).data(using: .utf8)
        print("Lime session begin")
        let responseString = String(data: responseData!, encoding: .utf8)
        //print("responseString = \(String(describing: responseString))")
        let jsonResponse = try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions()) as? NSDictionary
        //var j = birdInfo(battery_level: jsonResponse["birds"][0]["battery_level"], lat: jsonResponse[0][0][4][1], long: jsonResponse[0][0][4][0])
        var jsonData = jsonResponse!["data"] as! NSDictionary?
        var jsonArry = jsonData!["bikes"] as! [NSDictionary?]
        var jsonDict: NSDictionary?
        
        var jsonLat: Double?
        var jsonLon: Double?
        var latLonStr: String
        var jsonBat = 55
        
        for scooter in jsonArry {
            latLonStr = scooter!["lat"] as! String
            jsonLat = Double(latLonStr)
            latLonStr = scooter!["lon"] as! String
            jsonLon = Double(latLonStr)
            limeGang.append(limeySlimy(battery_level: jsonBat, lat: jsonLat!, long: jsonLon!))
        }
        mapView.addAnnotations(limeGang)
    }
    catch _ {
        print("ERROR: LIME JSON Parsing")
    }
}
//func getLimey(mapView: MKMapView) {
//    var urlComponents = URLComponents()
//    urlComponents.scheme = "https"
//    urlComponents.host = "web-production.lime.bike"
//    urlComponents.path = "/api/rider/v1/views/map"
//    let ne_lat = URLQueryItem(name: "ne_lat", value: "34.019561")
//    let ne_lon = URLQueryItem(name: "ne_lng", value: "-118.450766")
//    let sw_lat = URLQueryItem(name: "sw_lat", value: "34.019561")
//    let sw_lon = URLQueryItem(name: "sw_lng", value: "-118.450766")
//    let user_lat = URLQueryItem(name: "user_latitude", value: "34.019561")
//    let user_lon = URLQueryItem(name: "user_longitude", value: "-118.450766")
//    let zom = URLQueryItem(name: "zoom", value: "12")
//    urlComponents.queryItems = [ne_lat, ne_lon, sw_lat, sw_lon, user_lat, user_lon, zom]
//    guard let url = urlComponents.url else { fatalError("couldn't create URL")}
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//
//     request.setValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX3Rva2VuIjoiNEtBSUFOSFBPRElITiIsImxvZ2luX2NvdW50IjozfQ.kGM2HHHoIA1PrQRYwYYnIrGK3VVCjeyRlpD9objJM3w", forHTTPHeaderField: "authorization")
//
//    let config = URLSessionConfiguration.default
//    let session = URLSession(configuration: config)
//    let task = session.dataTask(with: request) {
//        (data, response, error) in
//        guard error == nil else {
//            print("error in calling POST!")
//            return
//        }
//
//        guard let responseData = data else {
//            print("no response data")
//            return
//        }
//        //print(responseData)
//        let responseString = String(data: responseData, encoding: .utf8)
//        //print("responseString = \(String(describing: responseString))")
//        do {
//            let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions()) as? NSDictionary
//            //var j = birdInfo(battery_level: jsonResponse["birds"][0]["battery_level"], lat: jsonResponse[0][0][4][1], long: jsonResponse[0][0][4][0])
//
//
//            var jsonData = jsonResponse!["data"] as! NSDictionary?
//            var jsonAttributes = jsonData!["attributes"] as! NSDictionary?
//            var jsonBikes = jsonAttributes!["bikes"] as! [NSDictionary?]
//            var jsonBA: NSDictionary?
//            var jsonLat: Double?
//            var jsonLon: Double?
//            var jsonBat: String?
//
//
//            for scooter in jsonBikes {
//                jsonBA = scooter!["attributes"] as! NSDictionary?
//                jsonBat = jsonBA!["battery_level"] as! String?
//                jsonLat = jsonBA!["latitude"] as! Double?
//                jsonLon = jsonBA!["longitude"] as! Double?
//                limeGang.append(limeySlimy(battery_level: jsonBat!, lat: jsonLat!, long: jsonLon!))
//            }
//            mapView.addAnnotations(limeGang)
//        }
//        catch _ {
//            print("error")
//        }
//    }
//    task.resume()
//}

