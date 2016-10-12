//
//  PitchViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/3/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import AVFoundation

class PitchViewController: FrontViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var introView: UIView!
    @IBOutlet var example1View: UIView!
    @IBOutlet var example2View: UIView!
    @IBOutlet var example3View: UIView!
    @IBOutlet var trial1View: UIView!
    @IBOutlet var preTaskView: UIView!
    @IBOutlet var taskView: UIView!
    
    @IBOutlet weak var example1Label: UILabel!
    @IBOutlet weak var example2Label: UILabel!
    @IBOutlet weak var example3Label: UILabel!
    
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    
    
    var soundPlayer: AVAudioPlayer!
    var stimuli = [String: Any]()
    var examples = Array<Array<String>>()
    var trials = Array<Array<String>>()
    var tasks = Array<Array<String>>()
    
    
    var firstSound = String()
    var secondSound = String()
    var soundLabel = UILabel()
    var played = false
    
    var trialCount = 0
    var tasksCount = 0
    
    
    
    // MARK: - Private
    
    private func setSubview(_ current: UIView, next: UIView) {
        current.removeFromSuperview()
        containerView.addSubview(next)
        
        let leftConstraint = next.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = next.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = next.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = next.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(PitchViewController.next(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(PitchViewController.back(_:)))
        
        introView.translatesAutoresizingMaskIntoConstraints = false
        example1View.translatesAutoresizingMaskIntoConstraints = false
        example2View.translatesAutoresizingMaskIntoConstraints = false
        example3View.translatesAutoresizingMaskIntoConstraints = false
        trial1View.translatesAutoresizingMaskIntoConstraints = false
        preTaskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(introView)
        
        let leftConstraint = introView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        let topConstraint = introView.topAnchor.constraint(equalTo: containerView.topAnchor)
        let rightConstraint = introView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        let bottomConstraint = introView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        NSLayoutConstraint.activate([leftConstraint, topConstraint, rightConstraint, bottomConstraint])
        
        // Fetch audios
        let requestURL: URL = URL(string: "http://api.girlscouts.harryatwal.com/pitch")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do {
                    self.stimuli = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any]
                    self.examples = self.stimuli["examples"] as! Array<Array<String>>
                    self.trials = self.stimuli["trials"] as! Array<Array<String>>
                    self.tasks = self.stimuli["tasks"] as! Array<Array<String>>
                } catch {
                    print("Error with Json: \(error)")
                }
            }
        })
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func play(_ url:NSURL) {
        print("playing \(url)")
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url as URL)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            soundPlayer.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    
    func downloadFileFromURL(url:NSURL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { (URL, response, error) -> Void in
            self.play(URL! as NSURL)
        })
        
        downloadTask.resume()
    }
    
    private func setupSounds(_ soundArray: Array<Array<String>>, iterator: Int, label: UILabel) {
        if soundPlayer != nil {
            soundPlayer.stop()
        }
        
        played = false
        
        if soundArray[iterator].count > 1 {
            firstSound = soundArray[iterator][0]
            secondSound = soundArray[iterator][1]
        } else if soundArray[iterator].count == 1 {
            firstSound = soundArray[iterator][0]
            secondSound = soundArray[iterator][0]
        }
        
        let url = NSURL(string: firstSound)
        downloadFileFromURL(url: url!)
        soundLabel = label
        
        print("Sound url \(firstSound)")
    }
    
    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
        let mOCAMMSETestViewController:WordListViewController = WordListViewController()
        self.navigationController?.pushViewController(mOCAMMSETestViewController, animated: true)
    }

    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func moveToExample(_ sender: AnyObject) {
        setSubview(introView, next: example1View)
        setupSounds(examples, iterator: 0, label: example1Label)
    }
    
    @IBAction func moveToExample2(_ sender: AnyObject) {
        setSubview(example1View, next: example2View)
        setupSounds(examples, iterator: 1, label: example2Label)
    }
    
    @IBAction func replay(_ sender: AnyObject) {
        played = false
        let url = NSURL(string: firstSound)
        downloadFileFromURL(url: url!)
        soundLabel.text = "1"
    }
    
    @IBAction func moveToExample3(_ sender: AnyObject) {
        setSubview(example2View, next: example3View)
        setupSounds(examples, iterator: 2, label: example3Label)
    }
    
    
    @IBAction func moveToTrial1(_ sender: AnyObject) {
        setSubview(example3View, next: trial1View)
        setupSounds(trials, iterator: trialCount, label: trialLabel)
        trialCount += 1
    }
    
    @IBAction func nextTrial(_ sender: AnyObject) {
        if trialCount < trials.count {
            // Save answer
        
            // Which label back to 1
            trialLabel.text = "1"
        
            // Set sounds to play
            setupSounds(trials, iterator: trialCount, label: trialLabel)
        
            trialCount += 1
        } else {
            setSubview(trial1View, next: preTaskView)
        }
    }
    
    @IBAction func moveToTask(_ sender: AnyObject) {
        setSubview(preTaskView, next: taskView)
        setupSounds(tasks, iterator: tasksCount, label: tasksLabel)
        tasksCount += 1
    }
    
    
    @IBAction func nextTask(_ sender: AnyObject) {
        if tasksCount < tasks.count {
            // Save answer
            
            // Which label back to 1
            tasksLabel.text = "1"
            
            // Set sounds to play
            setupSounds(tasks, iterator: tasksCount, label: tasksLabel)
            
            tasksCount += 1
        } else {
            let mOCAMMSETestViewController:WordListViewController = WordListViewController()
            self.navigationController?.pushViewController(mOCAMMSETestViewController, animated: true)
        }
    }
    
    
    
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.played == false {
                self.soundLabel.text = "2"
                let url = NSURL(string: self.secondSound)
                self.downloadFileFromURL(url: url!)
            }
        
            self.played = true
        }
    }
    
}