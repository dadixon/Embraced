//
//  DataManager.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/9/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import Foundation
import Firebase

class DataManager {
    static let sharedInstance = DataManager()
    var language = String()
    
    var stimuli = [String: Any]()
    var namingTaskStimuli = [String: Any]()
    var digitalSpanStimuli = [String: Any]()
    var pitchStimuli = [String: Any]()
    var stroopStimuli = [String: Any]()
    var wordlistStimuli = [String: Any]()
    var practice = Array<String>()
    var task = Array<String>()
    var pitchExamples = [[String]]()
    var pitchPractices = [[String]]()
    var pitchTasks = [[String]]()
    var digitalSpanForward = [String]()
    var digitalSpanForwardPractice = String()
    var digitalSpanBackward = [String]()
    var digitalSpanBackwardPractice = String()
    var wordListRecognitions = [String]()
    var wordListTasks = [String]()
    var stroopTasks = [String]()
    var stroopVideos = [String]()
    var namingTaskPractice = [String]()
    var namingTaskTask = [String]()
    
    func updateData() {
        switch language {
        case "en":
            setEnData()
        case "es":
            setEsData()
        default:
            setEnData()
        }
    }
    
    private func downloadFiles(path: String, name: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent(name)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(path)
        
        
        let downloadTask = fileRef.write(toFile: localURL) { url, error in
            if let error = error {
                print(error)
            } else {
                print("File is downloaded")
            }
        }
    }
    
    private func setEnData() {
        // Download digit span practice
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("digitSpanEngForwardPractice.mp3")
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let digitSpanForwardPracticeRef = storageRef.child("data/digitSpan/eng/ENG-PRACTICE-FWD.mp3")
        let digitSpanForwardPractice = URL(string: "digitSpanEngForwardPractice.mp3")
        
        
        let downloadTask = digitSpanForwardPracticeRef.write(toFile: localURL) { url, error in
            if let error = error {
                print(error)
            } else {
                print("File is downloaded")
                self.digitalSpanForwardPractice = "digitSpanEngForwardPractice.mp3"
            }
        }
        
        pitchExamples = [
            ["melodies 320ms orig(16).wav"],
            ["melodies 320ms diff(16).wav", "melodies 320ms orig(16).wav"],
            ["melodies 320ms diff(61).wav", "melodies 320ms orig(61).wav"]
        ]
        
        pitchPractices = [
            ["melodies 320ms diff(68).wav", "melodies 320ms orig(68).wav"],
            ["melodies 320ms diff(21).wav", "melodies 320ms orig(21).wav"],
            ["melodies 320ms orig(26).wav"],
            ["melodies 320ms diff(62).wav", "melodies 320ms orig(62).wav"],
            ["melodies 320ms diff(44).wav", "melodies 320ms orig(44).wav"],
        ]
        
        pitchTasks = [
            ["melodies 320ms orig(01).wav"],
            ["melodies 320ms diff(24).wav", "melodies 320ms orig(24).wav"],
            ["melodies 320ms orig(33).wav"],
            ["melodies 320ms orig(46).wav"],
            ["melodies 320ms orig(05).wav"],
            ["melodies 320ms orig(17).wav"],
            ["melodies 320ms diff(40).wav", "melodies 320ms orig(40).wav"],
            ["melodies 320ms diff(85).wav", "melodies 320ms orig(85).wav"],
            ["melodies 320ms diff(07).wav", "melodies 320ms orig(07).wav"],
            ["melodies 320ms diff(51).wav", "melodies 320ms orig(51).wav"],
            ["melodies 320ms diff(66).wav", "melodies 320ms orig(66).wav"],
            ["melodies 320ms diff(32).wav", "melodies 320ms orig(32).wav"],
            ["melodies 320ms orig(82).wav"],
            ["melodies 320ms orig(89).wav"],
            ["melodies 320ms orig(91).wav"],
            ["melodies 320ms orig(49).wav"],
            ["melodies 320ms diff(52).wav", "melodies 320ms orig(52).wav"],
            ["melodies 320ms orig(27).wav"],
            ["melodies 320ms diff(45).wav", "melodies 320ms orig(45).wav"],
            ["melodies 320ms diff(54).wav", "melodies 320ms orig(54).wav"],
            ["melodies 320ms orig(60).wav"],
            ["melodies 320ms diff(74).wav", "melodies 320ms orig(74).wav"],
            ["melodies 320ms orig(90).wav"],
            ["melodies 320ms diff(06).wav", "melodies 320ms orig(06).wav"]
        ]
        
        digitalSpanForwardPractice = "digitSpanEngForwardPractice.mp3"
        digitalSpanForward = [
            "ENG-FWD-1",
            "ENG-FWD-2",
            "ENG-FWD-3",
            "ENG-FWD-4",
            "ENG-FWD-5",
            "ENG-FWD-6",
            "ENG-FWD-7",
            "ENG-FWD-8",
            "ENG-FWD-9",
            "ENG-FWD-10",
            "ENG-FWD-11",
            "ENG-FWD-12",
            "ENG-FWD-13",
            "ENG-FWD-14"
        ]
        
        digitalSpanBackwardPractice = "ENG-PRACTICE-BWD"
        digitalSpanBackward = [
            "ENG-BWD-1",
            "ENG-BWD-2",
            "ENG-BWD-3",
            "ENG-BWD-4",
            "ENG-BWD-5",
            "ENG-BWD-6",
            "ENG-BWD-7",
            "ENG-BWD-8",
            "ENG-BWD-9",
            "ENG-BWD-10",
            "ENG-BWD-11",
            "ENG-BWD-12",
            "ENG-BWD-13",
            "ENG-BWD-14"
        ]
        
        stroopVideos = [
            "STROOP_ENG_TASK1.mp4",
            "STROOP_ENG_TASK2.mp4",
            "STROOP_ENG_TASK3.mp4",
            "STROOP_ENG_TASK4.mp4"
        ]
        
        stroopTasks = [
            "STIMULI_1_ENG",
            "STIMULI_2&4_ENG",
            "STIMULI_3"
        ]
        
        namingTaskPractice = [
            "namingTaskPractice1en",
            "namingTaskPractice2en",
            "namingTaskPractice3en"
        ]
        namingTaskTask = [
            "namingTaskTask1en",
            "namingTaskTask2en",
            "namingTaskTask3en",
            "namingTaskTask4en",
            "namingTaskTask5en",
            "namingTaskTask6en",
            "namingTaskTask7en",
            "namingTaskTask8en",
            "namingTaskTask9en",
            "namingTaskTask10en",
            "namingTaskTask11en",
            "namingTaskTask12en",
            "namingTaskTask13en",
            "namingTaskTask14en",
            "namingTaskTask15en",
            "namingTaskTask16en",
            "namingTaskTask17en",
            "namingTaskTask18en",
            "namingTaskTask19en",
            "namingTaskTask20en"
        ]
        
        wordListRecognitions = [
            "ENG-1",
            "ENG-2",
            "ENG-3",
            "ENG-4",
            "ENG-5",
            "ENG-6",
            "ENG-7",
            "ENG-8",
            "ENG-9",
            "ENG-10",
            "ENG-11",
            "ENG-12",
            "ENG-13",
            "ENG-14",
            "ENG-15",
            "ENG-16",
            "ENG-17",
            "ENG-18",
            "ENG-19",
            "ENG-20",
            "ENG-21",
            "ENG-22",
            "ENG-23",
            "ENG-24",
            "ENG-25",
            "ENG-26",
            "ENG-27",
            "ENG-28",
            "ENG-29",
            "ENG-30",
            "ENG-31",
            "ENG-32",
            "ENG-33",
            "ENG-34",
            "ENG-35",
            "ENG-36",
            "ENG-37",
            "ENG-38",
            "ENG-39",
            "ENG-40",
            "ENG-41",
            "ENG-42",
            "ENG-43",
            "ENG-44"
        ]
        
        wordListTasks = [
            "List A ENG",
            "List B ENG"
        ]
    }
    
    private func setEsData() {
        pitchExamples = [
            ["melodies 320ms orig(16).wav"],
            ["melodies 320ms diff(16).wav", "melodies 320ms orig(16).wav"],
            ["melodies 320ms diff(61).wav", "melodies 320ms orig(61).wav"]
        ]
        
        pitchPractices = [
            ["melodies 320ms diff(68).wav", "melodies 320ms orig(68).wav"],
            ["melodies 320ms diff(21).wav", "melodies 320ms orig(21).wav"],
            ["melodies 320ms orig(26).wav"],
            ["melodies 320ms diff(62).wav", "melodies 320ms orig(62).wav"],
            ["melodies 320ms diff(44).wav", "melodies 320ms orig(44).wav"],
        ]
        
        pitchTasks = [
            ["melodies 320ms orig(01).wav"],
            ["melodies 320ms diff(24).wav", "melodies 320ms orig(24).wav"],
            ["melodies 320ms orig(33).wav"],
            ["melodies 320ms orig(46).wav"],
            ["melodies 320ms orig(05).wav"],
            ["melodies 320ms orig(17).wav"],
            ["melodies 320ms diff(40).wav", "melodies 320ms orig(40).wav"],
            ["melodies 320ms diff(85).wav", "melodies 320ms orig(85).wav"],
            ["melodies 320ms diff(07).wav", "melodies 320ms orig(07).wav"],
            ["melodies 320ms diff(51).wav", "melodies 320ms orig(51).wav"],
            ["melodies 320ms diff(66).wav", "melodies 320ms orig(66).wav"],
            ["melodies 320ms diff(32).wav", "melodies 320ms orig(32).wav"],
            ["melodies 320ms orig(82).wav"],
            ["melodies 320ms orig(89).wav"],
            ["melodies 320ms orig(91).wav"],
            ["melodies 320ms orig(49).wav"],
            ["melodies 320ms diff(52).wav", "melodies 320ms orig(52).wav"],
            ["melodies 320ms orig(27).wav"],
            ["melodies 320ms diff(45).wav", "melodies 320ms orig(45).wav"],
            ["melodies 320ms diff(54).wav", "melodies 320ms orig(54).wav"],
            ["melodies 320ms orig(60).wav"],
            ["melodies 320ms diff(74).wav", "melodies 320ms orig(74).wav"],
            ["melodies 320ms orig(90).wav"],
            ["melodies 320ms diff(06).wav", "melodies 320ms orig(06).wav"]
        ]
        
        digitalSpanForwardPractice = "SPA-PRACTICE-FWD"
        digitalSpanForward = [
            "SPA-FWD-1",
            "SPA-FWD-2",
            "SPA-FWD-3",
            "SPA-FWD-4",
            "SPA-FWD-5",
            "SPA-FWD-6",
            "SPA-FWD-7",
            "SPA-FWD-8",
            "SPA-FWD-9",
            "SPA-FWD-10",
            "SPA-FWD-11",
            "SPA-FWD-12",
            "SPA-FWD-13",
            "SPA-FWD-14"
        ]
        
        digitalSpanBackwardPractice = "SPA-PRACTICE-BWD"
        digitalSpanBackward = [
            "SPA-BWD-1",
            "SPA-BWD-2",
            "SPA-BWD-3",
            "SPA-BWD-4",
            "SPA-BWD-5",
            "SPA-BWD-6",
            "SPA-BWD-7",
            "SPA-BWD-8",
            "SPA-BWD-9",
            "SPA-BWD-10",
            "SPA-BWD-11",
            "SPA-BWD-12",
            "SPA-BWD-13",
            "SPA-BWD-14"
        ]
        
        stroopVideos = [
            "STROOP_SPA_TASK1.mp4",
            "STROOP_SPA_TASK2.mp4",
            "STROOP_SPA_TASK3.mp4",
            "STROOP_SPA_TASK4.mp4"
        ]
        
        stroopTasks = [
            "STIMULI_1_SPA",
            "STIMULI_2&4_SPA",
            "STIMULI_3-1"
        ]
        
        namingTaskPractice = [
            "namingTaskPractice1en",
            "namingTaskPractice2en",
            "namingTaskPractice3en"
        ]
        namingTaskTask = [
            "namingTaskTask1en",
            "namingTaskTask2en",
            "namingTaskTask3en",
            "namingTaskTask4en",
            "namingTaskTask5en",
            "namingTaskTask6en",
            "namingTaskTask7en",
            "namingTaskTask8en",
            "namingTaskTask9en",
            "namingTaskTask10en",
            "namingTaskTask11en",
            "namingTaskTask12en",
            "namingTaskTask13en",
            "namingTaskTask14en",
            "namingTaskTask15en",
            "namingTaskTask16en",
            "namingTaskTask17en",
            "namingTaskTask18en",
            "namingTaskTask19en",
            "namingTaskTask20en"
        ]
        
        wordListRecognitions = [
            "SPA-1",
            "SPA-2",
            "SPA-3",
            "SPA-4",
            "SPA-5",
            "SPA-6",
            "SPA-7",
            "SPA-8",
            "SPA-9",
            "SPA-10",
            "SPA-11",
            "SPA-12",
            "SPA-13",
            "SPA-14",
            "SPA-15",
            "SPA-16",
            "SPA-17",
            "SPA-18",
            "SPA-19",
            "SPA-20",
            "SPA-21",
            "SPA-22",
            "SPA-23",
            "SPA-24",
            "SPA-25",
            "SPA-26",
            "SPA-27",
            "SPA-28",
            "SPA-29",
            "SPA-30",
            "SPA-31",
            "SPA-32",
            "SPA-33",
            "SPA-34",
            "SPA-35",
            "SPA-36",
            "SPA-37",
            "SPA-38",
            "SPA-39",
            "SPA-40",
            "SPA-41",
            "SPA-42",
            "SPA-43",
            "SPA-44"
        ]
        
        wordListTasks = [
            "List A SPA",
            "List B SPA"
        ]
    }
}
