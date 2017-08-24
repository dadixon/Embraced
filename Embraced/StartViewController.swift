//
//  StartViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    let participant = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Embraced_bg.png")!)
        self.navigationController?.isNavigationBarHidden = true
        
        welcomeLabel.text = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "TesterLanguage")!)
        welcomeText.text = "WELCOME_TEXT".localized(lang: participant.string(forKey: "TesterLanguage")!)
        nextBtn.setTitle("Start".localized(lang: participant.string(forKey: "TesterLanguage")!), for: .normal)
        
        participant.setValue("en", forKey: "language")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // MARK: - Navigation
    @IBAction func chooseLanguage(_ sender: AnyObject) {
        if sender.tag == 0 {
            participant.setValue("en", forKey: "language")
        } else if sender.tag == 1 {
            participant.setValue("es", forKey: "language")
        }
        
        welcomeLabel.text = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "language")!)
        welcomeText.text = "WELCOME_TEXT".localized(lang: participant.string(forKey: "language")!)
        nextBtn.setTitle("Start".localized(lang: participant.string(forKey: "language")!), for: .normal)
    }
    
    @IBAction func startTest(_ sender: Any) {
        // Insert row in database
        let myCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
            (data, response, error) in
            // this is where the completion handler code goes
            if let response = response {
                print(response)
                print("StartViewController:startTest: Add user")
            }
            if let error = error {
                print(error)
            }
        }
        APIWrapper.post2(id: participant.string(forKey: "pid")!, test: "", data: ["lang": participant.string(forKey: "language")! as AnyObject], callback: myCompletionHandler)
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let vc: UIViewController!
        var tests = ["Questionnaire", "MoCA/MMSE", "Rey Complex Figure 1", "Clock Drawing Test", "Rey Complex Figure 2", "Trail Making", "Pitch", "Digit Span", "Rey Complex Figure 3", "Rey Complex Figure 4", "Matrices", "Continuous Performance Test", "Motor Tasks", "Word List 1", "Stroop Test", "Cancellation Test", "Word List 2", "Naming Task", "Comprehension Task", "Eye Test"]
        if let test = participant.array(forKey: "Tests") {
            tests = test as! [String]
        }
        
        participant.set(tests, forKey: "Tests")
        
        switch tests[0] {
        case "Questionnaire":
            vc = QuestionnaireViewController()
        case "MoCA/MMSE":
            vc = MOCAMMSETestViewController()
        case "Rey Complex Figure 1":
            vc = ReyComplexFigureViewController()
        case "Clock Drawing Test":
            vc = ClockDrawingTestViewController()
        case "Rey Complex Figure 2":
            vc = ReyComplexFigure2ViewController()
        case "Trail Making":
            vc = TrailMakingTestViewController()
        case "Pitch":
            vc = PitchViewController()
        case "Digit Span":
            vc = DigitalSpanViewController()
        case "Rey Complex Figure 3":
            vc = ReyComplexFigure3ViewController()
        case "Rey Complex Figure 4":
            vc = ReyFigureComplex4ViewController()
        case "Matrices":
            vc = MatricesViewController()
        case "Continuous Performance Test":
            vc = CPTViewController()
        case "Motor Tasks":
            vc = PegboardViewController()
        case "Word List 1":
            vc = WordListViewController()
        case "Stroop Test":
            vc = StroopViewController()
        case "Cancellation Test":
            vc = CancellationTestViewController()
        case "Word List 2":
            vc = WordList2ViewController()
        case "Naming Task":
            vc = NamingTaskViewController()
        case "Comprehension Task":
            vc = ComprehensionViewController()
        case "Eye Test":
            vc = EyeTestViewController()
        default:
            vc = UserInputViewController()
        }
        
        navigationArray?.append(vc)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }
 
    
    

}
