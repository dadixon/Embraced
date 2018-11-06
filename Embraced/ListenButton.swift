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
        self.setImage(UIImage(named: "speaker"), for: .normal)
//        self.setTitle("Listen", for: .normal)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 150,left: -40,bottom: 0,right: 0)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 25, bottom: 0, right: 0)
        self.setTitleColor(UIColor.black, for: .normal)
    }

}
