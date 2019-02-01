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
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Tap to dismiss"
        label.textColor = .black
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(labelDidTap))
        )
        
        view.addSubview(label)
        self.view = view
    }
    
    @objc
    private func labelDidTap() {
        dismiss(animated: true, completion: nil)
    }
}

class InteractiveModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveDismiss = true
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}
