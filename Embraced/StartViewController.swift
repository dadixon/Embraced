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
    
    let participant = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Embraced_bg.png")!)
        self.navigationController?.isNavigationBarHidden = true
        
        let welcomeLabelText = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: "en")
        welcomeLabel.text = welcomeLabelText
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
                
        let welcomeLabelText = "WELCOME_TO_EMBRACED_PROJECT".localized(lang: participant.string(forKey: "language")!)
        welcomeLabel.text = welcomeLabelText
        
        var navigationArray = self.navigationController?.viewControllers
        
        navigationArray?.remove(at: 0)
        
        let vc: UIViewController!
        let test = participant.array(forKey: "Tests")!
        
        print(test)
        
        switch test[0] as! String {
        case "Questionnaire":
            vc = QuestionnaireViewController()
        case "MOCA":
            vc = MOCAMMSETestViewController()
        case "RCF1":
            vc = ReyComplexFigureViewController()
        case "ClockDrawing":
            vc = ClockDrawingTestViewController()
        case "RCF2":
            vc = ReyComplexFigure2ViewController()
        case "TrailMaking":
            vc = TrailMakingTestViewController()
        case "Pitch":
            vc = PitchViewController()
        case "DigitalSpan":
            vc = DigitalSpanViewController()
        case "RCF3":
            vc = ReyComplexFigure3ViewController()
        case "RCF4":
            vc = ReyFigureComplex4ViewController()
        case "CPT":
            vc = CPTViewController()
        case "Matrices":
            vc = MatricesViewController()
        case "Pegboard":
            vc = PegboardViewController()
        case "WordList1":
            vc = WordListViewController()
        case "Stroop":
            vc = StroopViewController()
        case "Cancellation":
            vc = CancellationTestViewController()
        case "WordList2":
            vc = WordList2ViewController()
        case "NamingTask":
            vc = NamingTaskViewController()
        case "Comprehension":
            vc = ComprehensionViewController()
        case "EyeTest":
            vc = EyeTestViewController()
        default:
            vc = UserInputViewController()
        }
        
//        let vc = QuestionnaireViewController()
//        let vc = PitchViewController()
        navigationArray?.append(vc)
        
        self.navigationController?.setViewControllers(navigationArray!, animated: true)

    }
    
 
    
    

}
