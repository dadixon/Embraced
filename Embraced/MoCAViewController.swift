//
//  MoCAViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/24/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit
import Eureka

class MoCAViewController: FormViewController {

    let userDefaults = UserDefaults.standard
        var language = String()
        
        struct FormItems {
            static let year = "year"
            static let month = "month"
            static let day = "day"
            static let dayweek = "dayweek"
            static let hour = "hour"
            static let minutes = "minutes"
            static let ampm = "ampm"
            static let country = "country"
            static let county = "county"
            static let city = "city"
            static let location = "location"
            static let floor = "floor"
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = "MoCA"
            self.navigationController?.isNavigationBarHidden = false
            navigationItem.hidesBackButton = true
            navigationItem.setRightBarButton(UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(moveOn)), animated: true)
            
            language = userDefaults.string(forKey: "language")!
            
            form +++ Section("")
                <<< DateRow("date"){ row in
                    row.title = "Today's Date"
                }
                <<< TextRow(FormItems.country){ row in
                    row.title = "Country"
                    row.placeholder = "Enter text here"
                }
                <<< TextRow(FormItems.county){ row in
                    row.title = "County"
                    row.placeholder = "Enter text here"
                }
                <<< TextRow(FormItems.city){ row in
                    row.title = "City"
                    row.placeholder = "Enter text here"
                }
                <<< TextRow(FormItems.location){ row in
                    row.title = "Location"
                    row.placeholder = "Enter text here"
                }
                <<< TextRow(FormItems.floor){ row in
                    row.title = "Floor"
                    row.placeholder = "Enter text here"
                }
        }
        
        @objc func moveOn() {
            print(form.values())
            // Save data
            
            
            let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startTest") as? StartViewController)!
            let nvc = UINavigationController(rootViewController: vc)
                    
            self.present(nvc, animated: true) {
                
            }
    //        self.navigationController?.pushViewController(vc, animated: true)
        }

}
