//
//  MatriceCollectionCell.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/8/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MatriceCollectionCell: UICollectionViewCell {
    
    weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = UIColor.red.cgColor
                layer.borderWidth = 2
            } else {
                layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("Interface Builder is not supported!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fatalError("Interface Builder is not supported!")
    }
    
    func setupView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 35.0).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 35.0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -35.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -35.0).isActive = true
        
        self.imageView = imageView
    }
}
