//
//  RecordButton.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class RecordButton: UIButton {

    private let _recordImage = "record2"
    private let _stopImage = "stop"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        setImage(UIImage(named: _recordImage), for: .normal)
        contentMode = .scaleToFill
    }
    
    func btnStop() {
        setImage(UIImage(named: _stopImage), for: .normal)
    }
    
    func btnRecord() {
        setImage(UIImage(named: _recordImage), for: .normal)
    }
}
