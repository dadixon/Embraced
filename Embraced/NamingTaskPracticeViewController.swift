//
//  NamingTaskPracticeViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/29/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class NamingTaskPracticeViewController: ActiveStepViewController {

    var isRecording = false
    var imagePath: [String]?
    var index = 0
    var documentPath: URL?
    
    let taskImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let recordBtn: RecordButton = {
        var button = RecordButton(type: UIButton.ButtonType.custom) as RecordButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        titleLabel.text = "Example".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        nextBtn.isHidden = false
        
        setupView()
        
        imagePath = DataManager.sharedInstance.namingTaskPractice
        
        setState()
    }
    
    private func setupView() {
        contentView.addSubview(taskImageView)
        contentView.addSubview(recordBtn)
        
        taskImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        taskImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32.0).isActive = true
        taskImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32.0).isActive = true
        taskImageView.bottomAnchor.constraint(equalTo: recordBtn.topAnchor, constant: -32.0).isActive = true
        taskImageView.heightAnchor.constraint(equalToConstant: 420).isActive = true
        
        recordBtn.topAnchor.constraint(equalTo: taskImageView.bottomAnchor, constant: 32.0).isActive = true
        recordBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        recordBtn.widthAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.heightAnchor.constraint(equalToConstant: 165.0).isActive = true
        recordBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @objc func recordPressed() {
        if isRecording {
            recordBtn.btnRecord()
            isRecording = false
        } else {
            recordBtn.btnStop()
            isRecording = true
        }
    }
    
    @objc func moveOn() {
        index += 1
        if index < imagePath!.count {
            setState()
        } else {
//            self.performSegue(withIdentifier: "moveToInstructions2", sender: nil)
            let vc = NamingTaskInstructions2ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setState() {
        if let imageP = imagePath {
            taskImageView.image = UIImage(named: imageP[index])
            recordBtn.btnRecord()
        }
    }
}
