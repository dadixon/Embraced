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
    var language = String()
    var tests = [String]()
    var navigationTests = [UIViewController]()
    
    override func viewWillAppear(_ animated: Bool) {
        if let language = userDefaults.string(forKey: "TesterLanguage") {
            startBtn.setTitle("Start_Test".localized(lang: language), for: .normal)
            self.language = language
        } else {
            startBtn.setTitle("Start Test", for: .normal)
        }
        
        if userDefaults.array(forKey: "Tests") != nil {
            self.tests = userDefaults.array(forKey: "Tests") as! [String]
        }
        
        TestOrder.sharedInstance.clearTests()
        TestOrder.sharedInstance.setTests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TestOrder.sharedInstance.setTests()
    }

    @IBAction func startTest(_ sender: Any) {
        // Add a participant
        let token = userDefaults.string(forKey: "token")!
        let uid = userDefaults.string(forKey: "id")!
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]

        Alamofire.request(APIUrl + "api/participant/" + uid, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            let statusCode = response.response?.statusCode

            if statusCode == 200 {
                guard let json = response.result.value as? [String: Any] else {
                    return
                }
                self.userDefaults.setValue(json["_id"]!, forKey: "pid")

                FirebaseStorageManager.shared.pid = self.userDefaults.string(forKey: "pid")!
                FirebaseStorageManager.shared.createParticipantDocument()

                let alertController = UIAlertController(title: "Participant_ID".localized(lang: self.language), message: self.userDefaults.string(forKey: "pid"), preferredStyle: UIAlertController.Style.alert)

                self.present(alertController, animated: true, completion: nil)

                let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    alertController.dismiss(animated: true, completion: nil)

                    if self.tests.contains(where: { String($0) == "Orientation Task"}) {
                        TestOrder.sharedInstance.addTest(viewController: UserInputViewController(), at: 0)
                        TestOrder.sharedInstance.addTest(viewController: StartViewController(), at: 1)
                    } else {
                        TestOrder.sharedInstance.addTest(viewController: StartViewController(), at: 0)
                    }


                    let navController = UINavigationController(rootViewController: TestOrder.sharedInstance.getTest(0))

                    self.present(navController, animated: true, completion: nil)
                }

                alertController.addAction(dismissAction)
            }
        }
        
//        self.userDefaults.setValue("testing", forKey: "pid")
//
//        FirebaseStorageManager.shared.pid = self.userDefaults.string(forKey: "pid")!
//        FirebaseStorageManager.shared.createParticipantDocument()
//
//        let alertController = UIAlertController(title: "Participant_ID".localized(lang: self.language), message: self.userDefaults.string(forKey: "pid"), preferredStyle: UIAlertController.Style.alert)
//
//        self.present(alertController, animated: true, completion: nil)
//
//        let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
//            alertController.dismiss(animated: true, completion: nil)
//
//            if self.tests.contains(where: { String($0) == "Orientation Task"}) {
//                TestOrder.sharedInstance.addTest(viewController: UserInputViewController(), at: 0)
//                TestOrder.sharedInstance.addTest(viewController: StartViewController(), at: 1)
//            } else {
//                TestOrder.sharedInstance.addTest(viewController: StartViewController(), at: 0)
//            }
//
//            let navController = UINavigationController(rootViewController: TestOrder.sharedInstance.getTest(0))
//
//            self.present(navController, animated: true, completion: nil)
//        }
//
//        alertController.addAction(dismissAction)
    }
}
