//
//  DashboardViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class DashboardViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .allVisible
        preferredPrimaryColumnWidthFraction = 0.3
    }
    
//    func toggleMasterView() {
//        let barButtonItem = self.displayModeButtonItem()
//        UIApplication.sharedApplication().sendAction(barButtonItem.action, to: barButtonItem.target, from: nil, forEvent: nil)
//    }
}
