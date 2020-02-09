//
//  ComprehensionTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/23/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class ComprehensionTaskViewController: ActiveStepViewController {

    var shapes = [UIImage]()
    var stimuliCollection: UICollectionView!
    let LARGE_SIZE = 150.0
    let MEDIUM_SIZE = 100.0
    let SMALL_SIZE = 40.0
    let SHAPES_PER_ROW = 5
    let blue = UIColor.blue.cgColor
    let red = UIColor.red.cgColor
    let yellow = UIColor.yellow.cgColor
    let green = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0).cgColor
    
    var selectedFigures = [Int]()
    var selectedFiguresIndexPaths = [IndexPath]()
    var singleSelection: Bool!
    var sounds = [String]()
    var index = 0
    var audioPlayer: AVAudioPlayer!
    var playBtnWidth: NSLayoutConstraint?
    var soundName: String?
    var start: CFAbsoluteTime!
    var reactionTime: Int?
    var isAudioFinished = false
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    let testSingleSelectionSetup = [
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        false,
        false,
        false,
        false,
        false,
        false,
        true,
        false,
        false
    ]
    
    let playBtn: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .portrait
        rotateOrientation = .portrait
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        shapes.append(Utility.drawSquare(color: blue, canvasSize: LARGE_SIZE, shapeSize: LARGE_SIZE))
        shapes.append(Utility.drawSquare(color: yellow, canvasSize: LARGE_SIZE, shapeSize: MEDIUM_SIZE))
        shapes.append(Utility.drawCircle(color: red, canvasSize: LARGE_SIZE, shapeSize: SMALL_SIZE))
        shapes.append(Utility.drawSquare(color: green, canvasSize: LARGE_SIZE, shapeSize: LARGE_SIZE))
        shapes.append(Utility.drawTriangle(color: yellow, canvasSize: LARGE_SIZE, shapeSize: SMALL_SIZE))
        shapes.append(Utility.drawCircle(color: green, canvasSize: LARGE_SIZE, shapeSize: SMALL_SIZE))
        shapes.append(Utility.drawTriangle(color: blue, canvasSize: LARGE_SIZE, shapeSize: LARGE_SIZE))
        shapes.append(Utility.drawCircle(color: green, canvasSize: LARGE_SIZE, shapeSize: MEDIUM_SIZE))
        shapes.append(Utility.drawTriangle(color: red, canvasSize: LARGE_SIZE, shapeSize: MEDIUM_SIZE))
        shapes.append(Utility.drawCircle(color: blue, canvasSize: LARGE_SIZE, shapeSize: LARGE_SIZE))
        shapes.append(Utility.drawCircle(color: yellow, canvasSize: LARGE_SIZE, shapeSize: MEDIUM_SIZE))
        shapes.append(Utility.drawCircle(color: red, canvasSize: LARGE_SIZE, shapeSize: LARGE_SIZE))
        shapes.append(Utility.drawTriangle(color: blue, canvasSize: LARGE_SIZE, shapeSize: SMALL_SIZE))
        shapes.append(Utility.drawCircle(color: yellow, canvasSize: LARGE_SIZE, shapeSize: MEDIUM_SIZE))
        shapes.append(Utility.drawSquare(color: red, canvasSize: LARGE_SIZE, shapeSize: SMALL_SIZE))
        shapes.append(Utility.drawTriangle(color: green, canvasSize: LARGE_SIZE, shapeSize: LARGE_SIZE))
        shapes.append(Utility.drawSquare(color: yellow, canvasSize: LARGE_SIZE, shapeSize: SMALL_SIZE))
        shapes.append(Utility.drawSquare(color: red, canvasSize: LARGE_SIZE, shapeSize: MEDIUM_SIZE))
        shapes.append(Utility.drawTriangle(color: blue, canvasSize: LARGE_SIZE, shapeSize: MEDIUM_SIZE))
        shapes.append(Utility.drawSquare(color: green, canvasSize: LARGE_SIZE, shapeSize: LARGE_SIZE))
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        stimuliCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stimuliCollection.backgroundColor = .white
        stimuliCollection.dataSource = self
        stimuliCollection.delegate = self
        
        stimuliCollection.register(UINib(nibName: "ComprehensionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ComprehensionCell")

        stimuliCollection.translatesAutoresizingMaskIntoConstraints = false
                
        playBtn.setTitle("comprehension_audio_button".localized(lang: language), for: .normal)
        nextBtn.isHidden = true
        
        sounds = DataManager.sharedInstance.comprehensionSounds
        
        setupView()
        startTest()
    }
    
    private func setupView() {
        contentView.addSubview(stimuliCollection)
        contentView.addSubview(playBtn)
        
        stimuliCollection.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stimuliCollection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stimuliCollection.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stimuliCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        
        playBtn.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        playBtn.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        playBtn.topAnchor.constraint(equalTo: stimuliCollection.bottomAnchor, constant: -20.0).isActive = true
        
        playBtnWidth = playBtn.widthAnchor.constraint(equalToConstant: playBtn.intrinsicContentSize.width + 100.0)
        playBtnWidth?.isActive = true
        
        stimuliCollection.allowsMultipleSelection = true
    }
    
    private func startTest() {
        if index < sounds.count {
            selectedFigures.removeAll()
            selectedFiguresIndexPaths.removeAll()
            singleSelection = testSingleSelectionSetup[index]
            soundName = sounds[index]
        }
    }
    
    @objc func moveOn() {
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        let mill = elapsed * 1000
        reactionTime = Int(mill)
        
        ComprehensionModel.shared.answers["\(index + 1)"] = selectedFigures
        ComprehensionModel.shared.reactionTimes["\(index + 1)"] = reactionTime
        
        index += 1
        
        if index < sounds.count {
            playBtn.isHidden = false
            nextBtn.isHidden = true
            
            for index in selectedFiguresIndexPaths {
                stimuliCollection.deselectItem(at: index, animated: true)
            }
            stimuliCollection.reloadData()
            startTest()
        } else {
//            self.performSegue(withIdentifier: "moveToDone", sender: nil)
            let vc = ComprehensionTaskDoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func playPressed() {
        if let sound = soundName {
            isAudioFinished = false
            playBtn.isHidden = true
            playAudio(fileName: sound)
        }
    }
    
    private func playAudio(fileName: String) {
        let fileNameArray = fileName.components(separatedBy: ".")
        
        if let dirPath = Bundle.main.path(forResource: fileNameArray[0], ofType: fileNameArray[1]) {
            let filePath = URL(fileURLWithPath: dirPath)
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }
            catch {
                // report for an error
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioPlayer.delegate = self
                audioPlayer.play()
            } catch {
                print("No Audio")
            }
        }
    }
    
    private func finishedPlaying() {
        playBtn.isHidden = true
        isAudioFinished = true
        start = CFAbsoluteTimeGetCurrent()
    }
}

extension ComprehensionTaskViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if isAudioFinished {
            if (singleSelection && selectedFigures.count == 0) || !singleSelection {
                selectedFigures.append(indexPath.row + 1)
                selectedFiguresIndexPaths.append(indexPath)
                nextBtn.isHidden = false
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if isAudioFinished {
            if (singleSelection) {
                selectedFigures.removeAll()
                selectedFiguresIndexPaths.removeAll()
                nextBtn.isHidden = true
            } else {
                selectedFigures.removeAll { $0 == indexPath.row + 1 }
                selectedFiguresIndexPaths.removeAll { $0 == indexPath }
                
                if selectedFigures.count > 0 {
                    nextBtn.isHidden = false
                }
            }
            
            return true
        }
        
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ComprehensionCollectionViewCell

        if (cell.isSelected) {
            cell.colorView.backgroundColor = UIColor.red
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ComprehensionCollectionViewCell

        if (!cell.isSelected) {
            cell.colorView.backgroundColor = UIColor.white
        }
    }
}

extension ComprehensionTaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shapes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComprehensionCell", for: indexPath) as! ComprehensionCollectionViewCell
        
        cell.shapeImageView.image = shapes[indexPath.row]
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.shapeImageView.backgroundColor = UIColor.white
        
        if (!cell.isSelected) {
            cell.colorView.backgroundColor = UIColor.white
        }
        
        return cell
    }
}

extension ComprehensionTaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGFloat(collectionView.bounds.size.width / CGFloat(SHAPES_PER_ROW))
        return CGSize(width: size, height: size)
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

extension ComprehensionTaskViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            finishedPlaying()
        }
    }
}
