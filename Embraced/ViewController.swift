//
//  ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var usernameTextfield: EmbracedTextField!
    @IBOutlet weak var passwordTextfield: EmbracedTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    let participant = UserDefaults.standard
    var testerLanguage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Embraced_bg.png")!)
        
        if let language = participant.string(forKey: "TesterLanguage") {
            testerLanguage = language
        } else {
            testerLanguage = "en"
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func login(_ sender: AnyObject) {
        // Test users
        
        let vc = AdminViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
//    func showModal() {
//        var modalViewController = UIViewController()
//        
//        if #available(iOS 10.0, *) {
//            modalViewController = SpeechTestViewController()
//        } else {
//            // Fallback on earlier versions
//            modalViewController = UserInputViewController()
//        }
//        
//        modalViewController.modalPresentationStyle = .overCurrentContext
//        present(modalViewController, animated: true, completion: nil)
//    }
    
    func logResponse(_ success: Bool, error: NSError?) {
        if let error = error {
//            showAlert(withTitle: "Error", message: error.localizedDescription)
            self.errorLabel.text = error.localizedDescription
        }
        else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let secondViewController = storyBoard.instantiateViewController(withIdentifier: "UserInputViewController") as! UserInputViewController
            let navController = UINavigationController(rootViewController: secondViewController)
            self.present(navController, animated: true, completion: nil)
        }
    }

}
