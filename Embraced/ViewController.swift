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
//        let todoEndpoint: String = "http://api.girlscouts.harryatwal.com/authenticate/"
//        guard let url = URL(string: todoEndpoint) else {
//            print("Error: cannot create URL")
//            return
//        }
//        
//        let request = NSMutableURLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        let postString = "name=" + usernameTextfield.text! + "&password=" + passwordTextfield.text!
//        request.httpBody = postString.data(using:String.Encoding.ascii, allowLossyConversion: false)
//        
//        let session = URLSession.shared
//        let myCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
//            (data, response, error) in
//            // this is where the completion handler code goes
//            if let response = response {
//                print(response)
//            }
//            
//            if let error = error {
//                print(error)
//            }
//            
//            let httpResponse = response as! HTTPURLResponse
//            let statusCode = httpResponse.statusCode
//            
//            guard let responseData = data else {
//                return
//            }
//            
//            if (statusCode == 200) {
//                
//                do {
//                    guard let success = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
//                        return
//                    }
//                    self.participant.setValue(success["token"], forKey: "token")
//                    print(self.participant.string(forKey: "token")!)
//                    
//                    DispatchQueue.main.async() {
//                        let vc = AdminViewController()
//                        let navController = UINavigationController(rootViewController: vc)
//                        self.present(navController, animated: true, completion: nil)
//                    }
//
//                } catch {
//                    return
//                }
//            } else if (statusCode == 403) {
//                print("Username and password is incorrect")
//            }
//        }
//        
//        let task = session.dataTask(with: request as URLRequest, completionHandler: myCompletionHandler)
//        task.resume()
        
        let vc = AdminViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    func showModal() {
        var modalViewController = UIViewController()
        
        if #available(iOS 10.0, *) {
            modalViewController = SpeechTestViewController()
        } else {
            // Fallback on earlier versions
            modalViewController = UserInputViewController()
        }
        
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
    
    func logResponse(_ success: Bool, error: NSError?) {
        if let error = error {
//            showAlert(withTitle: "Error", message: error.localizedDescription)
            self.errorLabel.text = error.localizedDescription
        }
        else {
//            showAlert(withTitle: "Success", message: "You logged in successfully")
            
//            Stormpath.sharedSession.me { (account, error) -> Void in
//                if let account = account {
//                    self.errorLabel.text = "Hello \(account.fullName)!"
//                }
//            }
//            
//            let notesEndpoint = URL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/secret")!
//            let request = NSMutableURLRequest(url: notesEndpoint)
//            request.setValue("Bearer \(Stormpath.sharedSession.accessToken!)", forHTTPHeaderField: "Authorization")
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
//                guard let data = data, json = try? NSJSONSerialization.JSONObjectWithData(data, options: []), notes = json["notes"] as? String else {
//                    return
//                }
//                dispatch_async(dispatch_get_main_queue(), {
////                    self.notesTextView.text = notes
//                    
//                })
//            }
//            task.resume()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let secondViewController = storyBoard.instantiateViewController(withIdentifier: "UserInputViewController") as! UserInputViewController
            let navController = UINavigationController(rootViewController: secondViewController)
            self.present(navController, animated: true, completion: nil)
        }
    }

}
