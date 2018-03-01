//
//  DataManager.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/9/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import Foundation

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
    
    private func setEnData() {
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
        
        digitalSpanForwardPractice = "ENG-PRACTICE-FWD.mp3"
        digitalSpanForward = [
            "ENG-FWD-1.mp3",
            "ENG-FWD-2.mp3",
            "ENG-FWD-3.mp3",
            "ENG-FWD-4.mp3",
            "ENG-FWD-5.mp3",
            "ENG-FWD-6.mp3",
            "ENG-FWD-7.mp3",
            "ENG-FWD-8.mp3",
            "ENG-FWD-9.mp3",
            "ENG-FWD-10.mp3",
            "ENG-FWD-11.mp3",
            "ENG-FWD-12.mp3",
            "ENG-FWD-13.mp3",
            "ENG-FWD-14.mp3"
        ]
        
        digitalSpanBackwardPractice = "ENG-PRACTICE-BWD.mp3"
        digitalSpanBackward = [
            "ENG-BWD-1.mp3",
            "ENG-BWD-2.mp3",
            "ENG-BWD-3.mp3",
            "ENG-BWD-4.mp3",
            "ENG-BWD-5.mp3",
            "ENG-BWD-6.mp3",
            "ENG-BWD-7.mp3",
            "ENG-BWD-8.mp3",
            "ENG-BWD-9.mp3",
            "ENG-BWD-10.mp3",
            "ENG-BWD-11.mp3",
            "ENG-BWD-12.mp3",
            "ENG-BWD-13.mp3",
            "ENG-BWD-14.mp3"
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
            "namingTaskPractice1",
            "namingTaskPractice2",
            "namingTaskPractice3"
        ]
        namingTaskTask = [
            "namingTaskTask1",
            "namingTaskTask2",
            "namingTaskTask3",
            "namingTaskTask4",
            "namingTaskTask5",
            "namingTaskTask6",
            "namingTaskTask7",
            "namingTaskTask8",
            "namingTaskTask9",
            "namingTaskTask10",
            "namingTaskTask11",
            "namingTaskTask12",
            "namingTaskTask13",
            "namingTaskTask14",
            "namingTaskTask15",
            "namingTaskTask16",
            "namingTaskTask17",
            "namingTaskTask18",
            "namingTaskTask19",
            "namingTaskTask20"
        ]
        
        wordListRecognitions = [
            "ENG-1.mp3",
            "ENG-2.mp3",
            "ENG-3.mp3",
            "ENG-4.mp3",
            "ENG-5.mp3",
            "ENG-6.mp3",
            "ENG-7.mp3",
            "ENG-8.mp3",
            "ENG-9.mp3",
            "ENG-10.mp3",
            "ENG-11.mp3",
            "ENG-12.mp3",
            "ENG-13.mp3",
            "ENG-14.mp3",
            "ENG-15.mp3",
            "ENG-16.mp3",
            "ENG-17.mp3",
            "ENG-18.mp3",
            "ENG-19.mp3",
            "ENG-20.mp3",
            "ENG-21.mp3",
            "ENG-22.mp3",
            "ENG-23.mp3",
            "ENG-24.mp3",
            "ENG-25.mp3",
            "ENG-26.mp3",
            "ENG-27.mp3",
            "ENG-28.mp3",
            "ENG-29.mp3",
            "ENG-30.mp3",
            "ENG-31.mp3",
            "ENG-32.mp3",
            "ENG-33.mp3",
            "ENG-34.mp3",
            "ENG-35.mp3",
            "ENG-36.mp3",
            "ENG-37.mp3",
            "ENG-38.mp3",
            "ENG-39.mp3",
            "ENG-40.mp3",
            "ENG-41.mp3",
            "ENG-42.mp3",
            "ENG-43.mp3",
            "ENG-44.mp3"
        ]
        
        wordListTasks = [
            "List A ENG.mp3",
            "List B ENG.mp3"
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
        
        digitalSpanForwardPractice = "SPA-PRACTICE-FWD.mp3"
        digitalSpanForward = [
            "SPA-FWD-1.mp3",
            "SPA-FWD-2.mp3",
            "SPA-FWD-3.mp3",
            "SPA-FWD-4.mp3",
            "SPA-FWD-5.mp3",
            "SPA-FWD-6.mp3",
            "SPA-FWD-7.mp3",
            "SPA-FWD-8.mp3",
            "SPA-FWD-9.mp3",
            "SPA-FWD-10.mp3",
            "SPA-FWD-11.mp3",
            "SPA-FWD-12.mp3",
            "SPA-FWD-13.mp3",
            "SPA-FWD-14.mp3"
        ]
        
        digitalSpanBackwardPractice = "SPA-PRACTICE-BWD.mp3"
        digitalSpanBackward = [
            "SPA-BWD-1.mp3",
            "SPA-BWD-2.mp3",
            "SPA-BWD-3.mp3",
            "SPA-BWD-4.mp3",
            "SPA-BWD-5.mp3",
            "SPA-BWD-6.mp3",
            "SPA-BWD-7.mp3",
            "SPA-BWD-8.mp3",
            "SPA-BWD-9.mp3",
            "SPA-BWD-10.mp3",
            "SPA-BWD-11.mp3",
            "SPA-BWD-12.mp3",
            "SPA-BWD-13.mp3",
            "SPA-BWD-14.mp3"
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
            "STIMULI_3"
        ]
        
        namingTaskPractice = [
            "namingTaskPractice1",
            "namingTaskPractice2",
            "namingTaskPractice3"
        ]
        namingTaskTask = [
            "namingTaskTask1",
            "namingTaskTask2",
            "namingTaskTask3",
            "namingTaskTask4",
            "namingTaskTask5",
            "namingTaskTask6",
            "namingTaskTask7",
            "namingTaskTask8",
            "namingTaskTask9",
            "namingTaskTask10",
            "namingTaskTask11",
            "namingTaskTask12",
            "namingTaskTask13",
            "namingTaskTask14",
            "namingTaskTask15",
            "namingTaskTask16",
            "namingTaskTask17",
            "namingTaskTask18",
            "namingTaskTask19",
            "namingTaskTask20"
        ]
        
        wordListRecognitions = [
            "SPA-1.mp3",
            "SPA-2.mp3",
            "SPA-3.mp3",
            "SPA-4.mp3",
            "SPA-5.mp3",
            "SPA-6.mp3",
            "SPA-7.mp3",
            "SPA-8.mp3",
            "SPA-9.mp3",
            "SPA-10.mp3",
            "SPA-11.mp3",
            "SPA-12.mp3",
            "SPA-13.mp3",
            "SPA-14.mp3",
            "SPA-15.mp3",
            "SPA-16.mp3",
            "SPA-17.mp3",
            "SPA-18.mp3",
            "SPA-19.mp3",
            "SPA-20.mp3",
            "SPA-21.mp3",
            "SPA-22.mp3",
            "SPA-23.mp3",
            "SPA-24.mp3",
            "SPA-25.mp3",
            "SPA-26.mp3",
            "SPA-27.mp3",
            "SPA-28.mp3",
            "SPA-29.mp3",
            "SPA-30.mp3",
            "SPA-31.mp3",
            "SPA-32.mp3",
            "SPA-33.mp3",
            "SPA-34.mp3",
            "SPA-35.mp3",
            "SPA-36.mp3",
            "SPA-37.mp3",
            "SPA-38.mp3",
            "SPA-39.mp3",
            "SPA-40.mp3",
            "SPA-41.mp3",
            "SPA-42.mp3",
            "SPA-43.mp3",
            "SPA-44.mp3"
        ]
        
        wordListTasks = [
            "List A SPA.mp3",
            "List B SPA.mp3"
        ]
    }
}
