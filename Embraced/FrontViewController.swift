//
//  FrontViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/29/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
//import Stormpath
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
    var soundPlayer: AVAudioPlayer?
    var viewPosition = 0
    var testsArray = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadingView.center = mainView.center
        loadingView.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        testsArray = participant.array(forKey: "Tests")! as! [String]
        
        progressView.progress = progress
        progressLabel.text = "Progress (\(step + 1)/\(testsArray.count + 1))"
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Embraced_bg.png")!)
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.7
        mainView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        mainView.layer.shadowRadius = 10
        mainView.layer.shouldRasterize = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftConstraint = mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0)
        let topConstraint = mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 48.0)
        let rightConstraint = mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8.0)
        let bottomConstraint = mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 8.0)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clear

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
        navigationArray?.append(viewController)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }
    
    func nextViewController2(position: Int) {
        let vc: UIViewController!
        
        if position >= testsArray.count {
            vc = FinishedViewController()
        } else {
            switch testsArray[position] {
            case "Questionnaire":
                vc = QuestionnaireViewController()
            case "MoCA/MMSE":
                vc = MOCAMMSETestViewController()
            case "Rey Complex Figure 1":
                vc = ReyComplexFigureViewController()
            case "Clock Drawing Test":
                vc = ClockDrawingTestViewController()
            case "Rey Complex Figure 2":
                vc = ReyComplexFigure2ViewController()
            case "Trail Making":
                vc = TrailMakingTestViewController()
            case "Pitch":
                vc = PitchViewController()
            case "Digit Span":
                vc = DigitalSpanViewController()
            case "Rey Complex Figure 3":
                vc = ReyComplexFigure3ViewController()
            case "Rey Complex Figure 4":
                vc = ReyFigureComplex4ViewController()
            case "Matrices":
                vc = MatricesViewController()
            case "Continuous Performance Test":
                vc = CPTViewController()
            case "Motor Tasks":
                vc = PegboardViewController()
            case "Word List 1":
                vc = WordListViewController()
            case "Stroop Test":
                vc = StroopViewController()
            case "Cancellation Test":
                vc = CancellationTestViewController()
            case "Word List 2":
                vc = WordList2ViewController()
            case "Naming Task":
                vc = NamingTaskViewController()
            case "Comprehension Task":
                vc = ComprehensionViewController()
            case "Eye Test":
                vc = EyeTestViewController()
            default:
                vc = UserInputViewController()
            }
        }
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        //        let reyComplexFigure3ViewController:viewController = viewController()
        navigationArray?.append(vc)
        
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
        
        if let pathResource = Bundle.main.path(forResource: file[0], ofType: file[1]) {
            let finishedStepSound = NSURL(fileURLWithPath: pathResource)
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: finishedStepSound as URL)
                if(soundPlayer?.prepareToPlay())!{
                    print("preparation success")
                    soundPlayer?.delegate = self
                    if(soundPlayer?.play())!{
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
