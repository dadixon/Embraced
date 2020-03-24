//
//  MoCAModel.swift
//  Embraced
//
//  Created by Domonique Dixon on 3/24/20.
//  Copyright © 2020 Domonique Dixon. All rights reserved.
//

import Foundation

class MoCAModel: TestModelProtocol {
    static let shared = MoCAModel()
    
    var date = Date()
    var realCountry: String?
    var realCounty: String?
    var realCity: String?
    var realLocation: String?
    var realFloor: String?
    
    private init() {}
    
    func getModel() -> [String : Any] {
        var rv = [String: Any]()
        let calendar = Calendar.current
        
        rv["REAL_year"] = calendar.component(.year, from: date)
        rv["REAL_month"] = calendar.component(.month, from: date)
        rv["REAL_day"] = calendar.component(.day, from: date)
        rv["REAL_dayweek"] = calendar.component(.weekday, from: date)
        rv["REAL_hour"] = calendar.component(.hour, from: date)
        rv["REAL_minutes"] = calendar.component(.minute, from: date)
        rv["REAL_AMPM"] = calendar.component(.hour, from: date) > 11 ? "pm" : "am"
        rv["REAL_country"] = realCountry
        rv["REAL_county"] = realCounty
        rv["REAL_city"] = realCity
        rv["REAL_location"] = realLocation
        rv["REAL_floor"] = realFloor
        
        return rv
    }
    
    func reset() {
        date = Date()
        realCountry = ""
        realCounty = ""
        realCity = ""
        realLocation = ""
        realFloor = ""
    }
    
    
}
