//
//  FrontViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/29/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class FrontViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var loadingView = UIActivityIndicatorView()
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    let participant = UserDefaults.standard
    
    var orientation = "portrait"
    var language = String()
    
    var step = 1
    var totalSteps = 20
    var progress : Float {
        get {
            return Float(step) / Float(totalSteps)
        }
    }
    
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
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.7
        mainView.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        mainView.layer.shadowRadius = 10
        mainView.layer.shouldRasterize = true
        
        self.automaticallyAdjustsScrollViewInsets = false
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
        
        SVProgressHUD.setDefaultStyle(.dark)

    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func showOrientationAlert(orientation: String) {
        language = participant.string(forKey: "language")!
        
        if orientation == "landscape" {
            let alertController = UIAlertController(title: "Rotation".localized(lang: language), message: "Rotation_landscpaing_prompt".localized(lang: language), preferredStyle: UIAlertControllerStyle.alert)
            
            self.present(alertController, animated: true, completion: nil)
            
            let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(dismissAction)
        } else if orientation == "portrait" {
            let alertController = UIAlertController(title: "Rotation".localized(lang: language), message: "Rotation_portrait_prompt".localized(lang: language), preferredStyle: UIAlertControllerStyle.alert)
                
            self.present(alertController, animated: true, completion: nil)
            
            let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(dismissAction)
        }
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
    
    func deleteAudioFile(fileURL: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: fileURL)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func playTest(_ filename:String) {
        let pathResource = getDocumentsDirectory().appendingPathComponent(filename)
            
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: pathResource)
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
    }
    
    func play(_ filename:String) {
        if let asset = NSDataAsset(name:filename){
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound.
                soundPlayer = try AVAudioPlayer(data: asset.data)
                if(soundPlayer?.prepareToPlay())!{
                    print("preparation success")
                    soundPlayer?.delegate = self
                    if(soundPlayer?.play())!{
                        print("Sound play success")
                    }else{
                        SVProgressHUD.showError(withStatus: "Sound file could not be played")
                    }
                }else{
                    print("preparation failure")
                }
            } catch let error as NSError {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
        
//        let pathResource = getDocumentsDirectory().appendingPathComponent(filename)
//
//        do {
//            soundPlayer = try AVAudioPlayer(contentsOf: pathResource)
//            if(soundPlayer?.prepareToPlay())!{
//                print("preparation success")
//                soundPlayer?.delegate = self
//                if(soundPlayer?.play())!{
//                    print("Sound play success")
//                }else{
//                    print("Sound file could not be played")
//                }
//            }else{
//                print("preparation failure")
//            }
//
//        }catch{
//            print("Sound file could not be found")
//        }
    }
    
    func fileExist(_ filename: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(filename)?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            print("FILE \(filename) AVAILABLE")
            return true
        } else {
            print("FILE \(filename) NOT AVAILABLE")
        }
        
        return false
    }
    
    func deleteFile(_ fileNameToDelete:String) {
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    public func showOverlay() {
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = self.view.center
        overlayView.backgroundColor = UIColor.black
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
