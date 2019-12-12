//
//  EyesTestCollectionViewCell.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/12/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class EyesTestCollectionViewCell: UICollectionViewCell {

    weak var titleLabel: UILabel!
    weak var infoButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = nil
    }
    
    func setupView() {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        let infoButton = UIButton(type: .infoDark)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(infoButton)
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: infoButton.leftAnchor, constant: -12).isActive = true
        
        infoButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        infoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        infoButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        self.titleLabel = titleLabel
        self.infoButton = infoButton
    }
}
