//
//  UserViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/27/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Alamofire

class UserViewController: UIViewController {

    @IBOutlet weak var startBtn: NavigationButton!
    
    let userDefaults = UserDefaults.standard
    let APIUrl = "http://www.embracedapi.ugr.es/"
    
    override func viewWillAppear(_ animated: Bool) {
        if let language = userDefaults.string(forKey: "TesterLanguage") {
            startBtn.setTitle("Start_Test".localized(lang: language), for: .normal)
        } else {
            startBtn.setTitle("Start Test", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startTest(_ sender: Any) {
        // Add a participant
        let token = userDefaults.string(forKey: "token")!
        let uid = userDefaults.string(forKey: "id")!
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        Alamofire.request(APIUrl + "api/participant/" + uid, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response)
            
            let statusCode = response.response?.statusCode
            
            if statusCode == 200 {
                guard let json = response.result.value as? [String: Any] else {
                    return
                }
                self.userDefaults.setValue(json["_id"]!, forKey: "pid")
                let vc: UIViewController!
                let tests = self.userDefaults.array(forKey: "Tests")!
                
                if tests.contains(where: { String($0 as! String) == "MoCA/MMSE"}) {
                    vc = UserInputViewController()
                } else {
                    vc = StartViewController()
                }
                
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
                
            }
        }
    }
}
