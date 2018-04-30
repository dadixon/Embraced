//
//  StorageManager.swift
//  Embraced
//
//  Created by Domonique Dixon on 4/30/18.
//  Copyright © 2018 Domonique Dixon. All rights reserved.
//

import Foundation
import Alamofire

enum StorageManagerError: Error {
    case failure(message: String)
}

class StorageManager {
    static let sharedInstance = StorageManager()
    private let APIURL = "http://www.embracedapi.ugr.es/"
    private var headers = [String : String]()
    var token : String = "" {
        willSet(newToken) {
            headers = [
                "x-access-token": newToken
            ]
        }
    }
    
    private let namingTaskEndpoint = "api/naming_task"
    
    private init() {}
    
    public func newNamingTask(id: String) {
        Alamofire.request(APIURL + namingTaskEndpoint + "/new/" + id, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
    }
    
    public func postToNamingTask(id: String, data: [String: AnyObject]) throws {
        let name = data["name"] as! String
        let fileURL = data["audio"] as! URL
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL, withName: "audio")
                multipartFormData.append(name.data(using: String.Encoding.utf8)!, withName: "name")
        }, usingThreshold: UInt64.init(),
           to: APIURL + namingTaskEndpoint + "/uploadfile/" + id,
           method: .post,
           headers: headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                }
            case .failure(let encodingError):
                do {
                    throw StorageManagerError.failure(message: encodingError as! String)
//                    throw NSError(domain: "howdy", code: 1, userInfo:nil)
                } catch let error as NSError {
                    print( "entrato nel catch primo \(error)")
                }
                
            }})
    }
}
