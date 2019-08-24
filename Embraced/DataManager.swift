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
    var rcftTasks = [String]()
    
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
            "ENG-FWD-01.mp3",
            "ENG-FWD-02.mp3",
            "ENG-FWD-03.mp3",
            "ENG-FWD-04.mp3",
            "ENG-FWD-05.mp3",
            "ENG-FWD-06.mp3",
            "ENG-FWD-07.mp3",
            "ENG-FWD-08.mp3",
            "ENG-FWD-09.mp3",
            "ENG-FWD-10.mp3",
            "ENG-FWD-11.mp3",
            "ENG-FWD-12.mp3",
            "ENG-FWD-13.mp3",
            "ENG-FWD-14.mp3"
        ]
        
        digitalSpanBackwardPractice = "ENG-PRACTICE-BWD.mp3"
        digitalSpanBackward = [
            "ENG-BWD-01.mp3",
            "ENG-BWD-02.mp3",
            "ENG-BWD-03.mp3",
            "ENG-BWD-04.mp3",
            "ENG-BWD-05.mp3",
            "ENG-BWD-06.mp3",
            "ENG-BWD-07.mp3",
            "ENG-BWD-08.mp3",
            "ENG-BWD-09.mp3",
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
            "ENG-01.mp3",
            "ENG-02.mp3",
            "ENG-03.mp3",
            "ENG-04.mp3",
            "ENG-05.mp3",
            "ENG-06.mp3",
            "ENG-07.mp3",
            "ENG-08.mp3",
            "ENG-09.mp3",
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
        
        rcftTasks = [
            "RCFT1",
            "RCFT2",
            "RCFT3",
            "RCFT4",
            "RCFT5",
            "RCFT6",
            "RCFT7",
            "RCFT8",
            "RCFT9",
            "RCFT10",
            "RCFT11",
            "RCFT12",
            "RCFT13",
            "RCFT14",
            "RCFT15",
            "RCFT16",
            "RCFT17",
            "RCFT18",
            "RCFT19",
            "RCFT20",
            "RCFT21",
            "RCFT22",
            "RCFT23",
            "RCFT24"
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
            "SPA-FWD-01.mp3",
            "SPA-FWD-02.mp3",
            "SPA-FWD-03.mp3",
            "SPA-FWD-04.mp3",
            "SPA-FWD-05.mp3",
            "SPA-FWD-06.mp3",
            "SPA-FWD-07.mp3",
            "SPA-FWD-08.mp3",
            "SPA-FWD-09.mp3",
            "SPA-FWD-10.mp3",
            "SPA-FWD-11.mp3",
            "SPA-FWD-12.mp3",
            "SPA-FWD-13.mp3",
            "SPA-FWD-14.mp3"
        ]
        
        digitalSpanBackwardPractice = "SPA-PRACTICE-BWD.mp3"
        digitalSpanBackward = [
            "SPA-BWD-01.mp3",
            "SPA-BWD-02.mp3",
            "SPA-BWD-03.mp3",
            "SPA-BWD-04.mp3",
            "SPA-BWD-05.mp3",
            "SPA-BWD-06.mp3",
            "SPA-BWD-07.mp3",
            "SPA-BWD-08.mp3",
            "SPA-BWD-09.mp3",
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
            "SPA-01.mp3",
            "SPA-02.mp3",
            "SPA-03.mp3",
            "SPA-04.mp3",
            "SPA-05.mp3",
            "SPA-06.mp3",
            "SPA-07.mp3",
            "SPA-08.mp3",
            "SPA-09.mp3",
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
        
        rcftTasks = [
            "RCFT1",
            "RCFT2",
            "RCFT3",
            "RCFT4",
            "RCFT5",
            "RCFT6",
            "RCFT7",
            "RCFT8",
            "RCFT9",
            "RCFT10",
            "RCFT11",
            "RCFT12",
            "RCFT13",
            "RCFT14",
            "RCFT15",
            "RCFT16",
            "RCFT17",
            "RCFT18",
            "RCFT19",
            "RCFT20",
            "RCFT21",
            "RCFT22",
            "RCFT23",
            "RCFT24"
        ]
    }
}
