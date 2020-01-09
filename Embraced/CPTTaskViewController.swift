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
    private var taskChoices = [[Character]]()
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private var blockIndex = 0
    private var taskIndex = 0
    private let BLOCK_COUNT = 3
    private let STIMULI = 10
    private let STIMULI_TIMEOUT = 1.5
    private let LETTER_LENGTH = 0.75
    private let BLOCK_TIMEOUT = 3.0
    private let TARGET_PERCENT = 20
    private var start: CFAbsoluteTime!
    private var reactionTime: Int?
    private var taskTimer = Timer()
    private var response: CPTResponse?
    private var responses = [CPTResponse]()
    var cptModel = CPTModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        taskChoices = [
            ["A", "B", "C"],
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
        stimuliCollection.isHidden = true
        
        nextBtn.setTitle("Start".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(startTest), for: .touchUpInside)
        nextBtn.isHidden = false
        
        setupView()
        
        createBlock(stimuliCount: STIMULI)
    }
    
    private func setupView() {
        contentView.addSubview(stimuliCollection)

        stimuliCollection.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stimuliCollection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stimuliCollection.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stimuliCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stimuliCollection.allowsMultipleSelection = false
    }
    
    private func createBlock(stimuliCount: Int) {
        let numberOfStimuli = TARGET_PERCENT / 100 * STIMULI
        var blockString = randomString(length: stimuliCount)
        print("\(blockString)")
        
        while true {
            if !blockString.contains("XA") {
                break
            }
        }
        print("\(blockString)")
        print("\(numberOfStimuli)")
        
        let start = blockString.index(blockString.startIndex, offsetBy: 1)
        let end = blockString.index(blockString.startIndex, offsetBy: 3)
        let myRange = start..<end
        
        blockString.replaceSubrange(myRange, with: ["X", "A"])
        print("\(blockString)")
    }
    
    func randomString(length: Int) -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @objc private func startTest() {
        showCollection()
        nextBtn.isHidden = true
    }
    
    @objc private func showCollection() {
        stimuliCollection.isHidden = false
        start = CFAbsoluteTimeGetCurrent()
        perform(#selector(hideCollection), with: nil, afterDelay: STIMULI_TIMEOUT)
    }
    
    @objc private func hideCollection() {
        stimuliCollection.isHidden = true
        taskIndex += 1
        
        if taskIndex < taskChoices[blockIndex].count {
            stimuliCollection.reloadData()
            perform(#selector(showCollection), with: nil, afterDelay: LETTER_LENGTH)
        } else if blockIndex + 1 < taskChoices.count {
            cptModel.blocks["BLOCK_\(blockIndex)"] = responses
            responses.removeAll()
            blockIndex += 1
            taskIndex = 0
            
            stimuliCollection.reloadData()
            perform(#selector(showCollection), with: nil, afterDelay: BLOCK_TIMEOUT)
        } else {
            cptModel.blocks["BLOCK_\(blockIndex)"] = responses
            
            nextBtn.setTitle("Next".localized(lang: language), for: .normal)
            nextBtn.removeTarget(self, action: #selector(startTest), for: .touchUpInside)
            nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
            nextBtn.isHidden = false
        }
    }
    
    @objc func moveOn() {
        FirebaseStorageManager.shared.addDataToDocument(payload: [
            "cptTest" : cptModel.getModel()
        ])
        performSegue(withIdentifier: "moveToDone", sender: nil)
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
            response = CPTResponse(index: taskIndex, value: taskChoices[blockIndex][taskIndex], prevValue: nil, time: reactionTime)
        }
        
        if let response = response {
            responses.append(response)
        }
        
        return true
    }
}

extension CPTTaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CPTCell", for: indexPath) as! CPTCollectionCell

        cell.charLabel.text = String(taskChoices[blockIndex][taskIndex])
        
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
