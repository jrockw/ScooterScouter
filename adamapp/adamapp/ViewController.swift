//
//  ViewController.swift
//  adamapp
//
//  Created by Jacob Rockwell on 1/6/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    
    @IBOutlet weak var h1: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let iloc = CLLocation(latitude: 34.019561, longitude: -118.450766)
        centerMapOnLocation(location: iloc)
        do {
            //try loadJUMP()
        }
        catch {
            print("problem")
        }
        getBirds(mapView: mapView)
        //getLimey(mapView: mapView)
        registerMapAnnotationViews()
    }
    
    let regionRadius: CLLocationDistance = 2000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func loadJUMP() throws {
        let url = URL(string: "https://la.jumpbikes.com/opendata/free_bike_status.json")
        let json = try String(contentsOf: url!).data(using: .utf8)!
        let myStruct = try JSONDecoder().decode(tainerz.self, from: json)
//        mapView.addAnnotations(myStruct.data.bikes)
//
    }
    func loadBIRD() throws {
        try genToken()
    }
    
    private func setupBirdAnnotationView(for annotation: birdInfo, on mapView: MKMapView) -> MKAnnotationView {
        let identifier = NSStringFromClass(birdInfo.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.animatesWhenAdded = true
            markerAnnotationView.canShowCallout = true
            let rightButtion = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButtion
            // set link between button and the app
            let leftLogo = #imageLiteral(resourceName: "smallBird.png")
            let imgView = UIImageView(image: leftLogo)
            //markerAnnotationView.image = leftLogo
            markerAnnotationView.leftCalloutAccessoryView = imgView
        }
        return view
    }
    private func registerMapAnnotationViews() {
        if (birdGang.count != 0){
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(birdInfo.self))
        }
        //mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(jumpBike.self))
//        if (limeGang.count != 0) {
//            mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(limeySlimy.self))
//        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        // This illustrates how to detect which annotation type was tapped on for its callout.
        if let annotation = view.annotation, annotation.isKind(of: birdInfo.self) {
            print("Tapped Golden Gate Bridge annotation accessory view")
            
            if let detailNavController = storyboard?.instantiateViewController(withIdentifier: "DetailNavController") {
                detailNavController.modalPresentationStyle = .popover
                let presentationController = detailNavController.popoverPresentationController
                presentationController?.permittedArrowDirections = .any
                
                // Anchor the popover to the button that triggered the popover.
                presentationController?.sourceRect = control.frame
                presentationController?.sourceView = control
                
                present(detailNavController, animated: true, completion: nil)
            }
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // TODO: enable later!
        //        guard !annotation.isKind(of: MKUserLocation.self) else {
        //            // Make a fast exit if the annotation is the `MKUserLocation`, as it's not an annotation view we wish to customize.
        //            return nil
        //        }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? birdInfo {
            annotationView = setupBirdAnnotationView(for: annotation, on: mapView)
        }
        
        return annotationView
    }
}

    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        var annotationView = MKPinAnnotationView()
    //        var identifier = ""
    //        var color = UIColor.red
    //        // birdInfo || jumpBike
    //        if type(of: annotation) == birdInfo.self {
    //            guard let annotation = annotation as? birdInfo else {return nil}
    //            identifier = "Bird"
    //            color = .black
    //        }
    //        else if type(of: annotation) == jumpBike.self {
    //            guard let annotation = annotation as? jumpBike else {return nil}
    //            identifier = "JUMP"
    //            color = .red
    //        }
    //        else {
    //            guard let annotation = annotation as? limeySlimy else {return nil}
    //            identifier = "Lime"
    //            color = .green
    //        }
    //
    //        if let dequedView = mapView.dequeueReusableAnnotationView(
    //            withIdentifier: identifier)
    //            as? MKPinAnnotationView {
    //            annotationView = dequedView
    //        } else{
    //            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //        }
    //        annotationView.pinTintColor = color
    //        return annotationView
    //    }


