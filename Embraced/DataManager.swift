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
    
    var stimuli = [String: Any]()
    var namingTaskStimuli = [String: Any]()
    var digitalSpanStimuli = [String: Any]()
    var pitchStimuli = [String: Any]()
    var stroopStimuli = [String: Any]()
    var wordlistStimuli = [String: Any]()
    var practice = Array<String>()
    var task = Array<String>()
    var pitchExamples = Array<Array<String>>()
    var pitchTrials = Array<Array<String>>()
    var pitchTasks = Array<Array<String>>()
    var digitalSpanForward = Array<String>()
    var digitalSpanBackward = Array<String>()
    var wordListTrials = Array<String>()
    var wordListTasks = Array<String>()
    var stroopImages = Array<String>()
    var stroopVideos = Array<String>()
    var namingTaskPractice = Array<String>()
    var namingTaskTask = Array<String>()
    
    //MARK: Methods
    
    func fetchStimuli() {
        if Reachability.isConnectedToNetwork() == true {
            /* Preloading data  */
            let todoEndpoint: String = "http://api.girlscouts.harryatwal.com/stimuliNames"
            guard let url = URL(string: todoEndpoint) else {
                print("Error: cannot create URL")
                return
            }
            let urlRequest = URLRequest(url: url)
//            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
//            let session = URLSession.shared
//            let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                guard error == nil else {
                    print("error calling GET on stumiliNames")
                    print(error!)
                    return
                }
                // make sure we got data
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                if (statusCode == 200) {
                    print("Everyone is fine, file downloaded successfully.")
                    
                    do {
                        guard let todo = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
                            print("error trying to convert data to JSON")
                            return
                        }
                        
                        self.stimuli = todo
                        self.namingTaskStimuli = self.stimuli["naming_task"] as! [String: Any]
                        self.digitalSpanStimuli = self.stimuli["digital_span"] as! [String: Any]
                        self.pitchStimuli = self.stimuli["pitch"] as! [String: Any]
                        self.stroopStimuli = self.stimuli["stroop"] as! [String: Any]
                        self.wordlistStimuli = self.stimuli["wordlist"] as! [String: Any]
                        
                        // Pitch
                        self.pitchExamples = self.pitchStimuli["examples"] as! Array<Array<String>>
                        self.pitchTrials = self.pitchStimuli["trials"] as! Array<Array<String>>
                        self.pitchTasks = self.pitchStimuli["tasks"] as! Array<Array<String>>
                        
                        // Digital Span
                        self.digitalSpanForward = self.digitalSpanStimuli["forward"] as! Array<String>
                        self.digitalSpanBackward = self.digitalSpanStimuli["backward"] as! Array<String>
                        
                        // Word List
                        self.wordListTrials = self.wordlistStimuli["trials"] as! Array<String>
                        self.wordListTasks = self.wordlistStimuli["tasks"] as! Array<String>
                        
                        // Stroop
                        self.stroopImages = self.stroopStimuli["images"] as! Array<String>
                        self.stroopVideos = self.stroopStimuli["videos"] as! Array<String>
                        
                        // Naming Task
                        self.namingTaskPractice = self.namingTaskStimuli["practice"] as! Array<String>
                        self.namingTaskTask = self.namingTaskStimuli["tasks"] as! Array<String>
                        
                    }catch {
                        print("Error with Json: \(error)")
                        return
                    }
                }
            })
            
            task.resume()
        }
    }
}
