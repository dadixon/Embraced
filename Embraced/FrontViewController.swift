//
//  FrontViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/29/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class FrontViewController: UIViewController {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    let participant = UserDefaults.standard
    
    var alertController : UIAlertController?
    
    var orientation = "portrait"
    
    var step = 1
    var totalSteps = 19
    var progress : Float {
        get {
            return Float(step) / Float(totalSteps)
        }
    }
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        loadingView.center = mainView.center
        loadingView.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.progress = progress
        progressLabel.text = "Progress (\(step)/\(totalSteps))"
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Embraced_bg.png")!)
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.7
        mainView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        mainView.layer.shadowRadius = 10
//        mainView.layer.shadowPath = UIBezierPath(rect: mainView.bounds).CGPath
        mainView.layer.shouldRasterize = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func rotated() {
//        if orientation == "landscape" {
//            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
//                alertController?.dismiss(animated: true, completion: nil)
//                alertController = nil
//            }
//        
//            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
//                if alertController == nil {
//                    alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to landscaping orientation", preferredStyle: UIAlertControllerStyle.alert)
//                    self.present(alertController!, animated: true, completion: nil)
//                }
//            }
//        } else if orientation == "portrait" {
//            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
//                if alertController == nil {
//                    alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to portrait orientation", preferredStyle: UIAlertControllerStyle.alert)
//                    self.present(alertController!, animated: true, completion: nil)
//                }
//            }
//            
//            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
//                alertController?.dismiss(animated: true, completion: nil)
//                alertController = nil
//            }
//        }
    }
    
}
