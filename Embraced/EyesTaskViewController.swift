//
//  EyesTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/11/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

struct EyeAnswerInfo {
    var title: String!
    var definition: String!
    var example: String!
}

class EyesTaskViewController: ActiveStepViewController {

    var imagePath: [String]?
    var index = 0
    var stimuliCollection: UICollectionView!
    var choices = [[EyeAnswerInfo]]()
    var selectedAnswer = Int()
    var selectedAnswersIndexPath: IndexPath?
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
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
        
        imagePath = DataManager.sharedInstance.eyesTestImages
        
        EyeTestModel.shared.answers = [Int]()
        
        getImage()
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        nextBtn.isHidden = true
        
        choices = DataManager.sharedInstance.eyesTestChoices
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        stimuliCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stimuliCollection.backgroundColor = .white
        stimuliCollection.dataSource = self
        stimuliCollection.delegate = self
        
        stimuliCollection.register(UINib(nibName: "EyesTestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EyesTestCell")

        stimuliCollection.translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(taskImageView)
        contentView.addSubview(stimuliCollection)
        
        taskImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        taskImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 32.0).isActive = true
        taskImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -32.0).isActive = true
        taskImageView.heightAnchor.constraint(equalToConstant: 420).isActive = true

        stimuliCollection.topAnchor.constraint(equalTo: taskImageView.bottomAnchor).isActive = true
        stimuliCollection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stimuliCollection.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stimuliCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        
        stimuliCollection.allowsMultipleSelection = false
    }
    
    private func getImage() {
        if let imagePaths = imagePath {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

            if path != "" {
                let imageURL = URL(fileURLWithPath: path).appendingPathComponent("media/eyesTest/\(imagePaths[index])")
                let image = UIImage(contentsOfFile: imageURL.path)
               
                taskImageView.image = image
            }
        }
    }
    
    @objc func moveOn() {
        index += 1
        
        EyeTestModel.shared.answers.append(selectedAnswer)
        
        if index >= choices.count {
            self.performSegue(withIdentifier: "moveToDone", sender: nil)
        } else {
            getImage()
            stimuliCollection.reloadData()
        }
    }
    
    @objc func showInfo(sender:UIButton!) {
        let titleFont = UIFont.boldSystemFont(ofSize: 20.0)
        let messageFont = UIFont.boldSystemFont(ofSize: 18.0)
        let titleAttributes = [NSAttributedString.Key.font: titleFont]
        let messageAttributes = [NSAttributedString.Key.font: messageFont]
        
        let attributedTitle = NSMutableAttributedString(string: choices[index][sender.tag].title, attributes: titleAttributes)
        let attributedDefinition = NSMutableAttributedString(string: choices[index][sender.tag].definition, attributes: messageAttributes)
        
        if let example = choices[index][sender.tag].example {
            let attributedExample = NSAttributedString(string: "\n\(example)")
        
            attributedDefinition.append(attributedExample)
        }
        
        let alertController = UIAlertController(title: choices[index][sender.tag].title, message: attributedDefinition.string, preferredStyle: UIAlertController.Style.alert)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedDefinition, forKey: "attributedMessage")
        
        self.present(alertController, animated: true, completion: nil)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(dismissAction)
    }
}

extension EyesTaskViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedAnswer = indexPath.row + 1
        
        if let lastIndexPath = selectedAnswersIndexPath {
            collectionView.deselectItem(at: lastIndexPath, animated: true)
            
            let lastCell = collectionView.cellForItem(at: lastIndexPath) as! EyesTestCollectionViewCell
            lastCell.layer.borderColor = UIColor.black.cgColor
            lastCell.layer.borderWidth = 1
        }
        
        selectedAnswersIndexPath = indexPath
        nextBtn.isHidden = false
        
        print(selectedAnswer)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EyesTestCollectionViewCell

        if (cell.isSelected) {
            cell.layer.borderColor = UIColor.red.cgColor
            cell.layer.borderWidth = 3
        }
    }
}

extension EyesTaskViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices[index].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EyesTestCell", for: indexPath) as! EyesTestCollectionViewCell

        cell.titleLabel.text = choices[index][indexPath.row].title
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.infoButton.tag = indexPath.row
        cell.infoButton.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
                
        return cell
    }
}

extension EyesTaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGFloat(collectionView.bounds.size.width - 100.0)
        return CGSize(width: size, height: 80.0)
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
