//
//  SideMenuViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/13/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import Firebase

class SideMenuViewController: UITableViewController {

    let sideMenuItems = ["Select Test", "Participants", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                print(user.uid)
                
                FirebaseStorageManager.shared.getUserProperties(uid: user.uid) { (results, error) in
                    self.title = results["first_name"] as? String
                }
            }
        } else {
            print("Not signed in")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath)
        cell.textLabel?.text = sideMenuItems[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sideMenuItems[indexPath.row] {
        case "Select Test":
            self.performSegue(withIdentifier: "showTests", sender: self)
        case "Participants":
            self.performSegue(withIdentifier: "showAdmin", sender: self)
        case "Settings":
            self.performSegue(withIdentifier: "showSettings", sender: self)
        default:
            return
        }
    }

}
