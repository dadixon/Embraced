//
//  LabelTableViewCell.swift
//  Embraced
//
//  Created by Domonique Dixon on 2/25/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    let answerLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupView() {
        self.addSubview(answerLabel)
        
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16.0),
            answerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16.0),
            answerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16.0),
            answerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16.0)
        ])
    }
}
