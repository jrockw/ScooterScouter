//
//  scooterAnnotationView.swift
//  adamapp
//
//  Created by Jacob Rockwell on 8/15/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 The annotation views that represent the different types of cycles.
 */
import MapKit


/// - Tag: JumpAnnotationView
class jumpAnnotationView: MKAnnotationView {
    
    static let ReuseID = "jumpAnnotation"
    //let size = CGSize(width: 50, height: 56)
    //        UIGraphicsBeginImageContext(size)
    //        birdPin.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    //        let birdResize = UIGraphicsGetImageFromCurrentImageContext()
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "jump"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        image = #imageLiteral(resourceName: "redscooter")
        frame.size = CGSize(width: 50, height:56)
    }
}

/// - Tag: BicycleAnnotationView
class birdAnnotationView: MKAnnotationView {
    
    static let ReuseID = "birdAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "bird"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: DisplayConfiguration
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        image = #imageLiteral(resourceName: "BirdScooter")
        frame.size = CGSize(width: 50, height:56)
    }
}

class lyftAnnotationView: MKAnnotationView {
    
    static let ReuseID = "lyftAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "lyft"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        image = #imageLiteral(resourceName: "LyftScooter")
        frame.size = CGSize(width: 50, height:56)
    }
}



class limeAnnotationView: MKAnnotationView {
    
    static let ReuseID = "limeAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "lime"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        image = #imageLiteral(resourceName: "LimeScooter")
        frame.size = CGSize(width: 50, height:56)
    }
}
