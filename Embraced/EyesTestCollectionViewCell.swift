//
//  EyesTestCollectionViewCell.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/12/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class EyesTestCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var infoTitle: String!
    var infoText: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 5.0
    }
}
