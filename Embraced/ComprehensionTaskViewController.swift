//
//  ComprehensionTaskViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/23/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

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
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orientation = .portrait
        rotateOrientation = .portrait
        
        shapes.append(drawSquare(color: blue, size: LARGE_SIZE))
        shapes.append(drawSquare(color: yellow, size: MEDIUM_SIZE))
        shapes.append(drawCircle(color: red, size: SMALL_SIZE))
        shapes.append(drawSquare(color: green, size: LARGE_SIZE))
        shapes.append(drawTriangle(color: yellow, size: SMALL_SIZE))
        shapes.append(drawCircle(color: green, size: SMALL_SIZE))
        shapes.append(drawTriangle(color: blue, size: LARGE_SIZE))
        shapes.append(drawCircle(color: green, size: MEDIUM_SIZE))
        shapes.append(drawTriangle(color: red, size: MEDIUM_SIZE))
        shapes.append(drawCircle(color: blue, size: LARGE_SIZE))
        shapes.append(drawCircle(color: yellow, size: MEDIUM_SIZE))
        shapes.append(drawCircle(color: red, size: LARGE_SIZE))
        shapes.append(drawTriangle(color: blue, size: SMALL_SIZE))
        shapes.append(drawCircle(color: yellow, size: MEDIUM_SIZE))
        shapes.append(drawSquare(color: red, size: SMALL_SIZE))
        shapes.append(drawTriangle(color: green, size: LARGE_SIZE))
        shapes.append(drawSquare(color: yellow, size: SMALL_SIZE))
        shapes.append(drawSquare(color: red, size: MEDIUM_SIZE))
        shapes.append(drawTriangle(color: blue, size: MEDIUM_SIZE))
        shapes.append(drawSquare(color: green, size: LARGE_SIZE))
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        stimuliCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stimuliCollection.backgroundColor = .white
        stimuliCollection.dataSource = self
        stimuliCollection.delegate = self
        
        stimuliCollection.register(UINib(nibName: "ComprehensionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ComprehensionCell")

        stimuliCollection.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stimuliCollection)
        
        stimuliCollection.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stimuliCollection.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stimuliCollection.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        stimuliCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
        
        stimuliCollection.allowsMultipleSelection = true
    }
    

    private func drawSquare(color: CGColor, size: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: LARGE_SIZE, height: LARGE_SIZE))
        
        let img = renderer.image { ctx in
            let rect = CGRect(x: ((LARGE_SIZE - size) / 2), y: ((LARGE_SIZE - size) / 2), width: size, height: size)
            
            ctx.cgContext.setStrokeColor(UIColor.clear.cgColor)
            ctx.cgContext.setFillColor(color)
            
            ctx.cgContext.addRect(rect)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        return img
    }
    
    private func drawCircle(color: CGColor, size: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: LARGE_SIZE, height: LARGE_SIZE))
        
        let img = renderer.image { ctx in
            let rect = CGRect(x: ((LARGE_SIZE - size) / 2), y: ((LARGE_SIZE - size) / 2), width: size, height: size)
            
            ctx.cgContext.setStrokeColor(UIColor.clear.cgColor)
            ctx.cgContext.setFillColor(color)
            
            ctx.cgContext.addEllipse(in: rect)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        return img
    }
    
    private func drawTriangle(color: CGColor, size: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: LARGE_SIZE, height: LARGE_SIZE))
        
        let img = renderer.image { ctx in
            let top = (LARGE_SIZE / 2)
            ctx.cgContext.beginPath()
            ctx.cgContext.move(to: CGPoint(x: top, y: top - (size / 3)))
            ctx.cgContext.addLine(to: CGPoint(x: top + size / 2.5, y: top + size / 3))
            ctx.cgContext.addLine(to: CGPoint(x: top - size / 2.5, y: top + size / 3))
            ctx.cgContext.closePath()
            ctx.cgContext.setFillColor(color)
            ctx.cgContext.fillPath()
        }
        
        return img
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

extension ComprehensionTaskViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath) as! ComprehensionCollectionViewCell
        if item.isSelected {
            print("deselect cell")
            item.colorView.backgroundColor = UIColor.white
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            print("Select cell")
            item.colorView.backgroundColor = UIColor.red
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            return true
        }

        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("didSelectItemAt")
//        let cell = collectionView.cellForItem(at: indexPath) as! ComprehensionCollectionViewCell
//
//        if (cell.isSelected) {
//            cell.layer.borderColor = UIColor.red.cgColor
//            cell.layer.borderWidth = 3
//        } else {
//            cell.layer.borderColor = UIColor.black.cgColor
//            cell.layer.borderWidth = 1
//        }
//    }
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
