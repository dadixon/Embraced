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
    var rcftFigure = String()
    var comprehensionSounds = [String]()
    var eyesTestImages = [String]()
    var eyesTestChoices = [[EyeAnswerInfo]]()
    var matricesStimuli = [MatricesTask]()
    var motorTask = [String]()
    var trailMaking = [String]()
    
    private init() {
        motorTask = [
            "Marcado.png",
            "Punteado.png",
            "Trazado.png"
        ]
        
        trailMaking = [
            "TrailPartA.png",
            "TrailPartB.png"
        ]
        
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
        
        rcftTasks = [
            "RCFT #1.png",
            "RCFT #2.png",
            "RCFT #3.png",
            "RCFT #4.png",
            "RCFT #5.png",
            "RCFT #6.png",
            "RCFT #7.png",
            "RCFT #8.png",
            "RCFT #9.png",
            "RCFT #10.png",
            "RCFT #11.png",
            "RCFT #12.png",
            "RCFT #13.png",
            "RCFT #14.png",
            "RCFT #15.png",
            "RCFT #16.png",
            "RCFT #17.png",
            "RCFT #18.png",
            "RCFT #19.png",
            "RCFT #20.png",
            "RCFT #21.png",
            "RCFT #22.png",
            "RCFT #23.png",
            "RCFT #24.png"
        ]
        
        rcftFigure = "RCFT Copy Figure.png"
        
        eyesTestImages = [
            "0.jpg",
            "1.jpg",
            "2.jpg",
            "3.jpg",
            "4.jpg",
            "5.jpg",
            "6.jpg",
            "7.jpg",
            "8.jpg",
            "9.jpg",
            "10.jpg",
            "11.jpg",
            "12.jpg",
            "13.jpg",
            "14.jpg",
            "15.jpg",
            "16.jpg",
            "17.jpg",
            "18.jpg",
            "19.jpg",
            "20.jpg",
            "21.jpg",
            "22.jpg",
            "23.jpg",
            "24.jpg",
            "25.jpg",
            "26.jpg",
            "27.jpg",
            "28.jpg",
            "29.jpg",
            "30.jpg",
            "31.jpg",
            "32.jpg",
            "33.jpg",
            "34.jpg",
            "35.jpg",
            "36.jpg"
        ]
        
        eyesTestChoices.append([
            EyeAnswerInfo(title: "hateful".localized(lang: language), definition: "hateful_def".localized(lang: language), example: "hateful_example".localized(lang: language)),
            EyeAnswerInfo(title: "jealous".localized(lang: language), definition: "jealous_def".localized(lang: language), example: "jealous_example".localized(lang: language)),
            EyeAnswerInfo(title: "arrogant".localized(lang: language), definition: "arrogant_def".localized(lang: language), example: "arrogant_example".localized(lang: language)),
            EyeAnswerInfo(title: "panicked".localized(lang: language), definition: "panicked_def".localized(lang: language), example: "panicked_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "playful".localized(lang: language), definition: "playful_def".localized(lang: language), example: "playful_example".localized(lang: language)),
            EyeAnswerInfo(title: "comforting".localized(lang: language), definition: "comforting_def".localized(lang: language), example: "comforting_example".localized(lang: language)),
            EyeAnswerInfo(title: "irritated".localized(lang: language), definition: "irritated_def".localized(lang: language), example: "irritated_example".localized(lang: language)),
            EyeAnswerInfo(title: "bored".localized(lang: language), definition: "bored_def".localized(lang: language), example: "bored_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "arrogant".localized(lang: language), definition: "arrogant_def".localized(lang: language), example: "arrogant_example".localized(lang: language)),
            EyeAnswerInfo(title: "annoyed".localized(lang: language), definition: "annoyed_def".localized(lang: language), example: "annoyed_example".localized(lang: language)),
            EyeAnswerInfo(title: "upset".localized(lang: language), definition: "upset_def".localized(lang: language), example: "upset_example".localized(lang: language)),
            EyeAnswerInfo(title: "terrified".localized(lang: language), definition: "terrified_def".localized(lang: language), example: "terrified_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "convinced".localized(lang: language), definition: "convinced_def".localized(lang: language), example: "convinced_example".localized(lang: language)),
            EyeAnswerInfo(title: "flustered".localized(lang: language), definition: "flustered_def".localized(lang: language), example: "flustered_example".localized(lang: language)),
            EyeAnswerInfo(title: "desire".localized(lang: language), definition: "desire_def".localized(lang: language), example: "desire_example".localized(lang: language)),
            EyeAnswerInfo(title: "joking".localized(lang: language), definition: "joking_def".localized(lang: language), example: "joking_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "amused".localized(lang: language), definition: "amused_def".localized(lang: language), example: "amused_example".localized(lang: language)),
            EyeAnswerInfo(title: "relaxed".localized(lang: language), definition: "relaxed_def".localized(lang: language), example: "relaxed_example".localized(lang: language)),
            EyeAnswerInfo(title: "joking".localized(lang: language), definition: "joking_def".localized(lang: language), example: "joking_example".localized(lang: language)),
            EyeAnswerInfo(title: "insisting".localized(lang: language), definition: "insisting_def".localized(lang: language), example: "insisting_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "friendly".localized(lang: language), definition: "friendly_def".localized(lang: language), example: "friendly_example".localized(lang: language)),
            EyeAnswerInfo(title: "irritated".localized(lang: language), definition: "irritated_def".localized(lang: language), example: "irritated_example".localized(lang: language)),
            EyeAnswerInfo(title: "worried".localized(lang: language), definition: "worried_def".localized(lang: language), example: "worried_example".localized(lang: language)),
            EyeAnswerInfo(title: "sarcastic".localized(lang: language), definition: "sarcastic_def".localized(lang: language), example: "sarcastic_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "fantasizing".localized(lang: language), definition: "fantasizing_def".localized(lang: language), example: "fantasizing_example".localized(lang: language)),
            EyeAnswerInfo(title: "alarmed".localized(lang: language), definition: "alarmed_def".localized(lang: language), example: "alarmed_example".localized(lang: language)),
            EyeAnswerInfo(title: "aghast".localized(lang: language), definition: "aghast_def".localized(lang: language), example: "aghast_example".localized(lang: language)),
            EyeAnswerInfo(title: "impatient".localized(lang: language), definition: "impatient_def".localized(lang: language), example: "impatient_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "uneasy".localized(lang: language), definition: "uneasy_def".localized(lang: language), example: "uneasy_example".localized(lang: language)),
            EyeAnswerInfo(title: "friendly".localized(lang: language), definition: "friendly_def".localized(lang: language), example: "friendly_example".localized(lang: language)),
            EyeAnswerInfo(title: "apologetic".localized(lang: language), definition: "apologetic_def".localized(lang: language), example: "apologetic_example".localized(lang: language)),
            EyeAnswerInfo(title: "dispirited".localized(lang: language), definition: "dispirited_def".localized(lang: language), example: "dispirited_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "excited".localized(lang: language), definition: "excited_def".localized(lang: language), example: "excited_example".localized(lang: language)),
            EyeAnswerInfo(title: "relieved".localized(lang: language), definition: "relieved_def".localized(lang: language), example: "relieved_example".localized(lang: language)),
            EyeAnswerInfo(title: "shy".localized(lang: language), definition: "shy_def".localized(lang: language), example: "shy_example".localized(lang: language)),
            EyeAnswerInfo(title: "despondent".localized(lang: language), definition: "despondent_def".localized(lang: language), example: "despondent_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "annoyed".localized(lang: language), definition: "annoyed_def".localized(lang: language), example: "annoyed_example".localized(lang: language)),
            EyeAnswerInfo(title: "hostile".localized(lang: language), definition: "hostile_def".localized(lang: language), example: "hostile_example".localized(lang: language)),
            EyeAnswerInfo(title: "horrified".localized(lang: language), definition: "horrified_def".localized(lang: language), example: "horrified_example".localized(lang: language)),
            EyeAnswerInfo(title: "preoccupied".localized(lang: language), definition: "preoccupied_def".localized(lang: language), example: "preoccupied_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "cautious".localized(lang: language), definition: "cautious_def".localized(lang: language), example: "cautious_example".localized(lang: language)),
            EyeAnswerInfo(title: "bored".localized(lang: language), definition: "bored_def".localized(lang: language), example: "bored_example".localized(lang: language)),
            EyeAnswerInfo(title: "aghast".localized(lang: language), definition: "aghast_def".localized(lang: language), example: "aghast_example".localized(lang: language)),
            EyeAnswerInfo(title: "insisting".localized(lang: language), definition: "insisting_def".localized(lang: language), example: "insisting_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "terrified".localized(lang: language), definition: "terrified_def".localized(lang: language), example: "terrified_example".localized(lang: language)),
            EyeAnswerInfo(title: "flirtatious".localized(lang: language), definition: "flirtatious_def".localized(lang: language), example: "flirtatious_example".localized(lang: language)),
            EyeAnswerInfo(title: "amused".localized(lang: language), definition: "amused_def".localized(lang: language), example: "amused_example".localized(lang: language)),
            EyeAnswerInfo(title: "regretful".localized(lang: language), definition: "regretful_def".localized(lang: language), example: "regretful_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "skeptical".localized(lang: language), definition: "skeptical_def".localized(lang: language), example: "skeptical_example".localized(lang: language)),
            EyeAnswerInfo(title: "embarrassed".localized(lang: language), definition: "embarrassed_def".localized(lang: language), example: "embarrassed_example".localized(lang: language)),
            EyeAnswerInfo(title: "dispirited".localized(lang: language), definition: "dispirited_def".localized(lang: language), example: "dispirited_example".localized(lang: language)),
            EyeAnswerInfo(title: "indifferent".localized(lang: language), definition: "indifferent_def".localized(lang: language), example: "indifferent_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "shy".localized(lang: language), definition: "shy_def".localized(lang: language), example: "shy_example".localized(lang: language)),
            EyeAnswerInfo(title: "decisive".localized(lang: language), definition: "decisive_def".localized(lang: language), example: "decisive_example".localized(lang: language)),
            EyeAnswerInfo(title: "threatening".localized(lang: language), definition: "threatening_def".localized(lang: language), example: "threatening_example".localized(lang: language)),
            EyeAnswerInfo(title: "anticipating".localized(lang: language), definition: "anticipating_def".localized(lang: language), example: "anticipating_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "irritated".localized(lang: language), definition: "irritated_def".localized(lang: language), example: "irritated_example".localized(lang: language)),
            EyeAnswerInfo(title: "disappointed".localized(lang: language), definition: "disappointed_def".localized(lang: language), example: "disappointed_example".localized(lang: language)),
            EyeAnswerInfo(title: "depressed".localized(lang: language), definition: "depressed_def".localized(lang: language), example: "depressed_example".localized(lang: language)),
            EyeAnswerInfo(title: "accusing".localized(lang: language), definition: "accusing_def".localized(lang: language), example: "accusing_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "encouraging".localized(lang: language), definition: "encouraging_def".localized(lang: language), example: "encouraging_example".localized(lang: language)),
            EyeAnswerInfo(title: "amused".localized(lang: language), definition: "amused_def".localized(lang: language), example: "amused_example".localized(lang: language)),
            EyeAnswerInfo(title: "flustered".localized(lang: language), definition: "flustered_def".localized(lang: language), example: "flustered_example".localized(lang: language)),
            EyeAnswerInfo(title: "contemplative".localized(lang: language), definition: "contemplative_def".localized(lang: language), example: "contemplative_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "thoughtful".localized(lang: language), definition: "hateful_def".localized(lang: language), example: "hateful_example".localized(lang: language)),
            EyeAnswerInfo(title: "irritated".localized(lang: language), definition: "irritated_def".localized(lang: language), example: "irritated_example".localized(lang: language)),
            EyeAnswerInfo(title: "encouraging".localized(lang: language), definition: "encouraging_def".localized(lang: language), example: "encouraging_example".localized(lang: language)),
            EyeAnswerInfo(title: "sympathetic".localized(lang: language), definition: "sympathetic_def".localized(lang: language), example: "sympathetic_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "playful".localized(lang: language), definition: "playful_def".localized(lang: language), example: "playful_example".localized(lang: language)),
            EyeAnswerInfo(title: "affectionate".localized(lang: language), definition: "affectionate_def".localized(lang: language), example: "affectionate_example".localized(lang: language)),
            EyeAnswerInfo(title: "aghast".localized(lang: language), definition: "aghast_def".localized(lang: language), example: "aghast_example".localized(lang: language)),
            EyeAnswerInfo(title: "doubtful".localized(lang: language), definition: "doubtful_def".localized(lang: language), example: "doubtful_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "amused".localized(lang: language), definition: "amused_def".localized(lang: language), example: "amused_example".localized(lang: language)),
            EyeAnswerInfo(title: "bored".localized(lang: language), definition: "bored_def".localized(lang: language), example: "bored_example".localized(lang: language)),
            EyeAnswerInfo(title: "decisive".localized(lang: language), definition: "decisive_def".localized(lang: language), example: "decisive_example".localized(lang: language)),
            EyeAnswerInfo(title: "aghast".localized(lang: language), definition: "aghast_def".localized(lang: language), example: "aghast_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "arrogant".localized(lang: language), definition: "arrogant_def".localized(lang: language), example: "arrogant_example".localized(lang: language)),
            EyeAnswerInfo(title: "grateful".localized(lang: language), definition: "grateful_def".localized(lang: language), example: "grateful_example".localized(lang: language)),
            EyeAnswerInfo(title: "tentative".localized(lang: language), definition: "tentative_def".localized(lang: language), example: "tentative_example".localized(lang: language)),
            EyeAnswerInfo(title: "sarcastic".localized(lang: language), definition: "sarcastic_def".localized(lang: language), example: "sarcastic_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "friendly".localized(lang: language), definition: "friendly_def".localized(lang: language), example: "friendly_example".localized(lang: language)),
            EyeAnswerInfo(title: "horrified".localized(lang: language), definition: "horrified_def".localized(lang: language), example: "horrified_example".localized(lang: language)),
            EyeAnswerInfo(title: "guilty".localized(lang: language), definition: "guilty_def".localized(lang: language), example: "guilty_example".localized(lang: language)),
            EyeAnswerInfo(title: "dominant".localized(lang: language), definition: "dominant_def".localized(lang: language), example: "dominant_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "panicked".localized(lang: language), definition: "panicked_def".localized(lang: language), example: "panicked_example".localized(lang: language)),
            EyeAnswerInfo(title: "fantasizing".localized(lang: language), definition: "fantasizing_def".localized(lang: language), example: "fantasizing_example".localized(lang: language)),
            EyeAnswerInfo(title: "confused".localized(lang: language), definition: "confused_def".localized(lang: language), example: "confused_example".localized(lang: language)),
            EyeAnswerInfo(title: "embarrassed".localized(lang: language), definition: "embarrassed_def".localized(lang: language), example: "embarrassed_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "preoccupied".localized(lang: language), definition: "preoccupied_def".localized(lang: language), example: "preoccupied_example".localized(lang: language)),
            EyeAnswerInfo(title: "insisting".localized(lang: language), definition: "insisting_def".localized(lang: language), example: "insisting_example".localized(lang: language)),
            EyeAnswerInfo(title: "imploring".localized(lang: language), definition: "imploring_def".localized(lang: language), example: "imploring_example".localized(lang: language)),
            EyeAnswerInfo(title: "grateful".localized(lang: language), definition: "grateful_def".localized(lang: language), example: "grateful_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "curious".localized(lang: language), definition: "curious_def".localized(lang: language), example: "curious_example".localized(lang: language)),
            EyeAnswerInfo(title: "apologetic".localized(lang: language), definition: "apologetic_def".localized(lang: language), example: "apologetic_example".localized(lang: language)),
            EyeAnswerInfo(title: "contended".localized(lang: language), definition: "contended_def".localized(lang: language), example: "contended_example".localized(lang: language)),
            EyeAnswerInfo(title: "defiant".localized(lang: language), definition: "defiant_def".localized(lang: language), example: "defiant_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "pensive".localized(lang: language), definition: "pensive_def".localized(lang: language), example: "pensive_example".localized(lang: language)),
            EyeAnswerInfo(title: "irritated".localized(lang: language), definition: "irritated_def".localized(lang: language), example: "irritated_example".localized(lang: language)),
            EyeAnswerInfo(title: "excited".localized(lang: language), definition: "excited_def".localized(lang: language), example: "excited_example".localized(lang: language)),
            EyeAnswerInfo(title: "hostile".localized(lang: language), definition: "hostile_def".localized(lang: language), example: "hostile_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "incredulous".localized(lang: language), definition: "incredulous_def".localized(lang: language), example: "incredulous_example".localized(lang: language)),
            EyeAnswerInfo(title: "panicked".localized(lang: language), definition: "panicked_def".localized(lang: language), example: "panicked_example".localized(lang: language)),
            EyeAnswerInfo(title: "interested".localized(lang: language), definition: "interested_def".localized(lang: language), example: "interested_example".localized(lang: language)),
            EyeAnswerInfo(title: "despondent".localized(lang: language), definition: "despondent_def".localized(lang: language), example: "despondent_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "alarmed".localized(lang: language), definition: "alarmed_def".localized(lang: language), example: "alarmed_example".localized(lang: language)),
            EyeAnswerInfo(title: "anxious".localized(lang: language), definition: "anxious_def".localized(lang: language), example: "anxious_example".localized(lang: language)),
            EyeAnswerInfo(title: "shy".localized(lang: language), definition: "shy_def".localized(lang: language), example: "shy_example".localized(lang: language)),
            EyeAnswerInfo(title: "hostile".localized(lang: language), definition: "hostile_def".localized(lang: language), example: "hostile_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "arrogant".localized(lang: language), definition: "arrogant_def".localized(lang: language), example: "arrogant_example".localized(lang: language)),
            EyeAnswerInfo(title: "cautious".localized(lang: language), definition: "cautious_def".localized(lang: language), example: "cautious_example".localized(lang: language)),
            EyeAnswerInfo(title: "reassuring".localized(lang: language), definition: "reassuring_def".localized(lang: language), example: "reassuring_example".localized(lang: language)),
            EyeAnswerInfo(title: "joking".localized(lang: language), definition: "joking_def".localized(lang: language), example: "joking_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "affectionate".localized(lang: language), definition: "affectionate_def".localized(lang: language), example: "affectionate_example".localized(lang: language)),
            EyeAnswerInfo(title: "joking".localized(lang: language), definition: "joking_def".localized(lang: language), example: "joking_example".localized(lang: language)),
            EyeAnswerInfo(title: "interested".localized(lang: language), definition: "interested_def".localized(lang: language), example: "interested_example".localized(lang: language)),
            EyeAnswerInfo(title: "contented".localized(lang: language), definition: "contented_def".localized(lang: language), example: "contented_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "impatient".localized(lang: language), definition: "impatient_def".localized(lang: language), example: "impatient_example".localized(lang: language)),
            EyeAnswerInfo(title: "aghast".localized(lang: language), definition: "aghast_def".localized(lang: language), example: "aghast_example".localized(lang: language)),
            EyeAnswerInfo(title: "irritated".localized(lang: language), definition: "irritated_def".localized(lang: language), example: "irritated_example".localized(lang: language)),
            EyeAnswerInfo(title: "reflective".localized(lang: language), definition: "reflective_def".localized(lang: language), example: "reflective_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "flirtatious".localized(lang: language), definition: "flirtatious_def".localized(lang: language), example: "flirtatious_example".localized(lang: language)),
            EyeAnswerInfo(title: "disappointed".localized(lang: language), definition: "disappointed_def".localized(lang: language), example: "disappointed_example".localized(lang: language)),
            EyeAnswerInfo(title: "hostile".localized(lang: language), definition: "hostile_def".localized(lang: language), example: "hostile_example".localized(lang: language)),
            EyeAnswerInfo(title: "grateful".localized(lang: language), definition: "grateful_def".localized(lang: language), example: "grateful_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "joking".localized(lang: language), definition: "joking_def".localized(lang: language), example: "joking_example".localized(lang: language)),
            EyeAnswerInfo(title: "ashamed".localized(lang: language), definition: "ashamed_def".localized(lang: language), example: "ashamed_example".localized(lang: language)),
            EyeAnswerInfo(title: "confident".localized(lang: language), definition: "confident_def".localized(lang: language), example: "confident_example".localized(lang: language)),
            EyeAnswerInfo(title: "dispirited".localized(lang: language), definition: "dispirited_def".localized(lang: language), example: "dispirited_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "ashamed".localized(lang: language), definition: "ashamed_def".localized(lang: language), example: "ashamed_example".localized(lang: language)),
            EyeAnswerInfo(title: "bewildered".localized(lang: language), definition: "bewildered_def".localized(lang: language), example: "bewildered_example".localized(lang: language)),
            EyeAnswerInfo(title: "alarmed".localized(lang: language), definition: "alarmed_def".localized(lang: language), example: "alarmed_example".localized(lang: language)),
            EyeAnswerInfo(title: "serious".localized(lang: language), definition: "serious_def".localized(lang: language), example: "serious_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "concerned".localized(lang: language), definition: "concerned_def".localized(lang: language), example: "concerned_example".localized(lang: language)),
            EyeAnswerInfo(title: "embarrassed".localized(lang: language), definition: "embarrassed_def".localized(lang: language), example: "embarrassed_example".localized(lang: language)),
            EyeAnswerInfo(title: "guilty".localized(lang: language), definition: "guilty_def".localized(lang: language), example: "guilty_example".localized(lang: language)),
            EyeAnswerInfo(title: "fantasizing".localized(lang: language), definition: "fantasizing_def".localized(lang: language), example: "fantasizing_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "aghast".localized(lang: language), definition: "aghast_def".localized(lang: language), example: "aghast_example".localized(lang: language)),
            EyeAnswerInfo(title: "baffled".localized(lang: language), definition: "baffled_def".localized(lang: language), example: "baffled_example".localized(lang: language)),
            EyeAnswerInfo(title: "terrified".localized(lang: language), definition: "terrified_def".localized(lang: language), example: "terrified_example".localized(lang: language)),
            EyeAnswerInfo(title: "distrustful".localized(lang: language), definition: "distrustful_def".localized(lang: language), example: "distrustful_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "nervous".localized(lang: language), definition: "nervous_def".localized(lang: language), example: "nervous_example".localized(lang: language)),
            EyeAnswerInfo(title: "contemplative".localized(lang: language), definition: "contemplative_def".localized(lang: language), example: "contemplative_example".localized(lang: language)),
            EyeAnswerInfo(title: "insisting".localized(lang: language), definition: "insisting_def".localized(lang: language), example: "insisting_example".localized(lang: language)),
            EyeAnswerInfo(title: "puzzled".localized(lang: language), definition: "puzzled_def".localized(lang: language), example: "puzzled_example".localized(lang: language))
        ])
        eyesTestChoices.append([
            EyeAnswerInfo(title: "suspicious".localized(lang: language), definition: "suspicious_def".localized(lang: language), example: "suspicious_example".localized(lang: language)),
            EyeAnswerInfo(title: "nervous".localized(lang: language), definition: "nervous_def".localized(lang: language), example: "nervous_example".localized(lang: language)),
            EyeAnswerInfo(title: "ashamed".localized(lang: language), definition: "ashamed_def".localized(lang: language), example: "ashamed_example".localized(lang: language)),
            EyeAnswerInfo(title: "indecisive".localized(lang: language), definition: "indecisive_def".localized(lang: language), example: "indecisive_example".localized(lang: language))
        ])
        
        matricesStimuli = [
            MatricesTask(key: "A1", displayImageName: "A1.png", choices: [
                "A1-1.png",
                "A1-2.png",
                "A1-3.png",
                "A1-4.png",
                "A1-5.png",
                "A1-6.png"
            ]),
            MatricesTask(key: "A2", displayImageName: "A2.png", choices: [
                "A2-1.png",
                "A2-2.png",
                "A2-3.png",
                "A2-4.png",
                "A2-5.png",
                "A2-6.png"
            ]),
            MatricesTask(key: "A3", displayImageName: "A3.png", choices: [
                "A3-1.png",
                "A3-2.png",
                "A3-3.png",
                "A3-4.png",
                "A3-5.png",
                "A3-6.png"
            ]),
            MatricesTask(key: "A4", displayImageName: "A4.png", choices: [
                "A4-1.png",
                "A4-2.png",
                "A4-3.png",
                "A4-4.png",
                "A4-5.png",
                "A4-6.png"
            ]),
            MatricesTask(key: "A5", displayImageName: "A5.png", choices: [
                "A5-1.png",
                "A5-2.png",
                "A5-3.png",
                "A5-4.png",
                "A5-5.png",
                "A5-6.png"
            ]),
            MatricesTask(key: "A6", displayImageName: "A6.png", choices: [
                "A6-1.png",
                "A6-2.png",
                "A6-3.png",
                "A6-4.png",
                "A6-5.png",
                "A6-6.png"
            ]),
            MatricesTask(key: "A7", displayImageName: "A7.png", choices: [
                "A7-1.png",
                "A7-2.png",
                "A7-3.png",
                "A7-4.png",
                "A7-5.png",
                "A7-6.png"
            ]),
            MatricesTask(key: "A8", displayImageName: "A8.png", choices: [
                "A8-1.png",
                "A8-2.png",
                "A8-3.png",
                "A8-4.png",
                "A8-5.png",
                "A8-6.png"
            ]),
            MatricesTask(key: "A9", displayImageName: "A9.png", choices: [
                "A9-1.png",
                "A9-2.png",
                "A9-3.png",
                "A9-4.png",
                "A9-5.png",
                "A9-6.png"
            ]),
            MatricesTask(key: "A10", displayImageName: "A10.png", choices: [
                "A10-1.png",
                "A10-2.png",
                "A10-3.png",
                "A10-4.png",
                "A10-5.png",
                "A10-6.png"
            ]),
            MatricesTask(key: "A11", displayImageName: "A11.png", choices: [
                "A11-1.png",
                "A11-2.png",
                "A11-3.png",
                "A11-4.png",
                "A11-5.png",
                "A11-6.png"
            ]),
            MatricesTask(key: "A12", displayImageName: "A12.png", choices: [
                "A12-1.png",
                "A12-2.png",
                "A12-3.png",
                "A12-4.png",
                "A12-5.png",
                "A12-6.png"
            ]),
            MatricesTask(key: "B1", displayImageName: "B1.png", choices: [
                "B1-1.png",
                "B1-2.png",
                "B1-3.png",
                "B1-4.png",
                "B1-5.png",
                "B1-6.png"
            ]),
            MatricesTask(key: "B2", displayImageName: "B2.png", choices: [
                "B2-1.png",
                "B2-2.png",
                "B2-3.png",
                "B2-4.png",
                "B2-5.png",
                "B2-6.png"
            ]),
            MatricesTask(key: "B3", displayImageName: "B3.png", choices: [
                "B3-1.png",
                "B3-2.png",
                "B3-3.png",
                "B3-4.png",
                "B3-5.png",
                "B3-6.png"
            ]),
            MatricesTask(key: "B4", displayImageName: "B4.png", choices: [
                "B4-1.png",
                "B4-2.png",
                "B4-3.png",
                "B4-4.png",
                "B4-5.png",
                "B4-6.png"
            ]),
            MatricesTask(key: "B5", displayImageName: "B5.png", choices: [
                "B5-1.png",
                "B5-2.png",
                "B5-3.png",
                "B5-4.png",
                "B5-5.png",
                "B5-6.png"
            ]),
            MatricesTask(key: "B6", displayImageName: "B6.png", choices: [
                "B6-1.png",
                "B6-2.png",
                "B6-3.png",
                "B6-4.png",
                "B6-5.png",
                "B6-6.png"
            ]),
            MatricesTask(key: "B7", displayImageName: "B7.png", choices: [
                "B7-1.png",
                "B7-2.png",
                "B7-3.png",
                "B7-4.png",
                "B7-5.png",
                "B7-6.png"
            ]),
            MatricesTask(key: "B8", displayImageName: "B8.png", choices: [
                "B8-1.png",
                "B8-2.png",
                "B8-3.png",
                "B8-4.png",
                "B8-5.png",
                "B8-6.png"
            ]),
            MatricesTask(key: "B9", displayImageName: "B9.png", choices: [
                "B9-1.png",
                "B9-2.png",
                "B9-3.png",
                "B9-4.png",
                "B9-5.png",
                "B9-6.png"
            ]),
            MatricesTask(key: "B10", displayImageName: "B10.png", choices: [
                "B10-1.png",
                "B10-2.png",
                "B10-3.png",
                "B10-4.png",
                "B10-5.png",
                "B10-6.png"
            ]),
            MatricesTask(key: "B11", displayImageName: "B11.png", choices: [
                "B11-1.png",
                "B11-2.png",
                "B11-3.png",
                "B11-4.png",
                "B11-5.png",
                "B11-6.png"
            ]),
            MatricesTask(key: "B12", displayImageName: "B12.png", choices: [
                "B12-1.png",
                "B12-2.png",
                "B12-3.png",
                "B12-4.png",
                "B12-5.png",
                "B12-6.png"
            ]),
            MatricesTask(key: "C1", displayImageName: "C1.png", choices: [
                "C1-1.png",
                "C1-2.png",
                "C1-3.png",
                "C1-4.png",
                "C1-5.png",
                "C1-6.png",
                "C1-7.png",
                "C1-8.png"
            ])
        ]
        
        namingTaskPractice = [
            "Practice 1.jpg",
            "Practice 2.jpg",
            "Practice 3.jpg"
        ]
        
        namingTaskTask = [
            "Image 1.jpg",
            "Image 2.jpg",
            "Image 3.jpg",
            "Image 4.jpg",
            "Image 5.jpg",
            "Image 6.jpg",
            "Image 7.jpg",
            "Image 8.jpg",
            "Image 9.jpg",
            "Image 10.jpg",
            "Image 11.jpg",
            "Image 12.jpg",
            "Image 13.jpg",
            "Image 14.jpg",
            "Image 15.jpg",
            "Image 16.jpg",
            "Image 17.jpg",
            "Image 18.jpg",
            "Image 19.jpg",
            "Image 20.jpg"
        ]
    }
    
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
    
    func motorTaskFiles() -> [String] {
        return DataManager.sharedInstance.motorTask
    }
    
    func trailMakingFiles() -> [String] {
        return DataManager.sharedInstance.trailMaking
    }
    
    func comprehensionFiles(lang: String) -> [String] {
        DataManager.sharedInstance.language = lang
        DataManager.sharedInstance.updateData()
        
        return DataManager.sharedInstance.comprehensionSounds
    }
    
    func wordlistFiles(lang: String) -> [String] {
        var wordlistFiles = [String]()
        
        DataManager.sharedInstance.language = lang
        DataManager.sharedInstance.updateData()
        
        wordlistFiles += DataManager.sharedInstance.wordListTasks
        wordlistFiles += DataManager.sharedInstance.wordListRecognitions
        
        return wordlistFiles
    }
    
    func namingTaskFiles() -> [String] {
        var namingTaskFiles = [String]()
        
        namingTaskFiles += DataManager.sharedInstance.namingTaskPractice
        namingTaskFiles += DataManager.sharedInstance.namingTaskTask
        
        return namingTaskFiles
    }
    
    func stroopFiles(lang: String) -> [String] {
        var stroopFiles = [String]()
        
        DataManager.sharedInstance.language = lang
        DataManager.sharedInstance.updateData()
        
        stroopFiles += DataManager.sharedInstance.stroopVideos
        stroopFiles += DataManager.sharedInstance.stroopTasks
        
        return stroopFiles
    }
    
    func digitSpanFiles(lang: String) -> [String] {
        var digitSpan = [String]()
        
        DataManager.sharedInstance.language = lang
        DataManager.sharedInstance.updateData()

        digitSpan.append(DataManager.sharedInstance.digitalSpanForwardPractice)
        digitSpan.append(DataManager.sharedInstance.digitalSpanBackwardPractice)
        digitSpan += DataManager.sharedInstance.digitalSpanForward
        digitSpan += DataManager.sharedInstance.digitalSpanBackward
        
        return digitSpan
    }
    
    func pitchFiles() -> [String] {
        var pitchFiles = [String]()
        
        for file in DataManager.sharedInstance.pitchExamples {
            pitchFiles += file
        }
        
        for file in DataManager.sharedInstance.pitchPractices {
            pitchFiles += file
        }
        
        for file in DataManager.sharedInstance.pitchTasks {
            pitchFiles += file
        }
        
        return pitchFiles
    }
    
    func eyesFiles() -> [String] {
        return DataManager.sharedInstance.eyesTestImages
    }
    
    func matriceFiles() -> [String] {
        var matricesFiles = [String]()
        
        for task in DataManager.sharedInstance.matricesStimuli {
            matricesFiles.append(task.displayImageName)
            
            for choice in task.choices {
                matricesFiles.append(choice)
            }
        }
        
        return matricesFiles
    }
    
    func rcftFiles() -> [String] {
        var rcftFiles = [String]()
        
        rcftFiles = DataManager.sharedInstance.rcftTasks
        rcftFiles.append(DataManager.sharedInstance.rcftFigure)
        
        return rcftFiles
    }
    
    private func setEnData() {
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
            "STIMULI_1_ENG.png",
            "STIMULI_2&4_ENG.png",
            "STIMULI_3.png"
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
        
        comprehensionSounds = [
            "TOKEN-ENG-01.mp3",
            "TOKEN-ENG-02.mp3",
            "TOKEN-ENG-03.mp3",
            "TOKEN-ENG-04.mp3",
            "TOKEN-ENG-05.mp3",
            "TOKEN-ENG-06.mp3",
            "TOKEN-ENG-07.mp3",
            "TOKEN-ENG-08.mp3",
            "TOKEN-ENG-09.mp3",
            "TOKEN-ENG-10.mp3",
            "TOKEN-ENG-11.mp3",
            "TOKEN-ENG-12.mp3",
            "TOKEN-ENG-13.mp3",
            "TOKEN-ENG-14.mp3",
            "TOKEN-ENG-15.mp3",
            "TOKEN-ENG-16.mp3",
            "TOKEN-ENG-17.mp3",
            "TOKEN-ENG-18.mp3",
            "TOKEN-ENG-19.mp3",
            "TOKEN-ENG-20.mp3",
            "TOKEN-ENG-21.mp3"
        ]
    }
    
    private func setEsData() {
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
            "STIMULI_1_SPA.png",
            "STIMULI_2&4_SPA.png",
            "STIMULI_3.png"
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
        
        comprehensionSounds = [
            "TOKEN-SPA-01.mp3",
            "TOKEN-SPA-02.mp3",
            "TOKEN-SPA-03.mp3",
            "TOKEN-SPA-04.mp3",
            "TOKEN-SPA-05.mp3",
            "TOKEN-SPA-06.mp3",
            "TOKEN-SPA-07.mp3",
            "TOKEN-SPA-08.mp3",
            "TOKEN-SPA-09.mp3",
            "TOKEN-SPA-10.mp3",
            "TOKEN-SPA-11.mp3",
            "TOKEN-SPA-12.mp3",
            "TOKEN-SPA-13.mp3",
            "TOKEN-SPA-14.mp3",
            "TOKEN-SPA-15.mp3",
            "TOKEN-SPA-16.mp3",
            "TOKEN-SPA-17.mp3",
            "TOKEN-SPA-18.mp3",
            "TOKEN-SPA-19.mp3",
            "TOKEN-SPA-20.mp3",
            "TOKEN-SPA-21.mp3"
        ]
    }
}
