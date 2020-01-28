//
//  CPTCollectionCell.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/20/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class CPTCollectionCell: UICollectionViewCell {
    
    weak var charLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                charLabel.textColor = UIColor.red
            } else {
                charLabel.textColor = UIColor.black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fatalError("Interface Builder is not supported")
    }
    
    private func setupView() {
        let charLabel = UILabel()
        charLabel.translatesAutoresizingMaskIntoConstraints = false
        charLabel.font = UIFont.boldSystemFont(ofSize: 66.0)
        self.addSubview(charLabel)
        
        charLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        charLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.charLabel = charLabel
    }
}
