//
//  CancellationPracticeViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/10/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CancellationPracticeViewController: ActiveStepViewController {

    var stimuliCollection: UICollectionView!
    
    let startTest: NavigationButton = {
        var button = NavigationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 120.0, bottom: 0.0, right: 120.0)
    private let itemsPerRow: CGFloat = 20
    private var responses = [Int]()
    private let BUTTON_PADDING: CGFloat = 100.0
    
    var stimulis = [[String]]()
    var isFirst = true
    var collectionData = [String]()
    var startBtnWidth: NSLayoutConstraint?
    
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

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        titleLabel.text = "Practice Testing"
        
        startTest.setTitle("Start Practice Test", for: .normal)
        startTest.addTarget(self, action: #selector(showBoard), for: .touchUpInside)
        
        
        
        contentView.addSubview(startTest)
        
        startTest.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        startTest.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        startTest.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        startBtnWidth = startTest.widthAnchor.constraint(equalToConstant: startTest.intrinsicContentSize.width + BUTTON_PADDING)
        startBtnWidth?.isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0).isActive = true
        nextBtn.removeFromSuperview()
        
        stimulis = [
            ["5", "X", "N", "W", "A", "W", "V", "0", "Q", "N", "5", "9", "C", "2", "B", "Y", "V", "E", "5", "Q", "P", "8", "V", "9", "J", "9", "2", "7", "5", "2", "C", "A", "1", "C", "W", "9", "6", "R", "0", "D", "G", "R", "5", "6", "Q", "F", "L", "9", "8", "G", "9", "Y", "2", "Z", "T", "G", "5", "1", "H", "2"],
            ["B", "A", "1", "3", "R", "3", "Q", "6", "2", "9", "N", "W", "V", "W", "I", "H", "9", "5", "1", "5", "B", "9", "C", "9", "E", "V", "E", "S", "5", "0", "7", "F", "7", "L", "C", "V", "Q", "9", "T", "6", "W", "T", "5", "H", "H", "C", "C", "5", "B", "J", "5", "Z", "L", "X", "5", "T", "J", "8", "Y", "X"]]
    }
    
    @objc func moveOn() {
        self.performSegue(withIdentifier: "moveToBlocks", sender: nil)
    }

    @objc func showBoard() {
        if isFirst {
            stimuliCollection.isHidden = false
            refreshCollection(data: stimulis[0])
            stimulis.remove(at: 0)
            isFirst = false
            startTest.setTitle("Click Here for the Second Practice Test", for: .normal)
            startBtnWidth?.constant = startTest.intrinsicContentSize.width + BUTTON_PADDING
        } else {
            refreshCollection(data: stimulis[0])
            stimulis.remove(at: 0)
            isFirst = true
            startTest.setTitle("I am done practicing", for: .normal)
            startBtnWidth?.constant = startTest.intrinsicContentSize.width + BUTTON_PADDING
            startTest.removeTarget(self, action: #selector(showBoard), for: .touchUpInside)
            startTest.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
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
        
        stimuliCollection.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CancellationPracticeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CancellationViewCell
        
        if (cell.isSelected) {
            cell.label.textColor = .red
            cell.label.font = UIFont.boldSystemFont(ofSize: 40.0)
        } else {
            cell.label.textColor = .black
        }
    }
}

extension CancellationPracticeViewController: UICollectionViewDataSource {
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

extension CancellationPracticeViewController: UICollectionViewDelegateFlowLayout {
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
