//
//  ViewController.swift
//  adamapp
//
//  Created by Jacob Rockwell on 1/6/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension UIColor {
    static let translucentButtonColor = UIColor(named: "translucentButton")
}

var userLoc = CLLocation()
var str: String?
class ViewController: UIViewController {

    
    @IBOutlet weak var h1: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func birdbutton(_ sender: UIButton) {
        showHideBird()
    }
    
    
    let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    private var scaleView: MKScaleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // location permissions
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            //locationManager.startUpdatingLocation()
            //userLoc = locationManager.location!
        }
        mapView.delegate = self
        locationManager.requestLocation()
        setupUserTrackingButtonAndScaleView()
        
    }
    
    
    
    let regionRadius: CLLocationDistance = 2000
    
//    // TODO: adjust for current location
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
//                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
    

    // we need to register the annotations onto the map
    private func registerMapAnnotationViews() {
//        if (birdGang.count != 0) {
//            mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(birdInfo.self))
//        }
        if (jumpList.count != 0 ) {
            mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(jumpBike.self))
        }
        if (limeGang.count != 0) {
            mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(limeySlimy.self))
        }
        if (lyftGang.count != 0) {
            mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(lyftScooter.self))
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLoc = location
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            // Get Bird's token, continue with the rest....
            genToken(map: mapView, closure: close)
            loadJump(mapView: mapView)
            getLimey(mapView: mapView)
            getLyft(mapView: mapView)
            
            registerMapAnnotationViews()
        }
    } // locationManager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location retrevial error")
    }// location error
    
    // Fix this
    func showHideBird() {
        for annotation in mapView.annotations {
            if (annotation.title == "Bird") {
                mapView.view(for: annotation)?.isHidden = true
            }
        }
    }
    // setup userTrackingButton for mapview
    private func setupUserTrackingButtonAndScaleView() {
        mapView.showsUserLocation = true
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.layer.backgroundColor = UIColor.white.cgColor
        userTrackingButton.layer.borderColor = UIColor.white.cgColor
        userTrackingButton.layer.borderWidth = 1
        userTrackingButton.layer.cornerRadius = 5
        userTrackingButton.isHidden = false // Unhides when location authorization is given.
        view.addSubview(userTrackingButton)
        
        // By default, `MKScaleView` uses adaptive visibility, so it only displays when zooming the map.
        // This is behavior is confirgurable with the `scaleVisibility` property.
//        scaleView = MKScaleView(mapView: mapView)
//        scaleView.legendAlignment = .trailing
//        view.addSubview(scaleView)
//
        let stackView = UIStackView(arrangedSubviews: [userTrackingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)

        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                                     stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
}
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let anotherViewController = self.storyboard?.instantiateViewController(withIdentifier: "cardVC") as! CardViewController
        self.navigationController?.pushViewController(anotherViewController, animated: true)
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Scooter else { return nil }
        
        switch annotation.type {
        case .jump:
            return jumpAnnotationView(annotation: annotation, reuseIdentifier: jumpAnnotationView.ReuseID)
        case .bird:
            return birdAnnotationView(annotation: annotation, reuseIdentifier: birdAnnotationView.ReuseID)
        case .lyft:
            return lyftAnnotationView(annotation: annotation, reuseIdentifier: lyftAnnotationView.ReuseID)
        case .lime:
            return limeAnnotationView(annotation: annotation, reuseIdentifier: limeAnnotationView.ReuseID)
        }
    }
    
    // registers tap on scooter
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        // differentiate or pass info as to which type of scooter was clicked
        if let annotationTitle = view.annotation?.title
        {
            
            print("User tapped on annotation with title: \(annotationTitle!)")
           
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardVC") as! CardViewController
            //self.addChild(popOverVC)
            if (annotationTitle == "Bird") {
                popOverVC.setToScooter(title: "Bird")
                // create function within popOverVC to
                // adapt to company
            }
            else if (annotationTitle == "Jump") {
                popOverVC.setToScooter(title: "JUMP")
            }
            else if (annotationTitle == "Lime") {
                popOverVC.setToScooter(title: "LIME")
            }
            else {
                popOverVC.setToScooter(title: "LYFT")
            }
            popOverVC.modalPresentationStyle = .overFullScreen
            self.present(popOverVC, animated: true, completion: nil)
            //popOverVC.view.frame = self.view.frame
            //self.view.addSubview(popOverVC.view)
            //popOverVC.didMove(toParent: self)
            
            //popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            //self.present(popOverVC, animated: true)
        }
    }
}



