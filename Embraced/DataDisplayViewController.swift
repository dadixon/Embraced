//
//  DataDisplayViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/24/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class DataDisplayViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    
    var participant: Participant? {
        didSet {
            refreshUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func refreshUI() {
        loadViewIfNeeded()
        dataLabel.text = participant?.id
    }
}
