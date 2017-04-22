//
//  APIWrapper.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/13/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import Foundation
import Stormpath


public class APIWrapper {
    class func post(id: String, test: String, data: Any) {
        var notesEndpoint : URL!
        
        if id == "" && test == "" {
            notesEndpoint = URL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/participant")!
        } else if id != "" && test == "" {
            notesEndpoint = URL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/participant/" + id)!
        } else if id != "" && test != "" {
            notesEndpoint = URL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/participant/" + id + "/" + test)!
        }
        
        let request = NSMutableURLRequest(url: notesEndpoint)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        
        task.resume()
    }
    
    class func post2(id: String, test: String, data: Any, callback: Any) {
        let todoEndpoint: String = "http://api.girlscouts.harryatwal.com/participant/v2/" + id + "/" + test
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: callback as! (Data?, URLResponse?, Error?) -> Void)
        task.resume()
    }
}
