//
//  CancellationBlockViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/18/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CancellationBlockViewController: ActiveStepViewController {

    var stimuliCollection: UICollectionView!
    var timer = Timer()
    
    let startTest: NavigationButton = {
        var button = NavigationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 120.0, bottom: 0.0, right: 120.0)
    private let itemsPerRow: CGFloat = 20
    private var responses = [Response]()
    private var selectedIndex = [Int]()
    
    var stimulis = [[String]]()
    var index = 0
    var collectionData = [String]()
    var currentTime: CFAbsoluteTime?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        stimuliCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stimuliCollection.backgroundColor = .white
        stimuliCollection.dataSource = self
        stimuliCollection.delegate = self
        
        stimuliCollection.register(UINib(nibName: "CancellationViewCell", bundle: nil), forCellWithReuseIdentifier: "CancellationCell")
        stimuliCollection.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stimuliCollection)
        
        stimuliCollection.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stimuliCollection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stimuliCollection.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stimuliCollection.bottomAnchor.constraint(equalTo: startTest.topAnchor, constant: -16.0).isActive = true
        
        stimuliCollection.isHidden = true
        nextBtn.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        startTest.setTitle("Start Test", for: .normal)
        startTest.addTarget(self, action: #selector(showBoard), for: .touchUpInside)
        
        
        
        contentView.addSubview(startTest)
        
        startTest.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        startTest.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        startTest.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        startTest.widthAnchor.constraint(equalToConstant: startTest.intrinsicContentSize.width + 100.0).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0).isActive = true
        nextBtn.removeFromSuperview()
        
        stimulis = [
            ["5", "X", "N", "W", "A", "W", "V", "0", "Q", "N", "5", "9", "C", "2", "B", "Y", "V", "E", "5", "Q", "P", "8", "V", "9", "J", "9", "2", "7", "5", "2", "C", "A", "1", "C", "W", "9", "6", "R", "0", "D", "G", "R", "5", "6", "Q", "F", "L", "9", "8", "G", "9", "Y", "2", "Z", "T", "G", "5", "1", "H", "2"],
            ["B", "A", "1", "3", "R", "3", "Q", "6", "2", "9", "N", "W", "V", "W", "I", "H", "9", "5", "1", "5", "B", "9", "C", "9", "E", "V", "E", "S", "5", "0", "7", "F", "7", "L", "C", "V", "Q", "9", "T", "6", "W", "T", "5", "H", "H", "C", "C", "5", "B", "J", "5", "Z", "L", "X", "5", "T", "J", "8", "Y", "X"],
            ["8", "3", "8", "V", "Y", "G", "9", "6", "K", "9", "V", "5", "C", "9", "D", "I", "3", "G", "6", "T", "J", "A", "P", "5", "A", "C", "9", "M", "6", "L", "D", "9", "8", "X", "6", "0", "F", "I", "J", "5", "9", "9", "V", "5", "X", "0", "W", "3", "9", "6", "1", "C", "2", "2", "6", "6", "A", "4", "P", "4"],
            ["5", "2", "I", "5", "S", "G", "2", "R", "1", "G", "V", "D", "K", "9", "9", "7", "M", "R", "E", "B", "U", "M", "6", "7", "Y", "5", "W", "P", "T", "9", "X", "2", "0", "C", "A", "B", "9", "L", "6", "5", "R", "D", "F", "7", "D", "K", "4", "9", "F", "I", "2", "M", "9", "Y", "9", "N", "K", "T", "5", "2"],
            ["9", "R", "X", "7", "W", "F", "7", "5", "P", "F", "9", "D", "Q", "1", "8", "R", "P", "5", "8", "X", "E", "4", "N", "D", "R", "Z", "D", "3", "3", "9", "5", "3", "R", "0", "9", "U", "3", "9", "E", "P", "G", "8", "8", "2", "5", "A", "1", "0", "9", "T", "5", "1", "6", "S", "4", "0", "X", "B", "3", "5"],
            ["7", "5", "X", "H", "5", "4", "8", "9", "R", "J", "6", "9", "P", "Y", "S", "A", "0", "F", "Q", "1", "M", "9", "2", "3", "3", "9", "6", "5", "2", "C", "W", "S", "7", "6", "4", "6", "9", "2", "1", "8", "P", "C", "5", "9", "6", "5", "Q", "Z", "8", "3", "2", "L", "1", "A", "R", "D", "5", "1", "Q", "S"],
            ["H", "5", "3", "7", "W", "8", "9", "M", "S", "5", "9", "I", "3", "D", "T", "I", "F", "J", "G", "0", "2", "K", "H", "U", "S", "7", "P", "G", "1", "4", "9", "5", "A", "9", "5", "F", "G", "3", "3", "K", "I", "2", "9", "Q", "L", "2", "1", "9", "X", "8", "D", "B", "2", "P", "9", "9", "N", "1", "V", "Y"],
            ["9", "Z", "X", "7", "A", "L", "8", "B", "F", "A", "5", "5", "9", "L", "7", "V", "1", "G", "J", "W", "N", "L", "Q", "2", "U", "A", "D", "Y", "B", "Q", "5", "4", "Z", "9", "F", "G", "5", "L", "Z", "5", "0", "9", "6", "0", "M", "9", "I", "H", "2", "D", "A", "1", "Y", "7", "5", "F", "M", "9", "7", "Q"],
            ["H", "N", "9", "Z", "8", "K", "U", "P", "9", "Z", "F", "9", "8", "L", "T", "0", "F", "5", "M", "1", "1", "B", "D", "9", "A", "A", "T", "E", "R", "R", "P", "J", "A", "5", "7", "9", "H", "5", "S", "3", "K", "9", "0", "F", "H", "Y", "7", "K", "D", "X", "G", "9", "5", "5", "A", "0", "8", "A", "2", "7"],
            ["Y", "6", "K", "M", "9", "H", "T", "M", "9", "0", "Y", "K", "L", "A", "9", "4", "R", "8", "2", "9", "X", "3", "1", "M", "K", "U", "D", "X", "L", "9", "T", "Y", "L", "5", "Q", "T", "G", "5", "V", "5", "7", "M", "0", "2", "X", "6", "4", "6", "D", "7", "C", "P", "R", "9", "5", "9", "L", "A", "9", "W"],
            ["I", "N", "F", "5", "5", "T", "4", "H", "9", "Y", "K", "W", "F", "W", "6", "G", "4", "Q", "V", "5", "M", "F", "B", "9", "8", "9", "N", "1", "8", "A", "V", "V", "9", "E", "8", "T", "9", "V", "U", "1", "W", "D", "Q", "D", "Z", "T", "4", "D", "M", "3", "3", "9", "2", "9", "2", "T", "9", "3", "9", "7"],
            ["5", "Y", "7", "4", "G", "K", "9", "8", "J", "3", "F", "E", "5", "I", "6", "V", "5", "F", "S", "A", "5", "D", "5", "M", "0", "P", "P", "T", "I", "7", "M", "9", "9", "V", "3", "0", "V", "4", "6", "H", "T", "D", "9", "5", "8", "0", "Z", "Q", "D", "K", "U", "9", "Y", "4", "K", "A", "X", "1", "9", "1"],
            ["C", "6", "Q", "R", "I", "8", "T", "7", "T", "2", "5", "I", "6", "P", "0", "B", "9", "9", "9", "C", "5", "U", "3", "5", "C", "7", "R", "Z", "6", "M", "1", "T", "9", "Q", "5", "8", "F", "I", "N", "X", "8", "P", "J", "9", "9", "P", "5", "I", "C", "0", "5", "U", "7", "U", "Z", "C", "3", "B", "4", "6"]]
    }
    
    @objc func moveOn() {
        timer.invalidate()
        self.performSegue(withIdentifier: "moveToDone", sender: nil)
    }
    
    @objc func showBoard() {
        stimuliCollection.isHidden = false
        startTest.isHidden = true
        refreshCollection(data: stimulis[index])
        self.currentTime = CFAbsoluteTimeGetCurrent()
        index += 1
        
        Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { timer in
            self.timer = timer
            self.timerHandler()
        }
    }
    
    @objc func timerHandler() {
        self.currentTime = CFAbsoluteTimeGetCurrent()
        if self.index == self.stimulis.count {
            timer.invalidate()
            self.performSegue(withIdentifier: "moveToDone", sender: nil)
        } else {
            self.refreshCollection(data: self.stimulis[self.index])
            self.index += 1
        }
    }
    
    private func refreshCollection(data: [String]) {
        collectionData = data
        
        for indexPath in stimuliCollection.indexPathsForVisibleItems {
            if let cell = stimuliCollection.cellForItem(at: indexPath) as? CancellationViewCell {
                cell.isSelected = false
                cell.label.textColor = .black
                cell.label.font = UIFont.boldSystemFont(ofSize: 35.0)
            }
        }
        
        responses.removeAll()
        stimuliCollection.reloadData()
    }
}

extension CancellationBlockViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CancellationViewCell
        
        if (cell.isSelected) {
            cell.label.textColor = .red
            cell.label.font = UIFont.boldSystemFont(ofSize: 40.0)
            if !selectedIndex.contains(indexPath.row) {
                selectedIndex.append(indexPath.row)
                // Add values to responses array
                let response = Response(index: indexPath.row, value: collectionData[indexPath.row], time: Int((CFAbsoluteTimeGetCurrent() - currentTime!) * 1000))
                responses.append(response)
                CancellationModel.shared.blocks["block_\(index)"] = responses
                
            }
        } else {
            cell.label.textColor = .black
        }
    }
}

extension CancellationBlockViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CancellationCell", for: indexPath) as! CancellationViewCell
        
        cell.label.text = collectionData[indexPath.row]
        cell.label.font = UIFont.boldSystemFont(ofSize: 35.0)
        
        return cell
    }
}

extension CancellationBlockViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = 36.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}
