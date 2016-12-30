//
//  PlayButton.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class PlayButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBorder()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        createBorder()
    }
    
    func createBorder() {
//        self.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        self.setImage(UIImage(named: "play2.png"), for: .normal)
        self.setTitle("Play", for: .normal)
        self.titleEdgeInsets = UIEdgeInsetsMake(150,-130,0,0)
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 0)
        self.setTitleColor(UIColor.black, for: .normal)
    }

}
