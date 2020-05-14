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

struct birdStruct {
    var GUID: String
    var version: String
    var auth: String
}
var birdLogin = birdStruct(GUID: "129d7aac-2d4d-4eb7-9a56-5ceb0150bb5e", version: "4.41.0", auth: "")
class birdInfo: Scooter {
    var title: String? = NSLocalizedString("Bird", comment: "Bird Scooter")
    var subtitle: String? = NSLocalizedString("BIRD_SUBTITLE", comment: "Open in app ->")
    let battery_level: Int
    let markerTintColor = UIColor.black

    
    init(battery_level: Int, lat: Double, long: Double) {
        self.battery_level = battery_level
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        super.init(scooter: Scooter.ScooterType.bird, coordinate: coordinate, bat: Double(battery_level))
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

var birdGang = [birdInfo]()

func genToken(map: MKMapView, closure: @escaping (MKMapView) -> ()) {
    guard let url = URL(string: "https://api.birdapp.com/user/login") else {
        print("Problem in loadBIRD")
        return
    }
    let emailNum = Int.random(in: 10000..<999999)
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    //Set headers
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.addValue("Bird/4.41.0 (co.bird.Ride; build:37; iOS 12.3.1) Alamofire/4.41.0", forHTTPHeaderField: "User-Agent")
    urlRequest.addValue(birdLogin.version, forHTTPHeaderField: "App-Version")
    urlRequest.addValue(birdLogin.GUID, forHTTPHeaderField: "Device-Id")
    urlRequest.addValue("ios", forHTTPHeaderField: "Platform")
    //Set json body
    let emailBody = "{\"email\": \"" + String(emailNum) + "@gmail.com\"}"
    urlRequest.httpBody = emailBody.data(using: .utf8)
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
                let token = jsonResponse!["token"] as! String
                print(token)
                birdLogin.auth = "Bird " + token
                closure(map)
                return
            }
            catch _ {
                print("error")
            }
        }
        task.resume()
    }
    return
}

func getBirds(mapView: MKMapView) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.birdapp.com"
    urlComponents.path = "/bird/nearby"
    let latVal = String(userLoc.coordinate.latitude)
    let lonVal = String(userLoc.coordinate.longitude)
    let lat = URLQueryItem(name: "latitude", value: latVal)
    let lon = URLQueryItem(name: "longitude", value: lonVal)
    let rad = URLQueryItem(name: "radius", value: "1000")
    urlComponents.queryItems = [lat, lon, rad]
    guard let url = urlComponents.url else { fatalError("couldn't create URL")}
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(birdLogin.GUID, forHTTPHeaderField: "Device-id")
    request.addValue(birdLogin.auth, forHTTPHeaderField: "Authorization")
    request.addValue("{\"latitude\":"+latVal+",\"longitude\":"+lonVal+",\"altitude\":500,\"accuracy\":100,\"speed\":-1,\"heading\":-1}", forHTTPHeaderField: "Location")
    request.addValue(birdLogin.version, forHTTPHeaderField: "App-version")
    request.addValue("application/json", forHTTPHeaderField: "Content-type")
    //headers!
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let dataTask = URLSession.shared.dataTask(with: request) {
        data,response,error in
        print("Bird session begin")
        do {
            if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                var jsonData = jsonResult["birds"] as! Array<NSDictionary>?
                var jsonLoc: NSDictionary?
                var jsonLat: Double?
                var jsonLon: Double?
                var jsonBat: Int
                
                for scooter in jsonData! {
                    jsonLoc = (scooter["location"] as! NSDictionary)
                    jsonLat = jsonLoc?["latitude"] as! Double?
                    jsonLon = jsonLoc?["longitude"] as! Double?
                    jsonBat = (scooter["battery_level"] as! Int?)!
                    birdGang.append(birdInfo(battery_level: jsonBat, lat: jsonLat!, long: jsonLon!))
                }
                mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(birdInfo.self))
                mapView.addAnnotations(birdGang)
                //Use GCD to invoke the completion handler on the main thread
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    dataTask.resume()
}

var close:(MKMapView) -> () = {map in getBirds(mapView: map)}

