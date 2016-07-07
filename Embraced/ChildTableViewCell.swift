//
//  ChildTableViewCell.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ChildTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
