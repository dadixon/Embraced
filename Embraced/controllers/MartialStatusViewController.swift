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
    
    var postValues = [String](repeating: "", count: 10)
    let prefs = UserDefaults.standard
    
    var pickOption = ["Male", "Female"]
    var ages = [String]()
    var sexes = [String]()
    
    let textCellIdentifier = "ChildTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        progressView.progress = progress
//        progressLabel.text = "Progress (\(step)/17)"
//        
//        marriedMonths.hidden = true
//        marriedYears.hidden = true
//        livingMonths.hidden = true
//        livingYears.hidden = true
//        separateMonths.hidden = true
//        separateYears.hidden = true
//        childrenView.hidden = true
//        
//        childTableView.delegate = self
//        childTableView.dataSource = self
//        childTableView.tableFooterView = UIView()
//        
//        let pickerView = UIPickerView()
//        
//        pickerView.delegate = self
//        
//        genderTextField.inputView = pickerView
//        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.Default
//        toolBar.translucent = true
//        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(QuestionnaireViewController.donePicker))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        
//        toolBar.setItems([spaceButton, doneButton], animated: false)
//        toolBar.userInteractionEnabled = true
//        
//        genderTextField.inputView = pickerView
//        genderTextField.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePicker(_ sender: UIPickerView) {
        genderTextField.resignFirstResponder()
    }
    
    // MARK: - Navigation

    @IBAction func back(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: AnyObject) {
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

        
    }
    
    @IBAction func changeStatus(_ sender: AnyObject) {
        switch sender.tag {
        case 0, 3:
            marriedMonths.isHidden = true
            marriedYears.isHidden = true
            livingMonths.isHidden = true
            livingYears.isHidden = true
            separateMonths.isHidden = true
            separateYears.isHidden = true
        case 1:
            marriedMonths.isHidden = false
            marriedYears.isHidden = false
            livingMonths.isHidden = true
            livingYears.isHidden = true
            separateMonths.isHidden = true
            separateYears.isHidden = true
        case 2:
            marriedMonths.isHidden = true
            marriedYears.isHidden = true
            livingMonths.isHidden = false
            livingYears.isHidden = false
            separateMonths.isHidden = true
            separateYears.isHidden = true
        case 4:
            marriedMonths.isHidden = true
            marriedYears.isHidden = true
            livingMonths.isHidden = true
            livingYears.isHidden = true
            separateMonths.isHidden = false
            separateYears.isHidden = false
        default:
            marriedMonths.isHidden = true
            marriedYears.isHidden = true
            livingMonths.isHidden = true
            livingYears.isHidden = true
            separateMonths.isHidden = true
            separateYears.isHidden = true
        }
    }
    
    @IBAction func haveChildren(_ sender: AnyObject) {
        if (sender.selectedSegmentIndex == 0) {
            childrenView.isHidden = false
        } else if (sender.selectedSegmentIndex == 1) {
            childrenView.isHidden = true
            ages.removeAll()
            sexes.removeAll()
            childTableView.reloadData()
            ageTextField.text = ""
            genderTextField.text = ""
        }
    }
    
    @IBAction func addChild(_ sender: AnyObject) {
        ages.append(ageTextField.text!)
        sexes.append(genderTextField.text!)
        
        childTableView.reloadData()
        
        ageTextField.text = ""
        genderTextField.text = ""
    }
    
    
    // MARK: Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! ChildTableViewCell
        
        let row = (indexPath as NSIndexPath).row
        cell.ageLabel?.text = String(ages[row])
        cell.sexLabel?.text = sexes[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = (indexPath as NSIndexPath).row
        print(ages[row])
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = pickOption[row]
    }
}
