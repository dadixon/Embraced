//
//  NavigationButton.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/4/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class NavigationButton: UIButton {

    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    private func layoutRoundRectLayer() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 10.0
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        self.backgroundColor = UIColor.appleBlue
    }

}
