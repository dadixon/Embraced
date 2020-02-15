//
//  FirebaseStorageManager.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/21/18.
//  Copyright © 2018 Domonique Dixon. All rights reserved.
//

import Foundation
import SVProgressHUD
import FirebaseFirestore
import FirebaseStorage

let collectionName = "participants"

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    private let db = Firestore.firestore()
    var pid: String?
    var listener: ListenerRegistration?
    
    private init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    private func getId() -> String {
        if pid == nil {
            pid = db.collection(collectionName).document().documentID
        }
        return pid!
    }
    
    func createParticipantDocument() {
        let id = getId()
        let startPayload = [
            "created": FieldValue.serverTimestamp(),
            "author": "Dom"
            ] as [String : Any]
        
        db.collection(collectionName).document(id).setData(startPayload) { (err) in
            if let err = err {
                print("Error: \(err)")
                SVProgressHUD.showError(withStatus: "test is throwing an error")
            }
        }
    }
    
    func addDataToDocument(payload: [String: Any]) {
        if let id = pid {
            let participantRef = db.collection(collectionName).document(id)
            participantRef.updateData(payload) { (err) in
                if let err = err {
                    print("Error: \(err)")
                    SVProgressHUD.showError(withStatus: "test is throwing an error")
                }
            }
        } else {
            SVProgressHUD.showError(withStatus: "There is no ID for the participant.")
        }
    }
    
    func addFileToStorage(fileName: String, path: URL, test: String, labelName: String) {
        if let id = pid {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let participantRef = storageRef.child("\(id)/\(test)/\(fileName)")
            
            participantRef.putFile(from: path, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error: \(error?.localizedDescription)")
                }

                participantRef.downloadURL { (url, error) in
                    if error != nil {
                        print("Error: \(error?.localizedDescription)")
                    }
                    guard let downloadURL = url else { return }
                
                    self.addDataToDocument(payload: ["\(test).\(labelName)": downloadURL.absoluteString])
                }
                
            }
        } else {
            SVProgressHUD.showError(withStatus: "There is no ID for the participant.")
        }
    }
    
    func fetchDocuments(completionHandler: @escaping (_ result: [String: Any], _ error: Error?) -> Void) {
        listener = db.collection("participants").document("testing")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                completionHandler(data, error)
        }
    }
    
    func getUserProperties(uid: String, completionHandler: @escaping (_ result: [String: Any], _ error: Error?) -> Void) {
        db.collection("administrators").whereField("loginId", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                for document in querySnapshot!.documents {
                    completionHandler(document.data(), err)
                }
        }
    }
    
    func getFile(fileName: String, test: String, lang: String, completionHandler: @escaping (Double, Error?) -> Void) {
        let storage = Storage.storage()
        var path = ""
        
        if lang == "" {
            path = "media/\(test)/\(fileName)"
        } else {
            path = "media/\(test)/\(lang)/\(fileName)"
        }

        let mediaRef = storage.reference(withPath: path)
        let documentPath = Utility.getDocumentsDirectory().appendingPathComponent(path)
        
        do
        {
            try FileManager.default.createDirectory(atPath: documentPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        let localURL = URL(string: documentPath.absoluteString)!
        
        let downloadTask = mediaRef.write(toFile: localURL) { url, error in
          if let error = error {
            print(error.localizedDescription)
          } else {
            print("\(path) downloaded")
          }
        }
        
        let _ = downloadTask.observe(.success) { (snapshot) in
            completionHandler(1.0, nil)
        }
    }
    
    func removeListener() {
        listener?.remove()
    }

    func externalStorage(filePath: String, fileUrl: URL, completionHandler:@escaping (StorageUploadTask?, Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let participantRef = storageRef.child(filePath)
        
        let uploadTask = participantRef.putFile(from: fileUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                completionHandler(nil, error)
            }
        }
        
        completionHandler(uploadTask, nil)
    }
}
