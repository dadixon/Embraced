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
    var navigationTests = [UIViewController!]()
    
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
                
                let alertController = UIAlertController(title: "Participant_ID".localized(lang: self.language), message: self.userDefaults.string(forKey: "pid"), preferredStyle: UIAlertControllerStyle.alert)
                
                self.present(alertController, animated: true, completion: nil)
                
                let dismissAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    alertController.dismiss(animated: true, completion: nil)
                    
                    if self.tests.contains(where: { String($0) == "Orientation Task"}) {
//                        self.navigationTests.insert(UserInputViewController(), at: 0)
                        TestOrder.sharedInstance.addTest(viewController: UserInputViewController(), at: 0)
                        TestOrder.sharedInstance.addTest(viewController: StartViewController(), at: 1)
                    } else {
//                        self.navigationTests.insert(StartViewController(), at: 0)
                        TestOrder.sharedInstance.addTest(viewController: StartViewController(), at: 0)
                    }
                    
                    
                    let navController = UINavigationController(rootViewController: TestOrder.sharedInstance.getTest(0))
//                    navController.setViewControllers(TestOrder.sharedInstance.getTests().reversed(), animated: true)
                    self.present(navController, animated: true, completion: nil)
                }
                
                alertController.addAction(dismissAction)
            }
        }
    }
    
    private func createTestViewControllers() -> [UIViewController] {
        var tests = [String]()
        
        if let test = userDefaults.array(forKey: "Tests") {
            tests = test as! [String]
        }
        
        userDefaults.set(tests, forKey: "Tests")
        
        navigationTests.append(LoadingScreenViewController())
        
        for test in tests {
            switch test {
            case "Questionnaire":
                navigationTests.append(QuestionnaireViewController())
            case "Orientation Task":
                navigationTests.append(MOCAMMSETestViewController())
            case "Complex Figure 1":
                navigationTests.append(ReyComplexFigureViewController())
            case "Clock Drawing Test":
                navigationTests.append(ClockDrawingTestViewController())
            case "Complex Figure 2":
                navigationTests.append(ReyComplexFigure2ViewController())
            case "Trail Making Test":
                navigationTests.append(TrailMakingTestViewController())
            case "Melodies Recognition":
                navigationTests.append(PitchViewController())
            case "Digit Span":
                navigationTests.append(DigitalSpanViewController())
            case "Complex Figure 3":
                navigationTests.append(ReyComplexFigure3ViewController())
            case "Complex Figure 4":
                navigationTests.append(ReyFigureComplex4ViewController())
            case "Matrices":
                navigationTests.append(MatricesViewController())
            case "Continuous Performance Test":
                navigationTests.append(CPTViewController())
            case "Motor Tasks":
                navigationTests.append(PegboardViewController())
            case "Word List 1":
                navigationTests.append(WordListViewController())
            case "Color-Word Stroop Test":
                navigationTests.append(StroopViewController())
            case "Cancellation Test":
                navigationTests.append(CancellationTestViewController())
            case "Word List 2":
                navigationTests.append(WordList2ViewController())
            case "Naming Test":
                navigationTests.append(NamingTaskViewController())
            case "Comprehension Task":
                navigationTests.append(ComprehensionViewController())
            case "Eyes Test":
                navigationTests.append(EyeTestViewController())
            default:
                navigationTests.append(UserInputViewController())
            }
        }
        
        navigationTests.append(FinishedViewController())
        
        return navigationTests
    }
}
