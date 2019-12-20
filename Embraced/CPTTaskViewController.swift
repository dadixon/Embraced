//
//  CPTTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/20/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CPTTaskViewController: ActiveStepViewController {

    private var stimuliCollection: UICollectionView!
    private var taskChoices = [[String]]()
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private var blockIndex = 0
    private var taskIndex = 0
    private let BLOCK_COUNT = 3;
    private let STIMULI = 100;
    private let STIMULI_TIMEOUT = 1.5;
    private var LETTER_LENGTH = 0.75;
    private let TARGET_PERCENT = 20;
    private var start: CFAbsoluteTime!
    private var reactionTime: Int?
    private var taskTimer = Timer()
    private var response: CPTResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        taskChoices = [
            ["A", "B", "C", "D", "E", "F", "G", "H", "I"],
            ["D", "E", "F"],
            ["G", "H", "I"]
        ]
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        stimuliCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stimuliCollection.backgroundColor = .white
        stimuliCollection.dataSource = self
        stimuliCollection.delegate = self
        stimuliCollection.register(CPTCollectionCell.self, forCellWithReuseIdentifier: "CPTCell")
        stimuliCollection.translatesAutoresizingMaskIntoConstraints = false
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        nextBtn.isHidden = true
        
        setupView()
        
        startTest()
    }
    
    private func setupView() {
        contentView.addSubview(stimuliCollection)

        stimuliCollection.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stimuliCollection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stimuliCollection.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stimuliCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        stimuliCollection.allowsMultipleSelection = false
    }
    
    private func startTest() {
        showStimuli()
        response = nil
        
        taskTimer = Timer.scheduledTimer(withTimeInterval: LETTER_LENGTH + STIMULI_TIMEOUT, repeats: true) { (timer) in
            if self.taskIndex < self.taskChoices[self.blockIndex].count {
                if self.response == nil {
                    self.response = CPTResponse(index: self.taskIndex, value: nil, prevValue: nil, time: nil)
                    print("Respone: \(self.response)")
                }
                self.response = nil
                self.showStimuli()
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func showStimuli() {
        Timer.scheduledTimer(withTimeInterval: LETTER_LENGTH, repeats: false) { (timer) in
            self.stimuliCollection.isHidden = true
            self.hideStimuli()
            timer.invalidate()
        }
        start = CFAbsoluteTimeGetCurrent()
    }
    
    private func hideStimuli() {
        Timer.scheduledTimer(withTimeInterval: STIMULI_TIMEOUT, repeats: false) { (timer) in
            if self.taskIndex + 1 == self.taskChoices[self.blockIndex].count {
                self.taskTimer.invalidate()
            } else {
                self.taskIndex += 1
                self.stimuliCollection.reloadData()
                self.stimuliCollection.isHidden = false
            }
            timer.invalidate()
        }
    }
    
    @objc func moveOn() {
        
    }
}

extension CPTTaskViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        let mill = elapsed * 1000
        reactionTime = Int(mill)
        
        if taskIndex > 0 {
            response = CPTResponse(index: taskIndex, value: taskChoices[blockIndex][taskIndex], prevValue: taskChoices[blockIndex][taskIndex-1], time: reactionTime)
        } else {
            response = CPTResponse(index: taskIndex, value: taskChoices[blockIndex][taskIndex], prevValue: "", time: reactionTime)
        }
        
        print("Respone: \(response)")
        return true
    }
}

extension CPTTaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CPTCell", for: indexPath) as! CPTCollectionCell

        cell.charLabel.text = taskChoices[blockIndex][taskIndex]
        
        return cell
    }
}

extension CPTTaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
