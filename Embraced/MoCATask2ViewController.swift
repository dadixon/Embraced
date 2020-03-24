//
//  MoCATask2ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/24/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import UIKit
import Eureka

class MoCATask2ViewController: FormViewController {

    let userDefaults = UserDefaults.standard
    var language = String()
    var dataModel = MoCAModel.shared
    
    struct FormItems {
        static let country = "country"
        static let county = "county"
        static let city = "city"
        static let location = "location"
        static let floor = "floor"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Current Location"
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(moveOn)), animated: true)
        
        language = userDefaults.string(forKey: "language")!
        
        form
            +++ Section("What country are you in?")
                <<< TextRow(FormItems.country){ row in
                    row.title = "Country"
                    row.placeholder = "Enter country here"
                }
            +++ Section("What county are you in?")
                <<< TextRow(FormItems.county){ row in
                    row.title = "County"
                    row.placeholder = "Enter county here"
                }
            +++ Section("What city or town are you in?")
                <<< TextRow(FormItems.city){ row in
                    row.title = "City"
                    row.placeholder = "Enter city or town here"
                }
            +++ Section("What type of site or location are you in?")
                <<< TextRow(FormItems.location){ row in
                    row.title = "Location"
                    row.placeholder = "Enter location here"
                }
            +++ Section("What floor are you on?")
                <<< TextRow(FormItems.floor){ row in
                    row.title = "Floor"
                    row.placeholder = "Enter floor here"
                }
    }
    
    @objc func moveOn() {
        print(form.values())
        // Save data
        
        
        
        
//        let vc = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "startTest") as? StartViewController)!
//        let nvc = UINavigationController(rootViewController: vc)
//
//        self.present(nvc, animated: true) {
//
//        }
    }

}
