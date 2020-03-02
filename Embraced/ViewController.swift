//
//  ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class ViewController: UIViewController {
 
    @IBOutlet weak var usernameTextfield: EmbracedTextField!
    @IBOutlet weak var passwordTextfield: EmbracedTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    let userDefaults = UserDefaults.standard
    var testerLanguage = ""
    var user: User!
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let _ = user  {
                self.performSegue(withIdentifier: "moveToHome", sender: nil)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        usernameTextfield.delegate = self
        
        if let language = userDefaults.string(forKey: "TesterLanguage") {
            testerLanguage = language
        } else {
            testerLanguage = "en"
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func login(_ sender: AnyObject) {        
        if ((usernameTextfield.text?.isEmpty)! || (passwordTextfield.text?.isEmpty)!) {
            SVProgressHUD.showError(withStatus: "UsernamePasswordEmpty".localized(lang: testerLanguage))
            return
        }

        let email = self.usernameTextfield.text!
        let password = self.passwordTextfield.text!

        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            } else {
                
                self.performSegue(withIdentifier: "moveToHome", sender: nil)
            }
        })
        
        self.usernameTextfield.text = ""
        self.passwordTextfield.text = ""
    }
}

extension ViewController: UITextFieldDelegate {
    private func AnimateHeight() {
        UIView.animate(withDuration: 1.0, animations: {
            self.imageHeight.constant = 150
            self.view.layoutIfNeeded()
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        AnimateHeight()
    }
}
