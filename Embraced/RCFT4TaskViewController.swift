//
//  RCFT4TaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/23/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class RCFT4TaskViewController: ActiveStepViewController {

    var index = 0
    var tasks = [String]()
    
    let taskImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let answerSegment: UISegmentedControl = {
        var segment = UISegmentedControl(items: ["asdf", "asdf"])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 27)], for: .normal)
        segment.addTarget(self, action: #selector(segmentPressed), for: .valueChanged)
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        tasks = DataManager.sharedInstance.rcftTasks
        
        answerSegment.setTitle("Yes".localized(lang: language), forSegmentAt: 0)
        answerSegment.setTitle("No".localized(lang: language), forSegmentAt: 1)
        
        setupView()
        initialSetup()
    }
    
    private func setupView() {
        contentView.addSubview(taskImageView)
        contentView.addSubview(answerSegment)
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75.0).isActive = true
                
        taskImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        taskImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        taskImageView.bottomAnchor.constraint(equalTo: answerSegment.topAnchor, constant: -32.0).isActive = true
        
        answerSegment.topAnchor.constraint(equalTo: taskImageView.bottomAnchor, constant: 32.0).isActive = true
        answerSegment.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        answerSegment.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        answerSegment.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        answerSegment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
    }
    
    private func initialSetup() {
        nextBtn.isHidden = true
        answerSegment.isEnabled = true
        answerSegment.selectedSegmentIndex = UISegmentedControl.noSegment
        
        taskImageView.image = Utility.getImage(path: "rcft/\(tasks[index])") //UIImage(named: tasks[index])
    }
    
    private func answerCheck() {
        if (answerSegment.selectedSegmentIndex == 0) {
            RCFTModel.shared.answers["\(index + 1)"] = true
        } else {
            RCFTModel.shared.answers["\(index + 1)"] = false
        }
    }
    
    @objc func moveOn() {
        index += 1
        
        if index == tasks.count {
//            self.performSegue(withIdentifier: "moveToDone", sender: nil)
            let vc = RCFT4DoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            initialSetup()
        }
    }
    
    @objc func segmentPressed() {
        nextBtn.isHidden = false
        answerSegment.isEnabled = false
        answerCheck()
    }
}
