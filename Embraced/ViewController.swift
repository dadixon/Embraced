//
//  ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 5/28/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Alamofire
import JWTDecode
import Reachability
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

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func login(_ sender: AnyObject) {        
        if ((usernameTextfield.text?.isEmpty)! || (passwordTextfield.text?.isEmpty)!) {
            self.errorLabel.text = "UsernamePasswordEmpty".localized(lang: testerLanguage)
            return
        }
        
        let parameters = createPostObject()
        let url = Constants.API_ENDPOINT + "api/user/authenticate"
        
        let email = "drocdix7@gmail.com"
        let password = "dadixon"
        
        Auth.auth().signIn(withEmail: email,
                           password: password,
                           completion: { (user, error) in
        })
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in

                let statusCode = response.response?.statusCode

                if statusCode == 200 {
                    guard let json = response.result.value as? [String: Any] else {
                        return
                    }

                    self.userDefaults.setValue(json["token"]!, forKey: "token")
                    self.userDefaults.setValue(json["id"]!, forKey: "id")

                    do {
                        let jwt = try decode(jwt: json["token"] as! String)

                        print(jwt.body)
                        self.userDefaults.setValue(jwt.body["admin"], forKey: "isAdmin")
                    } catch {
                        print("Cannot decode")
                    }

                    DispatchQueue.main.async(execute: {
                        self.usernameTextfield.text = ""
                        self.passwordTextfield.text = ""

                        let vc = AdminViewController()
                        let navController = UINavigationController(rootViewController: vc)
                        self.present(navController, animated: true, completion: nil)
                    })
                } else if statusCode == 403 {
                    DispatchQueue.main.async(execute: {
                        self.errorLabel.text = "WrongUsernamePassword".localized(lang: self.testerLanguage)
                    })
                }
        }
        
//        self.usernameTextfield.text = ""
//        self.passwordTextfield.text = ""
//
//        let vc = AdminViewController()
//        let navController = UINavigationController(rootViewController: vc)
//        self.present(navController, animated: true, completion: nil)
    }
    
    private func createPostObject() -> [String: AnyObject] {
        var jsonObject = [String: AnyObject]()
        
        // Gather data for post
        jsonObject = [
            "username": usernameTextfield.text as AnyObject,
            "password": passwordTextfield.text as AnyObject
        ]
        
        return jsonObject
    }
    
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
