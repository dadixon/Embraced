//
//  FrontViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/29/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Stormpath
import AVFoundation

class FrontViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var loadingView = UIActivityIndicatorView()
    
    let participant = UserDefaults.standard
    
    var orientation = "portrait"
    
    var step = 1
    var totalSteps = 20
    var progress : Float {
        get {
            return Float(step) / Float(totalSteps)
        }
    }
    
    var alertController = UIAlertController()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var soundPlayer = AVAudioPlayer()
    
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
        if orientation == "landscape" {
            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)) {
                alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to landscaping orientation", preferredStyle: UIAlertControllerStyle.alert)
                
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    self.alertController.dismiss(animated: true, completion: nil)
                    self.rotated()
                }
                alertController.addAction(dismissAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else if orientation == "portrait" {
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
                alertController = UIAlertController(title: "Rotate", message: "Please rotate iPad to portrait orientation", preferredStyle: UIAlertControllerStyle.alert)
                
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    self.alertController.dismiss(animated: true, completion: nil)
                    self.rotated()
                }
                alertController.addAction(dismissAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func nextViewController(viewController: UIViewController) {
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
//        let reyComplexFigure3ViewController:viewController = viewController()
        navigationArray?.append(viewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
//        self.navigationController?.pushViewController(reyComplexFigure3ViewController, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        return paths[0]
    }
    
    func play(_ filename:String) {
        let file = filename.characters.split(separator: ".").map(String.init)
        
        if let pathResource = Bundle.main.path(forResource: file[0], ofType: "wav") {
            let finishedStepSound = NSURL(fileURLWithPath: pathResource)
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: finishedStepSound as URL)
                if(soundPlayer.prepareToPlay()){
                    print("preparation success")
                    soundPlayer.delegate = self
                    if(soundPlayer.play()){
                        print("Sound play success")
                    }else{
                        print("Sound file could not be played")
                    }
                }else{
                    print("preparation failure")
                }
                
            }catch{
                print("Sound file could not be found")
            }
        }else{
            print("path not found")
        }
    }
}
