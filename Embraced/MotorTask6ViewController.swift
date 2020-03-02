//
//  MotorTask6ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/5/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import SVProgressHUD

class MotorTask6ViewController: ActiveStepViewController {

    let TEST_NAME = "Motor"
    var documentPath: URL?
    let fileName = "task6.png"
    var saveImagePath: URL!
    var timer = Timer()
    var totalSeconds = 15
    var tapIndex = 1
    var tapViews = [MotorTapView]()
    var SECONDS = ""
    
    let timerLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    let canvas: UIImageView = {
        var canvasView = UIImageView()
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.isUserInteractionEnabled = true
        canvasView.contentMode = .scaleAspectFit
        return canvasView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "motor_nondominant".localized(lang: language)
        
        nextBtn.setTitle("Start".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
                
        setupViews()
        
        SECONDS = "second(s)".localized(lang: language)
        timerLabel.text = "\(totalSeconds) " + SECONDS
        canvas.isHidden = true
        
        canvas.image = Utility.getImage(path: "motorTask/\(DataManager.sharedInstance.motorTask[1])")
        
        documentPath = Utility.getDocumentsDirectory().appendingPathComponent("\(FirebaseStorageManager.shared.pid!)/\(TEST_NAME)")
        do
        {
            try FileManager.default.createDirectory(atPath: documentPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showMoreActions))
        
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    private func setupViews() {
        contentView.addSubview(canvas)
        contentView.addSubview(timerLabel)
                
        instructionsLabel.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        instructionsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0).isActive = true
        
        timerLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: -16.0).isActive = true
        timerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30.0).isActive = true
        timerLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        contentView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 16.0).isActive = true
        
        canvas.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func startTest() {
        var runCount = 0
                
        timer.invalidate()
        
        timer = Timer(timeInterval: 1.0, repeats: true) { timer in
            runCount += 1
            
            self.timerLabel.text = "\(self.totalSeconds - runCount) " + self.SECONDS
            
            if runCount == self.totalSeconds {
                timer.invalidate()
                self.moveOn()
            }
        }
        
        timer.tolerance = 0.2
        RunLoop.current.add(timer, forMode: .common)
    }
    
    @objc func startPressed() {
        canvas.isHidden = false
        nextBtn.isHidden = true
        
        startTest()
    }
    
    @objc func moveOn() {
        showLabels()
        canvas.image = drawImage()
        
        if let image = canvas.image {
            if let data = image.pngData() {
                if let path = documentPath {
                    let imageFilename = path.appendingPathComponent(fileName)
                    saveImagePath = imageFilename
                    try? data.write(to: imageFilename)
                    externalStorage()
                }
            }
        }
    }
    
    @objc func showMoreActions(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: view)
        let dynamicView = UIView(frame: CGRect(x: touchPoint.x - 10, y: touchPoint.y - 10, width: 20, height: 20))
        dynamicView.backgroundColor = UIColor.green
        dynamicView.layer.borderWidth = 2
        self.view.addSubview(dynamicView)
    }
    
    private func externalStorage() {
        SVProgressHUD.show()
        let filePath = "\(FirebaseStorageManager.shared.pid!)/\(TEST_NAME)/\(fileName)"
        
        if Utility.fileExist(filePath) {
            FirebaseStorageManager.shared.externalStorage(filePath: filePath, fileUrl: saveImagePath) { (uploadTask, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
                
                if let task = uploadTask {
                    task.observe(.success, handler: { (snapshot) in
                        MotorModel.shared.nondominants["3"] = filePath
                        
                        FirebaseStorageManager.shared.addDataToDocument(payload: [
                            "motorTask": MotorModel.shared.getModel()
                        ])
                        
//                        self.performSegue(withIdentifier: "moveToDone", sender: nil)
                        let vc = MotorDoneViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        Utility.deleteFile(filePath)
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }

    private func showLabels() {
        for view in tapViews {
            view.indexLabel.isHidden = false
        }
    }
    
    private func drawImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: canvas.bounds)
        
        return renderer.image { rendererContext in
            canvas.layer.render(in: rendererContext.cgContext)
        }
    }
}
