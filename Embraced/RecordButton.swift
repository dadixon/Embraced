//
//  RecordButton.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class RecordButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBorder()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        createBorder()
    }
    
    func createBorder() {
        self.setImage(UIImage(named: "record"), for: .normal)
//        self.contentMode = 
        self.setTitle("Start", for: .normal)
        self.titleEdgeInsets = UIEdgeInsetsMake(150,-100,0,0)
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0)
        self.setTitleColor(UIColor.black, for: .normal)
    }

}
