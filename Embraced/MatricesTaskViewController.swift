//
//  MatricesTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/8/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MatricesTaskViewController: ActiveStepViewController {

    private var stimuliCollection: UICollectionView!
    private var taskChoices = [MatricesTask]()
    private var answers = [Int]()
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private var index = 0
    private var selectedAnswer: Int?
    
    let taskImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .portrait
        rotateOrientation = .portrait
        
        taskChoices = DataManager.sharedInstance.matricesStimuli
        
        taskImageView.image = Utility.getImage(path: "matrices/\(taskChoices[index].displayImageName)")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        stimuliCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stimuliCollection.backgroundColor = .white
        stimuliCollection.dataSource = self
        stimuliCollection.delegate = self
        stimuliCollection.register(MatriceCollectionCell.self, forCellWithReuseIdentifier: "MatricesTestCell")
        stimuliCollection.translatesAutoresizingMaskIntoConstraints = false
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        setupView()
    }
    
    private func setupView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16.0
        
        contentView.addSubview(stackView)
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75.0).isActive = true
                
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0).isActive = true
        
        stackView.addArrangedSubview(taskImageView)
        stackView.addArrangedSubview(stimuliCollection)
        
        stimuliCollection.allowsMultipleSelection = false
    }
    
    @objc func moveOn() {
        
        if let answer = selectedAnswer {
            MatricesModel.shared.answers["\(taskChoices[index].key)"] = answer
        }
        
        selectedAnswer = nil
        
        index += 1
        
        if index >= taskChoices.count {
//            self.performSegue(withIdentifier: "moveToDone", sender: nil)
            let vc = MatricesDoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            taskImageView.image = Utility.getImage(path: "matrices/\(taskChoices[index].displayImageName)")
            stimuliCollection.reloadData()
        }
    }

}

extension MatricesTaskViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedAnswer = indexPath.row + 1

        return true
    }
}

extension MatricesTaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskChoices[index].choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatricesTestCell", for: indexPath) as! MatriceCollectionCell

        let choicePath = taskChoices[index].choices[indexPath.row]
        cell.imageView.image = Utility.getImage(path: "matrices/\(choicePath)")
        
        return cell
    }
}

extension MatricesTaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = taskImageView.frame.width / (CGFloat(taskChoices[index].choices.count) / 2.0)
        let height = (taskImageView.frame.height / 2) - 10
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
