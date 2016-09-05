//
//  UserInputViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/8/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Stormpath
import CoreData

class UserInputViewController: UIViewController {


    @IBOutlet weak var participantID: UILabel!
    @IBOutlet weak var dayOfTheWeekTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
//    var userInputs = [NSManagedObject]()
    let participant = NSUserDefaults.standardUserDefaults()
    
    private func setBottomBorder(textfield: UITextField) {
        let border = CALayer()
        let width = CGFloat(2.0)
        let borderColor = UIColor.darkGrayColor().CGColor
        
        border.borderColor = borderColor
        border.borderWidth = width
        border.frame = CGRect(x: 0, y: textfield.frame.size.height, width:  textfield.frame.size.width, height: 1)
        
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        Stormpath.sharedSession.me { (account, error) -> Void in
            if let account = account {
                print("Hello \(account.fullName)!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitBtn.backgroundColor = UIColor(red: 23.0/225.0, green: 145.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        let uuid = NSUUID().UUIDString
        let index = uuid.endIndex.advancedBy(-28)
        participantID.text = uuid.substringToIndex(index)
        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        let fetchRequest = NSFetchRequest(entityName: "UserInputs")
//
//        do {
//            let results =
//                try managedContext.executeFetchRequest(fetchRequest)
//                    userInputs = results as! [NSManagedObject]
//                    print(userInputs)
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func submit(sender: AnyObject) {
//        self.saveUserInputs()
        participant.setValue(participantID.text, forKey: "pid")
        participant.setValue(dayOfTheWeekTextField.text, forKey: "dayOfTheWeek")
        participant.setValue(countryTextField.text, forKey: "country")
        participant.setValue(countyTextField.text, forKey: "county")
        participant.setValue(cityTextField.text, forKey: "city")
        participant.setValue(locationTextField.text, forKey: "location")
        participant.setValue(floorTextField.text, forKey: "floor")
        
//        let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("QuestionnaireViewController") as! QuestionnaireViewController
        let mOCAMMSETestViewController:MOCAMMSETestViewController = MOCAMMSETestViewController()
        let navController = UINavigationController(rootViewController: mOCAMMSETestViewController)
        self.presentViewController(navController, animated: true, completion: nil)
        
        
    }
    
//    func saveUserInputs() {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        let entity =  NSEntityDescription.entityForName("UserInputs", inManagedObjectContext:managedContext)
//        let userInput = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
//        
//        userInput.setValue(dayOfTheWeekTextField.text, forKey: "day")
//        userInput.setValue(countryTextField.text, forKey: "country")
//        userInput.setValue(countyTextField.text, forKey: "county")
//        userInput.setValue(cityTextField.text, forKey: "city")
//        userInput.setValue(locationTextField.text, forKey: "location")
//        userInput.setValue(floorTextField.text, forKey: "floor")
//        
//        do {
//            try managedContext.save()
//            userInputs.append(userInput)
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//    }

}
