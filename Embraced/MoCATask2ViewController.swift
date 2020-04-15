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

        language = userDefaults.string(forKey: "language")!
        
        title = "moca_current_location_title".localized(lang: language)
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Next".localized(lang: language), style: .done, target: self, action: #selector(moveOn)), animated: true)
                
        form
            +++ Section("moca_country".localized(lang: language))
                <<< TextRow(FormItems.country){ row in
                    row.title = "moca_country_title".localized(lang: language)
                    row.placeholder = "enter_text".localized(lang: language)
                }
            +++ Section("moca_county".localized(lang: language))
                <<< TextRow(FormItems.county){ row in
                    row.title = "moca_county_title".localized(lang: language)
                    row.placeholder = "enter_text".localized(lang: language)
                }
            +++ Section("moca_city".localized(lang: language))
                <<< TextRow(FormItems.city){ row in
                    row.title = "moca_city_title".localized(lang: language)
                    row.placeholder = "enter_text".localized(lang: language)
                }
            +++ Section("moca_location".localized(lang: language))
                <<< TextRow(FormItems.location){ row in
                    row.title = "moca_location_title".localized(lang: language)
                    row.placeholder = "enter_text".localized(lang: language)
                }
            +++ Section("moca_floor".localized(lang: language))
                <<< TextRow(FormItems.floor){ row in
                    row.title = "moca_floor_title".localized(lang: language)
                    row.placeholder = "enter_text".localized(lang: language)
                }
    }
    
    @objc func moveOn() {
        if form.validate().count == 0 {
            let values = form.values()
        
            dataModel.date = Date()
            dataModel.userCountry = values["year"] as? String
            dataModel.userCounty = values["county"] as? String
            dataModel.userCity = values["city"] as? String
            dataModel.userLocation = values["location"] as? String
            dataModel.userFloor = values["floor"] as? String

            FirebaseStorageManager.shared.addDataToDocument(payload: ["moca": dataModel.getModel()])
        
            let vc = MoCADoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
