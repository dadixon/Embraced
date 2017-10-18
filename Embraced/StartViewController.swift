//
//  StartViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 10/30/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Alamofire

class StartViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    let participant = UserDefaults.standard
    let APIUrl = "http://www.embracedapi.ugr.es/"
    
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
        // TODO: Update participant language chosen in the db
        
        var navigationArray = self.navigationController?.viewControllers

        navigationArray?.remove(at: 0)

        let vc = LoadingScreenViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
        
    }
 
    private func createPostObject() -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "language": participant.string(forKey: "language")! as AnyObject
        ]
        
        return jsonObject
    }
    

}
