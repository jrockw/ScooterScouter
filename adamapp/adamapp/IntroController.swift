//
//  IntroController.swift
//  adamapp
//
//  Created by Jacob Rockwell on 1/23/19.
//  Copyright © 2019 Jacob Rockwell. All rights reserved.
//

import Foundation
import UIKit

class IntroController: UIViewController {

    @IBOutlet weak var TapMessage: UILabel!
    
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var introImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       introImg.image = UIImage(imageLiteralResourceName:   "introView")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
