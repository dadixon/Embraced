//
//  InstructionsStep.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/24/18.
//  Copyright © 2018 Domonique Dixon. All rights reserved.
//

import UIKit

class InstructionsStep: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var text: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
