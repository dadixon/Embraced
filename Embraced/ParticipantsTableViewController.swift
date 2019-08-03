//
//  ParticipantsTableViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/23/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit
import Firebase

protocol ParticipantDelegate: class {
    func participantSelected(_ newParticipant: Participant)
}

class ParticipantsTableViewController: UITableViewController {

    var participants: [Participant]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                print(user.uid)
                
                let db = Firestore.firestore()
                
                db.collection("participants").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let participant = Participant(id: document.documentID, data: document.data())
                            ParticipantDTO.shared.data.append(participant)
                        }
                        
                        self.participants = ParticipantDTO.shared.data
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            print("Not signed in")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let parts = participants {
            return parts.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        
        if let parts = participants {
            cell.textLabel?.text = parts[indexPath.row].id
        }
        
        return cell
    }

}
