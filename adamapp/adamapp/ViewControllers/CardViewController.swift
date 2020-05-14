//
//  CardViewController.swift
//  adamapp
//
//  Created by Jacob Rockwell on 1/31/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

import Foundation
import UIKit

class CardViewController: UIViewController{
    var type: String?
    var url: String?
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var popUp: UIView!
    @IBOutlet weak var OpenInApp: UIButton!
    @IBOutlet var sctLogo: UIImageView!
    func setToScooter(title: String) {
        if (title == "Bird") {
            type = "BIRD"
        }
        else if (title == "JUMP") {
            type = "JUMP"
        }
        else if (title == "LIME"){
            type = "LIME"
        }
        else {
            type = "LYFT"
        }
    }
    override func viewDidLoad() {
        popUp.backgroundColor = UIColor.white
        if (type == "BIRD") {
            sctLogo.image = #imageLiteral(resourceName: "birdLogo.png")
            url = "bird://"
        }
        else if (type == "LIME") {
            sctLogo.image = #imageLiteral(resourceName: "limeLogo.png")
            url = "lime://"
        }
        else if (type == "JUMP") {
            sctLogo.image = #imageLiteral(resourceName: "jumpLogo.png")
            url = "uber://"
        }
        else {
            //lyft image
            sctLogo.image = #imageLiteral(resourceName: "lyftLogo.png")
            url = "lyft://"
        }
        //sctLogo.image = #imageLiteral(resourceName: "birdLogo.png")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        //sctLogo.image = #imageLiteral(resourceName: "smallBird")
        
        //adjust this to be able to tap out of the view
        self.view = view
    }
    @IBAction func dismissMe(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openNextApp(_ sender: Any) {
        launchApp(decodedURL: url!)
    }
    
    
    func launchApp(decodedURL: String) {
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
}

