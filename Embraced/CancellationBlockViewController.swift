//
//  CancellationBlockViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/18/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

struct Response {
    var index: Int
    var value: String
    var time: Int
}

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startTest.setTitle("Start Test", for: .normal)
        startTest.addTarget(self, action: #selector(showBoard), for: .touchUpInside)
        
        nextBtn.isHidden = true
        
        contentView.addSubview(startTest)
        
        startTest.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        startTest.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        startTest.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        startTest.widthAnchor.constraint(equalToConstant: startTest.intrinsicContentSize.width + 30.0).isActive = true
        
        stimulis = [
            ["5", "X", "N", "W", "A", "W", "V", "0", "Q", "N", "5", "9", "C", "2", "B", "Y", "V", "E", "5", "Q", "P", "8", "V", "9", "J", "9", "2", "7", "5", "2", "C", "A", "1", "C", "W", "9", "6", "R", "0", "D", "G", "R", "5", "6", "Q", "F", "L", "9", "8", "G", "9", "Y", "2", "Z", "T", "G", "5", "1", "H", "2"],
            ["B", "A", "1", "3", "R", "3", "Q", "6", "2", "9", "N", "W", "V", "W", "I", "H", "9", "5", "1", "5", "B", "9", "C", "9", "E", "V", "E", "S", "5", "0", "7", "F", "7", "L", "C", "V", "Q", "9", "T", "6", "W", "T", "5", "H", "H", "C", "C", "5", "B", "J", "5", "Z", "L", "X", "5", "T", "J", "8", "Y", "X"]]
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToDone", sender: nil)
    }
    
    @objc func showBoard() {
        stimuliCollection.isHidden = false
        startTest.isHidden = true
        refreshCollection(data: stimulis[index])
        self.currentTime = CFAbsoluteTimeGetCurrent()
        index += 1
        
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { timer in
                self.timer = timer
                self.timerHandler()
            }
        } else {
            // Fallback on earlier versions
            timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: true)
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
                CancellationModel.sharedInstance.blocks["block_\(index)"] = responses
                
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
