//
//  ListenButton.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ListenButton: UIButton {

    private let _playImage = "listen2"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setImage(UIImage(named: _playImage), for: .normal)
        contentMode = .scaleToFill
    }
}
