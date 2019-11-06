//
//  MotorTapView.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class MotorTapView: UIView {

    let indexLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(indexLabel)
        
        indexLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        indexLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        indexLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        indexLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        backgroundColor = UIColor.green
        layer.borderWidth = 2
        indexLabel.isHidden = true
    }
}
