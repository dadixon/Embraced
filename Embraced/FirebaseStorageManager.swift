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
    
    func removeListener() {
        listener?.remove()
    }
    
    // Naming Task
    func storeNamingTask(data: [String: AnyObject]) {
//        guard let index = data["index"] else {
//            return
//        }
//
//        guard let name = data["name"] else {
//            return
//        }
//
//        guard let audioFile = data["audio"] else {
//            return
//        }
//
//        if let pid = userDefaults.string(forKey: "pid") {
//            let storage = Storage.storage()
//            let storageRef = storage.reference()
//            let participantRef = storageRef.child("\(userDefaults.string(forKey: "pid")!)namingTask/\(name).m4a")
//
//            let uploadTask = participantRef.putFile(from: audioFile as! URL, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print("Error: \(error?.localizedDescription)")
//                }
//
//                participantRef.downloadURL { (url, error) in
//                    guard let downloadURL = url else {
//                        // Uh-oh, an error occurred!
//                        print("Error: \(error?.localizedDescription)")
//                        return
//                    }
//
//                    if self.namingTaskID != nil {
//                        let childUpdates = ["participants/\(self.userDefaults.string(forKey: "pid")!)/naming_task/Stimuli_\(index)": downloadURL.absoluteString]
//                        self.ref.updateChildValues(childUpdates)
//                    } else {
//                        var payload: [String: Any] = [
//                            "Created": [".sv": "timestamp"]
//                        ]
//
//                        payload["Stimuli_\(index)"] = downloadURL.absoluteString
//                        payload["Stimuli_\(index)_Score"] = ""
//
//                        self.namingTaskID = pid
//                        self.ref.child("participants/\(self.userDefaults.string(forKey: "pid")!)/naming_task").setValue(payload) { (error, ref) -> Void in
//                            if error != nil {
//                                print("Error: \(error?.localizedDescription)")
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }

    let testPayload = [
        "questionnaire": [
            "ASSESSMENTDATE": "2018-02-19T11:07:55.893Z",
            "DOB": "8/16/1981",
            "AGE": 37,
            "GENDER": 2,
            "WRITINGHAND": 2,
            "DRAWINGHAND": 2,
            "THROWINGHAND": 2,
            "SCISSORSHAND": 2,
            "TOOTHBRUSHHAND": 2,
            "KNIFEHAND": 2,
            "SPOONHAND": 2,
            "BROOMHAND": 2,
            "MATCHHAND": 2,
            "OPENINGHAND": 2,
            "DOMINATEHAND": 2,
            "ETHNICITY": 5,
            "OTHERETHNICITY": "española",
            "RACE1": 5,
            "MSTATUS": 1,
            "MARRIED_YEARS": 18,
            "MARRIED_MONTHS": 9,
            "CHILDREN": 0,
            "CHILDREN_NUMBER": 0,
            "RESIDENCECITY": "Granada",
            "RESIDENCESTATE": "España",
            "RESIDENCECOUNTRY": "España",
            "RESIDENCEINHABITANTS": 3,
            "RESIDENCEURBANICITY": 3,
            "DAILY_ACTIVITIES": 6,
            "FINANCIALLY_DEPENDENT": "yes",
            "EARNINGS": "5000-11999",
            "PEOPLE_IN_HOUSEHOLD": 5,
            "CHILDREN_IN_HOUSEHOLD": 3,
            "ADULTS_IN_HOUSEHOLD": 2,
            "ADULTS_INCOME_IN_HOUSEHOLD": 1,
            "HOME_STATUS": "owned",
            "OTHER_HOME_STATUS": "",
            "TOTAL_INCOME": "25000-34999",
            "COMMUNITYLADDER": 6,
            "COUNTRYLADDER": 7,
            "YEARS_STUDY": 18,
            "AGE_STUDY": 23,
            "HIGHEST_GRADE": "grad",
            "HIGHEST_DEGREE": "bachelor",
            "OTHER_HIGHEST_DEGREE": "",
            "COMPUTER_USAGE": "yes",
            "INTERNET_USAGE": "yes",
            "BELIEFS": "religious",
            "RELIGION": "Christianity",
            "OTHER_RELIGION": "",
            "PRACTICE_MONTH": 4,
            "HOUSEKEEPING_AS_CHILD_MOTHER": "yes",
            "HOUSEKEEPING_AS_CURRENT_ME": "yes",
            "HOUSEKEEP_AS_CURRENT_PARTNER": "yes",
            "CARETAKER_AS_CHILD_MOTHER": "yes",
            "CARETAKER_ME": "yes",
            "CARETAKER_PARTNER": "yes",
            "CARETAKER_GRANDMOTHER": "yes",
            "CHILD_UPBRINGING_ME": "yes",
            "CHILD_UPBRINGING_PARTNER": "yes",
            "IMPORTANT_DECISIONS_CURRENT_ME": "yes",
            "IMPORTANT_DECISIONS_CURRENT_PARTNER": "yes",
            "COUNT_ON": "yes",
            "COUNT_ON_FRIEND": "yes",
            "COUNT_ON_PARTNER": "yes",
            "COUNT_ON_RELATIVE": "",
            "RELY_ON": "no",
            "RELIES_ON_FRIEND": "",
            "RELIES_ON_PARTNER": "",
            "RELIES_ON_RELATIVE": "",
            "ENJOY_ON": "yes",
            "ENJOY_SAME_FRIEND": "yes",
            "ENJOY_SAME_PARTNER": "yes",
            "ENJOY_SAME_RELATIVE": "yes",
            "NO_HELP": "False",
            "EMOTIONAL_ON": "yes",
            "EMOTIONAL_LINK_FRIEND": "",
            "EMOTIONAL_LINK_PARTNER": "yes",
            "EMOTIONAL_LINK_RELATIVE": "yes",
            "COMFORTABLE": "False",
            "ADMINISTERED_PSYCHOLOGICAL_TEST": "no",
            "TIMED_PSYCHOLOGICAL_TEST": "no",
            "COMFORTABLE_PSYCHOLOGICAL_TEST": "yes",
            "IMMIGGRANT_BORN": "",
            "IMMIGRANT_DAILY_ACTIVITIES": "keepinghouse",
            "IMMIGRANT_DAILY_ACTIVITIES_SPECIFY": "",
            "MYSELFBEINGAMERICAN": 1,
            "FEELINGGOODAMERICAN": 1,
            "AMERICANIMPORTANT": 1,
            "FEELAMERICANCULTURE": 1,
            "STRONGBEINGAMERICAN": 1,
            "PROUDAMERICAN": 1,
            "MYCULTUREBEING": 4,
            "MYCULTUREBEINGGOOD": 4,
            "MYCULTUREIMPORTINLIFE": 3,
            "PARTOFCULTURE": 4,
            "BEINGOFCULTURE": 4,
            "BEINGOFCULTUREPROUD": 3,
            "ENGLISHSCHOOL": 2,
            "ENGLISHFRIENDS": 2,
            "ENGLISHPHONE": 1,
            "ENGLISHSTRANGER": 1,
            "ENGLISHGENERAL": 2,
            "ENGLISHTV": 2,
            "ENGLISHNEWSPAPER": 3,
            "ENGLISHSONGS": 2,
            "ENGLISHUGENERAL": 2,
            "NATIVEFAMILY": 4,
            "NATIVEFRIENDS": 4,
            "NATIVEPHONE": 4,
            "NATIVESTRANGERS": 4,
            "NATIVEGENERAL": 3,
            "NATIVETV": 4,
            "NATIVENEWSPAPER": 4,
            "NATIVESONGS": 4,
            "NATIVEUGENERAL": 4,
            "KNOWAMERICANHEROES": 1,
            "KNOWAMERICANTV": 1,
            "KNOWAMERICANNEWSPAPER": 2,
            "KNOWAMERICANACTOR": 2,
            "KNOWAMERICANHISTORY": 1,
            "KNOWAMERICANLEADER": 2,
            "KNOWNATIVEHEROES": 3,
            "KNOWNATIVETV": 3,
            "KNOWNATIVENEWSPAPER": 3,
            "KNOWNATIVEACTOR": 3,
            "KNOWNATIVEHISTORY": 3,
            "KNOWNATIVELEADER": 3
        ],
        "moca": [
            "REAL_date": "2/19/2018",
            "REAL_time": "11:36",
            "REAL_AMPM": "AM",
            "REAL_dayOfWeek": "lunes",
            "REAL_country": "España",
            "REAL_county": "",
            "REAL_city": "granada",
            "REAL_location": "CIMCYC",
            "REAL_floor": "2",
            "ORIENT_year": 2018,
            "ORIENT_month": "February",
            "ORIENT_day": 19,
            "ORIENT_dayweek": "Monday",
            "ORIENT_hour": 12,
            "ORIENT_minutes": 10,
            "ORIENT_AMPM": "PM",
            "ORIENT_country": "España",
            "ORIENT_county": "",
            "ORIENT_city": "Granada",
            "ORIENT_location": "Psicología cimcyc",
            "ORIENT_floor": "-1"
        ],
        "rcf": [
            "RCF1_Time": 125372,
            "RCF1_File": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/4ebce8d90e5075d6e9fc075459b4fc1c79c35302.png",
            "RCF1_Score": "",
            "RCF2_Time": 97601,
            "RCF2_File": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/b4caafbbde15948abcfe6aedc1c60b4fd9a65f18.png",
            "RCF2_Score": "",
            "RCF3_Time": 57923,
            "RCF3_File": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/21921d9dc0f80fe4ba4b76dfc9c9cefe6560f7f6.png",
            "RCF3_Score": "",
            "RCF4_Hits": 21,
            "RCF4_Omissions": 3,
            "RCF4_Commissions": 0
        ],
        "clockDrawing": [
            "CLOCK_time": 41273,
            "CLOCK_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/aa9ef2c0aea12279fd7b428a4788a663cfcdbc68.png",
            "CLOCK_score": ""
        ],
        "TMT": [
            "TMTA_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/1f87e7eceb3e55cb25f401e6fb2e679e20778ee0.png",
            "TMTA_time": 24992,
            "TMTA_errors": "",
            "TMTB_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/7bad8012d2b8119c29eccf3036454d895c6db960.png",
            "TMTB_time": 28519,
            "TMTB_errors": ""
        ],
        "melodyRecognition": [
            "MELODIES_1": "c",
            "MELODIES_2": "i",
            "MELODIES_3": "c",
            "MELODIES_4": "i",
            "MELODIES_5": "i",
            "MELODIES_6": "c",
            "MELODIES_7": "i",
            "MELODIES_8": "c",
            "MELODIES_9": "i",
            "MELODIES_10": "i",
            "MELODIES_11": "i",
            "MELODIES_12": "i",
            "MELODIES_13": "c",
            "MELODIES_14": "i",
            "MELODIES_15": "i",
            "MELODIES_16": "i",
            "MELODIES_17": "i",
            "MELODIES_18": "i",
            "MELODIES_19": "c",
            "MELODIES_20": "i",
            "MELODIES_21": "i",
            "MELODIES_22": "c",
            "MELODIES_23": "c",
            "MELODIES_24": "i",
            "score": 3
        ],
        "digitSpan": [
            "DSFWD1file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward1.m4a",
            "DSFWD1_score": "",
            "DSFWD2file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward2.m4a",
            "DSFWD2_score": "",
            "DSFWD3file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward3.m4a",
            "DSFWD3_score": "",
            "DSFWD4file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward4.m4a",
            "DSFWD4_score": "",
            "DSFWD5file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward5.m4a",
            "DSFWD5_score": "",
            "DSFWD6file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward6.m4a",
            "DSFWD6_score": "",
            "DSFWD7file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward7.m4a",
            "DSFWD7_score": "",
            "DSFWD8file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward8.m4a",
            "DSFWD8_score": "",
            "DSFWD9file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward9.m4a",
            "DSFWD9_score": "",
            "DSFWD10file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward10.m4a",
            "DSFWD10_score": "",
            "DSFWD11file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward11.m4a",
            "DSFWD11_score": "",
            "DSFWD12file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward12.m4a",
            "DSFWD12_score": "",
            "DSFWD13file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward13.m4a",
            "DSFWD13_score": "",
            "DSFWD14file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/forward14.m4a",
            "DSFWD14_score": "",
            "DSFWD_totalcorrect": 0,
            "DSFWD_longestseries": 0,
            "DSBWD1file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward1.m4a",
            "DSBWD1_score": "",
            "DSBWD2file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward2.m4a",
            "DSBWD2_score": "",
            "DSBWD3file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward3.m4a",
            "DSBWD3_score": "",
            "DSBWD4file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward4.m4a",
            "DSBWD4_score": "",
            "DSBWD5file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward5.m4a",
            "DSBWD5_score": "",
            "DSBWD6file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward6.m4a",
            "DSBWD6_score": "",
            "DSBWD7file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward7.m4a",
            "DSBWD7_score": "",
            "DSBWD8file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward8.m4a",
            "DSBWD8_score": "",
            "DSBWD9file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward9.m4a",
            "DSBWD9_score": "",
            "DSBWD10file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward10.m4a",
            "DSBWD10_score": "",
            "DSBWD11file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward11.m4a",
            "DSBWD11_score": "",
            "DSBWD12file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward12.m4a",
            "DSBWD12_score": "",
            "DSBWD13file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward13.m4a",
            "DSBWD13_score": "",
            "DSBWD14file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/backward14.m4a",
            "DSBWD14_score": "",
            "DSBWD_totalcorrect": 0,
            "DSBWD_longestseries": 0
        ],
        "matrices": [
            "MATRICES1_answer": 4,
            "MATRICES1_correct": "yes",
            "MATRICES2_answer": 5,
            "MATRICES2_correct": "no",
            "MATRICES3_answer": 2,
            "MATRICES3_correct": "yes",
            "MATRICES4_answer": 3,
            "MATRICES4_correct": "no",
            "MATRICES5_answer": 6,
            "MATRICES5_correct": "no",
            "MATRICES6_answer": 1,
            "MATRICES6_correct": "no",
            "MATRICES7_answer": 2,
            "MATRICES7_correct": "no",
            "MATRICES8_answer": 6,
            "MATRICES8_correct": "no",
            "MATRICES9_answer": 1,
            "MATRICES9_correct": "no",
            "MATRICES10_answer": 3,
            "MATRICES10_correct": "no",
            "MATRICES11_answer": 4,
            "MATRICES11_correct": "no",
            "MATRICES12_answer": 2,
            "MATRICES12_correct": "no",
            "MATRICES13_answer": 1,
            "MATRICES13_correct": "no",
            "MATRICES14_answer": 6,
            "MATRICES14_correct": "no",
            "MATRICES15_answer": 3,
            "MATRICES15_correct": "yes",
            "MATRICES16_answer": 6,
            "MATRICES16_correct": "no",
            "MATRICES17_answer": 2,
            "MATRICES17_correct": "no",
            "MATRICES18_answer": 4,
            "MATRICES18_correct": "no",
            "MATRICES19_answer": 5,
            "MATRICES19_correct": "no",
            "MATRICES20_answer": 4,
            "MATRICES20_correct": "no",
            "MATRICES21_answer": 4,
            "MATRICES21_correct": "no",
            "MATRICES22_answer": 1,
            "MATRICES22_correct": "no",
            "MATRICES23_answer": 2,
            "MATRICES23_correct": "yes",
            "MATRICES24_answer": 4,
            "MATRICES24_correct": "no",
            "MATRICES25_answer": 2,
            "MATRICES25_correct": "no",
            "MATRICES26_answer": 1,
            "MATRICES26_correct": "yes",
            "MATRICES27_answer": 4,
            "MATRICES27_correct": "no",
            "MATRICES28_answer": 7,
            "MATRICES28_correct": "no",
            "MATRICES29_answer": 2,
            "MATRICES29_correct": "no",
            "MATRICES30_answer": 8,
            "MATRICES30_correct": "no",
            "MATRICES31_answer": 6,
            "MATRICES31_correct": "no",
            "MATRICES32_answer": 5,
            "MATRICES32_correct": "yes",
            "MATRICES33_answer": 3,
            "MATRICES33_correct": "no",
            "MATRICES34_answer": 8,
            "MATRICES34_correct": "yes",
            "MATRICES35_answer": 6,
            "MATRICES35_correct": "no",
            "MATRICES36_answer": 4,
            "MATRICES36_correct": "no",
            "MATRICES37_answer": 1,
            "MATRICES37_correct": "no",
            "MATRICES38_answer": 6,
            "MATRICES38_correct": "no",
            "MATRICES39_answer": 4,
            "MATRICES39_correct": "no",
            "MATRICES40_answer": 2,
            "MATRICES40_correct": "yes",
            "MATRICES41_answer": 7,
            "MATRICES41_correct": "no",
            "MATRICES42_answer": 3,
            "MATRICES42_correct": "no",
            "MATRICES43_answer": 8,
            "MATRICES43_correct": "no",
            "MATRICES44_answer": 5,
            "MATRICES44_correct": "no",
            "MATRICES45_answer": 2,
            "MATRICES45_correct": "no",
            "MATRICES46_answer": 8,
            "MATRICES46_correct": "no",
            "MATRICES47_answer": 7,
            "MATRICES47_correct": "no",
            "MATRICES48_answer": 6,
            "MATRICES48_correct": "no",
            "MATRICES49_answer": 1,
            "MATRICES49_correct": "no",
            "MATRICES50_answer": 5,
            "MATRICES50_correct": "no",
            "MATRICES51_answer": 3,
            "MATRICES51_correct": "no",
            "MATRICES52_answer": 8,
            "MATRICES52_correct": "no",
            "MATRICES53_answer": 6,
            "MATRICES53_correct": "yes",
            "MATRICES54_answer": 7,
            "MATRICES54_correct": "yes",
            "MATRICES55_answer": 7,
            "MATRICES55_correct": "no",
            "MATRICES56_answer": 2,
            "MATRICES56_correct": "yes",
            "MATRICES57_correct": "no",
            "MATRICES58_correct": "no",
            "MATRICES59_answer": 7,
            "MATRICES59_correct": "no",
            "MATRICES60_answer": 4,
            "MATRICES60_correct": "yes",
            "MATRICES_totalcorrect": 12
        ],
        "cpt": [
            "CPT_BLOCK1_hits": 15,
            "CPT_BLOCK1_omissions": 1,
            "CPT_BLOCK1_commissions": 1,
            "CPT_BLOCK1_average": 427.3333333333333,
            "CPT_BLOCK1_median": 452,
            "CPT_BLOCK2_hits": 16,
            "CPT_BLOCK2_omissions": 0,
            "CPT_BLOCK2_commissions": 1,
            "CPT_BLOCK2_average": 485.5625,
            "CPT_BLOCK2_median": 465.5,
            "CPT_BLOCK3_hits": 16,
            "CPT_BLOCK3_omissions": 0,
            "CPT_BLOCK3_commissions": 0,
            "CPT_BLOCK3_average": 450.125,
            "CPT_BLOCK3_median": 434.5
        ],
        "motorTasks": [
            "MOTOR1_dominant_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/f76a7fa24c700d3e286a067a217f96aece6b67bd.png",
            "MOTOR1_dominant_score": "",
            "MOTOR1_nondominant_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/9d3a79ae78581cfa0e24f588cad58ec0950c91d6.png",
            "MOTOR1_nondominant_score": "",
            "MOTOR2_dominant_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/241ab0566325c0be478053585109ef2d8fead8da.png",
            "MOTOR2_dominant_score": "",
            "MOTOR2_nondominant_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/808af89c9d4d0ed70e34790946c71ed4b13e649f.png",
            "MOTOR2_nondominant_score": "",
            "MOTOR3_dominant_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/282635362868ab7a5d8c4a796da7a01861e30c1d.png",
            "MOTOR3_dominant_score": "",
            "MOTOR3_nondominant_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/58e6c6426fc96d3d4f11c05e47da563e30e81424.png",
            "MOTOR3_nondominant_score": ""
        ],
        "wordlist": [
            "WORDLIST1_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/wordlist1.m4a",
            "WORDLIST1_1": "",
            "WORDLIST1_2": "",
            "WORDLIST1_3": "",
            "WORDLIST1_4": "",
            "WORDLIST1_5": "",
            "WORDLIST1_6": "",
            "WORDLIST1_7": "",
            "WORDLIST1_8": "",
            "WORDLIST1_9": "",
            "WORDLIST1_10": "",
            "WORDLIST1_11": "",
            "WORDLIST1_12": "",
            "WORDLIST1_13": "",
            "WORDLIST1_14": "",
            "WORDLIST1_15": "",
            "WORDLIST1_16": "",
            "WORDLIST1_total": "",
            "WORDLIST1_intrusions": "",
            "WORDLIST1_perseverations": "",
            "WORDLIST2_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/wordlist2.m4a",
            "WORDLIST2_1": "",
            "WORDLIST2_2": "",
            "WORDLIST2_3": "",
            "WORDLIST2_4": "",
            "WORDLIST2_5": "",
            "WORDLIST2_6": "",
            "WORDLIST2_7": "",
            "WORDLIST2_8": "",
            "WORDLIST2_9": "",
            "WORDLIST2_10": "",
            "WORDLIST2_11": "",
            "WORDLIST2_12": "",
            "WORDLIST2_13": "",
            "WORDLIST2_14": "",
            "WORDLIST2_15": "",
            "WORDLIST2_16": "",
            "WORDLIST2_total": "",
            "WORDLIST2_intrusions": "",
            "WORDLIST2_perseverations": "",
            "WORDLIST3_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/wordlist3.m4a",
            "WORDLIST3_1": "",
            "WORDLIST3_2": "",
            "WORDLIST3_3": "",
            "WORDLIST3_4": "",
            "WORDLIST3_5": "",
            "WORDLIST3_6": "",
            "WORDLIST3_7": "",
            "WORDLIST3_8": "",
            "WORDLIST3_9": "",
            "WORDLIST3_10": "",
            "WORDLIST3_11": "",
            "WORDLIST3_12": "",
            "WORDLIST3_13": "",
            "WORDLIST3_14": "",
            "WORDLIST3_15": "",
            "WORDLIST3_16": "",
            "WORDLIST3_total": "",
            "WORDLIST3_intrusions": "",
            "WORDLIST3_perseverations": "",
            "WORDLIST4_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/wordlist4.m4a",
            "WORDLIST4_1": "",
            "WORDLIST4_2": "",
            "WORDLIST4_3": "",
            "WORDLIST4_4": "",
            "WORDLIST4_5": "",
            "WORDLIST4_6": "",
            "WORDLIST4_7": "",
            "WORDLIST4_8": "",
            "WORDLIST4_9": "",
            "WORDLIST4_10": "",
            "WORDLIST4_11": "",
            "WORDLIST4_12": "",
            "WORDLIST4_13": "",
            "WORDLIST4_14": "",
            "WORDLIST4_15": "",
            "WORDLIST4_16": "",
            "WORDLIST4_total": "",
            "WORDLIST4_intrusions": "",
            "WORDLIST4_perseverations": "",
            "WORDLIST5_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/wordlist5.m4a",
            "WORDLIST5_1": "",
            "WORDLIST5_2": "",
            "WORDLIST5_3": "",
            "WORDLIST5_4": "",
            "WORDLIST5_5": "",
            "WORDLIST5_6": "",
            "WORDLIST5_7": "",
            "WORDLIST5_8": "",
            "WORDLIST5_9": "",
            "WORDLIST5_10": "",
            "WORDLIST5_11": "",
            "WORDLIST5_12": "",
            "WORDLIST5_13": "",
            "WORDLIST5_14": "",
            "WORDLIST5_15": "",
            "WORDLIST5_16": "",
            "WORDLIST5_total": "",
            "WORDLIST5_intrusions": "",
            "WORDLIST5_perseverations": "",
            "WORDLISTB_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/wordlist6.m4a",
            "WORDLISTB_1": "",
            "WORDLISTB_2": "",
            "WORDLISTB_3": "",
            "WORDLISTB_4": "",
            "WORDLISTB_5": "",
            "WORDLISTB_6": "",
            "WORDLISTB_7": "",
            "WORDLISTB_8": "",
            "WORDLISTB_9": "",
            "WORDLISTB_10": "",
            "WORDLISTB_11": "",
            "WORDLISTB_12": "",
            "WORDLISTB_13": "",
            "WORDLISTB_14": "",
            "WORDLISTB_15": "",
            "WORDLISTB_16": "",
            "WORDLISTB_total": "",
            "WORDLISTB_intrusions": "",
            "WORDLISTB_perseverations": "",
            "WORDLIST_ST_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/wordlist7.m4a",
            "WORDLIST_ST_1": "",
            "WORDLIST_ST_2": "",
            "WORDLIST_ST_3": "",
            "WORDLIST_ST_4": "",
            "WORDLIST_ST_5": "",
            "WORDLIST_ST_6": "",
            "WORDLIST_ST_7": "",
            "WORDLIST_ST_8": "",
            "WORDLIST_ST_9": "",
            "WORDLIST_ST_10": "",
            "WORDLIST_ST_11": "",
            "WORDLIST_ST_12": "",
            "WORDLIST_ST_13": "",
            "WORDLIST_ST_14": "",
            "WORDLIST_ST_15": "",
            "WORDLIST_ST_16": "",
            "WORDLIST_ST_total": "",
            "WORDLIST_ST_intrusions": "",
            "WORDLIST_ST_perseverations": "",
            "WORDLIST_LT_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/wordlistRecall.m4a",
            "WORDLIST_LT_1": "",
            "WORDLIST_LT_2": "",
            "WORDLIST_LT_3": "",
            "WORDLIST_LT_4": "",
            "WORDLIST_LT_5": "",
            "WORDLIST_LT_6": "",
            "WORDLIST_LT_7": "",
            "WORDLIST_LT_8": "",
            "WORDLIST_LT_9": "",
            "WORDLIST_LT_10": "",
            "WORDLIST_LT_11": "",
            "WORDLIST_LT_12": "",
            "WORDLIST_LT_13": "",
            "WORDLIST_LT_14": "",
            "WORDLIST_LT_15": "",
            "WORDLIST_LT_16": "",
            "WORDLIST_LT_total": "",
            "WORDLIST_LT_intrusions": "",
            "WORDLIST_LT_perseverations": "",
            "WORDLIST_REC_hits": 15,
            "WORDLIST_REC_omissions": 1,
            "WORDLIST_REC_comissions": 1
        ],
        "stroop": [
            "STROOP1_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/stroop1.m4a",
            "STROOP1_RT": 20849,
            "STROOP1_errors": "",
            "STROOP1_corrections": "",
            "STROOP2_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/stroop2.m4a",
            "STROOP2_RT": 16794,
            "STROOP2_errors": "",
            "STROOP2_corrections": "",
            "STROOP3_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/stroop3.m4a",
            "STROOP3_RT": 14722,
            "STROOP3_errors": "",
            "STROOP3_corrections": "",
            "STROOP4_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/stroop4.m4a",
            "STROOP4_RT": 23002,
            "STROOP4_errors": "",
            "STROOP4_corrections": ""
        ],
        "cancellation": [
            "CANCELLATION_1_hits": 4,
            "CANCELLATION_1_omissions": 11,
            "CANCELLATION_1_commissions": 0,
            "CANCELLATION_1_backward": 0,
            "CANCELLATION_2_hits": 8,
            "CANCELLATION_2_omissions": 7,
            "CANCELLATION_2_commissions": 0,
            "CANCELLATION_2_backward": 0,
            "CANCELLATION_3_hits": 6,
            "CANCELLATION_3_omissions": 9,
            "CANCELLATION_3_commissions": 0,
            "CANCELLATION_3_backward": 0,
            "CANCELLATION_4_hits": 7,
            "CANCELLATION_4_omissions": 8,
            "CANCELLATION_4_commissions": 0,
            "CANCELLATION_4_backward": 0,
            "CANCELLATION_5_hits": 11,
            "CANCELLATION_5_omissions": 4,
            "CANCELLATION_5_commissions": 0,
            "CANCELLATION_5_backward": 0,
            "CANCELLATION_6_hits": 11,
            "CANCELLATION_6_omissions": 4,
            "CANCELLATION_6_commissions": 0,
            "CANCELLATION_6_backward": 0,
            "CANCELLATION_7_hits": 11,
            "CANCELLATION_7_omissions": 4,
            "CANCELLATION_7_commissions": 0,
            "CANCELLATION_7_backward": 0,
            "CANCELLATION_8_hits": 8,
            "CANCELLATION_8_omissions": 7,
            "CANCELLATION_8_commissions": 0,
            "CANCELLATION_8_backward": 0,
            "CANCELLATION_9_hits": 9,
            "CANCELLATION_9_omissions": 6,
            "CANCELLATION_9_commissions": 0,
            "CANCELLATION_9_backward": 0,
            "CANCELLATION_10_hits": 8,
            "CANCELLATION_10_omissions": 7,
            "CANCELLATION_10_commissions": 0,
            "CANCELLATION_10_backward": 0,
            "CANCELLATION_total_hits": 83,
            "CANCELLATION_total_omissions": 67,
            "CANCELLATION_total_commissions": 0,
            "CANCELLATION_total_backward": 0
        ],
        "namingTask": [
            "NAMING1_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask0.m4a",
            "NAMING1_correct": "",
            "NAMING2_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask1.m4a",
            "NAMING2_correct": "",
            "NAMING3_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask2.m4a",
            "NAMING3_correct": "",
            "NAMING4_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask3.m4a",
            "NAMING4_correct": "",
            "NAMING5_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask4.m4a",
            "NAMING5_correct": "",
            "NAMING6_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask5.m4a",
            "NAMING6_correct": "",
            "NAMING7_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask6.m4a",
            "NAMING7_correct": "",
            "NAMING8_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask7.m4a",
            "NAMING8_correct": "",
            "NAMING9_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask8.m4a",
            "NAMING9_correct": "",
            "NAMING10_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask9.m4a",
            "NAMING10_correct": "",
            "NAMING11_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask10.m4a",
            "NAMING11_correct": "",
            "NAMING12_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask11.m4a",
            "NAMING12_correct": "",
            "NAMING13_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask12.m4a",
            "NAMING13_correct": "",
            "NAMING14_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask13.m4a",
            "NAMING14_correct": "",
            "NAMING15_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask14.m4a",
            "NAMING15_correct": "",
            "NAMING16_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask15.m4a",
            "NAMING16_correct": "",
            "NAMING17_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask16.m4a",
            "NAMING17_correct": "",
            "NAMING18_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask17.m4a",
            "NAMING18_correct": "",
            "NAMING19_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask18.m4a",
            "NAMING19_correct": "",
            "NAMING20_file": "http://www.embracedapi.ugr.es/Storage/5a8aa8360b2bf93f29a266de/namingTask19.m4a",
            "NAMING20_correct": "",
            "NAMING_total": ""
        ],
        "comprehension": [
            "COMPREHENSION_1_RT": 7360,
            "COMPREHENSION_1": "correct",
            "COMPREHENSION_1_RESPONSES": [1, 2],
            "COMPREHENSION_2_RT": 1252,
            "COMPREHENSION_2": "incorrect",
            "COMPREHENSION_2_RESPONSES": [1],
            "COMPREHENSION_3_RT": 659,
            "COMPREHENSION_3": "correct",
            "COMPREHENSION_3_RESPONSES": [1],
            "COMPREHENSION_4_RT": 1298,
            "COMPREHENSION_4": "correct",
            "COMPREHENSION_4_RESPONSES": [1],
            "COMPREHENSION_5_RT": 1320,
            "COMPREHENSION_5": "correct",
            "COMPREHENSION_5_RESPONSES": [1],
            "COMPREHENSION_6_RT": 1164,
            "COMPREHENSION_6": "correct",
            "COMPREHENSION_6_RESPONSES": [1],
            "COMPREHENSION_7_RT": 2771,
            "COMPREHENSION_7": "correct",
            "COMPREHENSION_7_RESPONSES": [1],
            "COMPREHENSION_8_RT": 2155,
            "COMPREHENSION_8": "correct",
            "COMPREHENSION_8_RESPONSES": [1],
            "COMPREHENSION_9_RT": 2862,
            "COMPREHENSION_9": "correct",
            "COMPREHENSION_9_RESPONSES": [1],
            "COMPREHENSION_10_RT": 663,
            "COMPREHENSION_10": "correct",
            "COMPREHENSION_10_RESPONSES": [1],
            "COMPREHENSION_11_RT": 1034,
            "COMPREHENSION_11": "correct",
            "COMPREHENSION_11_RESPONSES": [1],
            "COMPREHENSION_12_RT": 886,
            "COMPREHENSION_12": "correct",
            "COMPREHENSION_12_RESPONSES": [1],
            "COMPREHENSION_13_RT": 3091,
            "COMPREHENSION_13": "incorrect",
            "COMPREHENSION_13_RESPONSES": [1],
            "COMPREHENSION_14_RT": 2387,
            "COMPREHENSION_14": "correct",
            "COMPREHENSION_14_RESPONSES": [1],
            "COMPREHENSION_15_RT": 3392,
            "COMPREHENSION_15": "correct",
            "COMPREHENSION_15_RESPONSES": [1],
            "COMPREHENSION_16_RT": 3032,
            "COMPREHENSION_16": "correct",
            "COMPREHENSION_16_RESPONSES": [1],
            "COMPREHENSION_17_RT": 2424,
            "COMPREHENSION_17": "correct",
            "COMPREHENSION_17_RESPONSES": [1],
            "COMPREHENSION_18_RT": 4996,
            "COMPREHENSION_18": "correct",
            "COMPREHENSION_18_RESPONSES": [1],
            "COMPREHENSION_19_RT": 920,
            "COMPREHENSION_19": "correct",
            "COMPREHENSION_19_RESPONSES": [1],
            "COMPREHENSION_20_RT": 3745,
            "COMPREHENSION_20": "correct",
            "COMPREHENSION_20_RESPONSES": [1],
            "COMPREHENSION_21_RT": 4473,
            "COMPREHENSION_21": "correct",
            "COMPREHENSION_21_RESPONSES": [1],
            "COMPREHENSION_total": 19
        ],
        "eyesTest": [
            "EYES1_answer": "Playful",
            "EYES1_correct": "correct",
            "EYES2_answer": "Upset",
            "EYES2_correct": "correct",
            "EYES3_answer": "Desire",
            "EYES3_correct": "correct",
            "EYES4_answer": "Insisting",
            "EYES4_correct": "correct",
            "EYES5_answer": "Worried",
            "EYES5_correct": "correct",
            "EYES6_answer": "Fantasizing",
            "EYES6_correct": "correct",
            "EYES7_answer": "Uneasy",
            "EYES7_correct": "correct",
            "EYES8_answer": "Excited",
            "EYES8_correct": "incorrect",
            "EYES9_answer": "Hostile",
            "EYES9_correct": "incorrect",
            "EYES10_answer": "Cautious",
            "EYES10_correct": "correct",
            "EYES11_answer": "Regretful",
            "EYES11_correct": "correct",
            "EYES12_answer": "Indifferent",
            "EYES12_correct": "incorrect",
            "EYES13_answer": "Anticipating",
            "EYES13_correct": "correct",
            "EYES14_answer": "Accusing",
            "EYES14_correct": "correct",
            "EYES15_answer": "Contemplative",
            "EYES15_correct": "correct",
            "EYES16_answer": "Sympathetic",
            "EYES16_correct": "incorrect",
            "EYES17_answer": "Doubtful",
            "EYES17_correct": "correct",
            "EYES18_answer": "Decisive",
            "EYES18_correct": "correct",
            "EYES19_answer": "Grateful",
            "EYES19_correct": "incorrect",
            "EYES20_answer": "Friendly",
            "EYES20_correct": "correct",
            "EYES21_answer": "Fantasizing",
            "EYES21_correct": "correct",
            "EYES22_answer": "Preoccupied",
            "EYES22_correct": "correct",
            "EYES23_answer": "Defiant",
            "EYES23_correct": "correct",
            "EYES24_answer": "Pensive",
            "EYES24_correct": "correct",
            "EYES25_answer": "Interested",
            "EYES25_correct": "correct",
            "EYES26_answer": "Hostile",
            "EYES26_correct": "correct",
            "EYES27_answer": "Cautious",
            "EYES27_correct": "correct",
            "EYES28_answer": "Interested",
            "EYES28_correct": "correct",
            "EYES29_answer": "Reflective",
            "EYES29_correct": "correct",
            "EYES30_answer": "Hostile",
            "EYES30_correct": "incorrect",
            "EYES31_answer": "Dispirited",
            "EYES31_correct": "incorrect",
            "EYES32_answer": "Serious",
            "EYES32_correct": "correct",
            "EYES33_answer": "Concerned",
            "EYES33_correct": "correct",
            "EYES34_answer": "Distrustful",
            "EYES34_correct": "correct",
            "EYES35_answer": "Nervous",
            "EYES35_correct": "correct",
            "EYES36_answer": "Suspicious",
            "EYES36_correct": "correct",
            "EYES_total": 29
        ]
    ]
}
