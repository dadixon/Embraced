//
//  ListenButton.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ListenButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBorder()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        createBorder()
    }
    
    func createBorder() {
        self.setImage(UIImage(named: "speaker.png"), for: .normal)
//        self.setTitle("Listen", for: .normal)
        self.titleEdgeInsets = UIEdgeInsetsMake(150,-40,0,0)
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0)
        self.setTitleColor(UIColor.black, for: .normal)
    }

}
