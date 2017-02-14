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
        
        let welcomeLabelText = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "TesterLanguage")!)
        let welcomeTextText = "WELCOME_TEXT".localized(lang: participant.string(forKey: "TesterLanguage")!)
        
        welcomeLabel.text = welcomeLabelText
        welcomeText.text = welcomeTextText
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
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let vc: UIViewController!
        let test = participant.array(forKey: "Tests")!
        
        print(test)
        
        switch test[0] as! String {
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
        case "Continuous Performance Test":
            vc = CPTViewController()
        case "Matrices":
            vc = MatricesViewController()
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
