//
//  MartialStatusViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class MartialStatusViewController: FrontViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var marriedMonths: UITextField!
    @IBOutlet weak var marriedYears: UITextField!
    @IBOutlet weak var livingMonths: UITextField!
    @IBOutlet weak var livingYears: UITextField!
    @IBOutlet weak var separateMonths: UITextField!
    @IBOutlet weak var separateYears: UITextField!
    
    @IBOutlet weak var childrenView: UIView!
    
    var step = 4
    var progress : Float {
        get {
            return Float(step) / 17.0
        }
    }
    
    var postValues = [String](count: 10, repeatedValue: "")
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var pickOption = ["Male", "Female"]
    var ages = [String]()
    var sexes = [String]()
    
    let textCellIdentifier = "ChildTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = progress
        progressLabel.text = "Progress (\(step)/17)"
        
        marriedMonths.hidden = true
        marriedYears.hidden = true
        livingMonths.hidden = true
        livingYears.hidden = true
        separateMonths.hidden = true
        separateYears.hidden = true
        childrenView.hidden = true
        
        childTableView.delegate = self
        childTableView.dataSource = self
        childTableView.tableFooterView = UIView()
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        genderTextField.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(QuestionnaireViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        genderTextField.inputView = pickerView
        genderTextField.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePicker(sender: UIPickerView) {
        genderTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation

    @IBAction func back(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func next(sender: AnyObject) {
//        var jsonObject = [String: AnyObject]()
//        
//        // Gather data for post
//        if let id = prefs.stringForKey("pid") {
//            print("PID: " + id)
//            
//            jsonObject = [
//                "id": id,
//                "hand": postValues
//            ]
//        }
//
//        print(jsonObject)
        
        
        // Push to API
        //            let notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/insert_hand_dominate")!
        //            let request = NSMutableURLRequest(URL: notesEndpoint)
        //            request.HTTPMethod = "POST"
        //            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(jsonObject, options: [])
        //            request.setValue("application/json" ?? "", forHTTPHeaderField: "Content-Type")
        //
        //            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        //            task.resume()
        
        let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("CPTViewController") as! CPTViewController
        self.navigationController!.pushViewController(VC1, animated: true)
        
    }
    
    @IBAction func changeStatus(sender: AnyObject) {
        switch sender.tag {
        case 0, 3:
            marriedMonths.hidden = true
            marriedYears.hidden = true
            livingMonths.hidden = true
            livingYears.hidden = true
            separateMonths.hidden = true
            separateYears.hidden = true
        case 1:
            marriedMonths.hidden = false
            marriedYears.hidden = false
            livingMonths.hidden = true
            livingYears.hidden = true
            separateMonths.hidden = true
            separateYears.hidden = true
        case 2:
            marriedMonths.hidden = true
            marriedYears.hidden = true
            livingMonths.hidden = false
            livingYears.hidden = false
            separateMonths.hidden = true
            separateYears.hidden = true
        case 4:
            marriedMonths.hidden = true
            marriedYears.hidden = true
            livingMonths.hidden = true
            livingYears.hidden = true
            separateMonths.hidden = false
            separateYears.hidden = false
        default:
            marriedMonths.hidden = true
            marriedYears.hidden = true
            livingMonths.hidden = true
            livingYears.hidden = true
            separateMonths.hidden = true
            separateYears.hidden = true
        }
    }
    
    @IBAction func haveChildren(sender: AnyObject) {
        if (sender.selectedSegmentIndex == 0) {
            childrenView.hidden = false
        } else if (sender.selectedSegmentIndex == 1) {
            childrenView.hidden = true
            ages.removeAll()
            sexes.removeAll()
            childTableView.reloadData()
            ageTextField.text = ""
            genderTextField.text = ""
        }
    }
    
    @IBAction func addChild(sender: AnyObject) {
        ages.append(ageTextField.text!)
        sexes.append(genderTextField.text!)
        
        childTableView.reloadData()
        
        ageTextField.text = ""
        genderTextField.text = ""
    }
    
    
    // MARK: Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! ChildTableViewCell
        
        let row = indexPath.row
        cell.ageLabel?.text = String(ages[row])
        cell.sexLabel?.text = sexes[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(ages[row])
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = pickOption[row]
    }
}
