//
//  bird.swift
//  adamapp
//
//  Created by Jacob Rockwell on 1/10/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//
//
import Foundation
import MapKit

struct theTainer {
    let birds: [birdInfo]
}

class birdInfo: NSObject, MKAnnotation {
    var title: String? = NSLocalizedString("BIRD_TITLE", comment: "Bird Scooter")
    var subtitle: String? = NSLocalizedString("BIRD_SUBTITLE", comment: "Open in app ->")
    let battery_level: Int
    let coordinate: CLLocationCoordinate2D
    let markerTintColor = UIColor.black
    
    init(battery_level: Int, lat: Double, long: Double) {
        self.battery_level = battery_level
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}

var birdGang = [birdInfo]()

func genToken() throws {
    guard let url = URL(string: "https://api.bird.co/user/login") else {
        print("Problem in loadBIRD")
        return
    }
    
    
    var urlRequest = URLRequest(url: url)
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpMethod = "POST"
    urlRequest.addValue("45c9c6cf-ee86-435f-a814-493e969d9ee9", forHTTPHeaderField: "Device-id")
    urlRequest.addValue("ios", forHTTPHeaderField: "Platform")
    
    
    urlRequest.httpBody = "{\"email\": \"natik87@wildwood.org\"}".data(using: .utf8)
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    DispatchQueue.main.async {
        let task = session.dataTask(with: urlRequest) {
            (data,response,error) in
            guard error == nil else {
                print("error in calling POST!")
                return
            }
            
            guard let responseData = data else {
                print("no response data")
                return
            }
            print(responseData)
            let responseString = String(data: responseData, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions()) as? NSDictionary
            }
            catch _ {
                print("error")
            }
        }
        task.resume()
    }
}
//GUID: String, token: String
func getBirds(mapView: MKMapView) {
//    var urlComponents = URLComponents()
//    urlComponents.scheme = "https"
//    urlComponents.host = "api.bird.co"
//    urlComponents.path = "/bird/nearby"
//    let lat = URLQueryItem(name: "latitude", value: "34.019561")
//    let lon = URLQueryItem(name: "longitude", value: "-118.450766")
//    let rad = URLQueryItem(name: "radius", value: "1000")
//    urlComponents.queryItems = [lat, lon, rad]
//    guard let url = urlComponents.url else { fatalError("couldn't create URL")}
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    request.setValue("6bef12ce-a88a-4112-bd00-8a750f4d9ab7", forHTTPHeaderField: "Device-id")
//    request.addValue("Bird eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBVVRIIiwidXNlcl9pZCI6ImMxY2MzZWZlLTU3YzktNDQ3My1hNmYyLWE0NzY4MjM2ZjEwMCIsImRldmljZV9pZCI6IjZiZWYxMmNlLWE4OGEtNDExMi1iZDAwLThhNzUwZjRkOWFiNyIsImV4cCI6MTU3ODg1NTY5Nn0.QWuKkRDuG0-5mS1Ox7-JXa1lHKqFNYap_ppWFJYQ6vM", forHTTPHeaderField: "Authorization")
//    request.addValue("{\"latitude\":34.019561,\"longitude\":-118.450766,\"altitude\":500,\"accuracy\":100,\"speed\":-1,\"heading\":-1}", forHTTPHeaderField: "Location")
//    request.addValue("3.0.5", forHTTPHeaderField: "App-version")
//    //headers!
//
//    let config = URLSessionConfiguration.default
//    let session = URLSession(configuration: config)
    let url = URL(string: "https://mds.bird.co/gbfs/santamonica/free_bikes")

        do {
            let responseData = try String(contentsOf: url!).data(using: .utf8)
            //print(responseData)
            let responseString = String(data: responseData!, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
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
                birdGang.append(birdInfo(battery_level: jsonBat, lat: jsonLat!, long: jsonLon!))
            }
            mapView.addAnnotations(birdGang)
        }
        catch _ {
            print("error")
        }
        
}


