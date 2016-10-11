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
    @IBOutlet var trial2View: UIView!
    @IBOutlet var trial3View: UIView!
    @IBOutlet var trial4View: UIView!
    @IBOutlet var trial5View: UIView!
    @IBOutlet var taskView: UIView!
    
    @IBOutlet weak var example1Label: UILabel!
    @IBOutlet weak var example2Label: UILabel!
    @IBOutlet weak var example3Label: UILabel!
    
    
    
    var soundPlayer: AVAudioPlayer!
    var stimuli = [String: Any]()
    var examples = Array<Array<String>>()
    var trials = Array<Array<String>>()
    var tasks = Array<Array<String>>()
    
    
    var firstSound = String()
    var secondSound = String()
    var soundLabel = UILabel()
    
    
    
    
    
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
        trial2View.translatesAutoresizingMaskIntoConstraints = false
        trial3View.translatesAutoresizingMaskIntoConstraints = false
        trial4View.translatesAutoresizingMaskIntoConstraints = false
        trial5View.translatesAutoresizingMaskIntoConstraints = false
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
        
        if examples[0].count > 1 {
            firstSound = examples[0][0]
            secondSound = examples[0][1]
        } else if examples[0].count == 1 {
            firstSound = examples[0][0]
            secondSound = examples[0][0]
        }
        
        let url = NSURL(string: firstSound)
        downloadFileFromURL(url: url!)
        soundLabel = example1Label
    }
    
    @IBAction func moveToExample2(_ sender: AnyObject) {
        setSubview(example1View, next: example2View)
        
        if examples[1].count > 1 {
            firstSound = examples[1][0]
            secondSound = examples[1][1]
        } else if examples[1].count == 1 {
            firstSound = examples[1][0]
            secondSound = examples[1][0]
        }
        
        let url = NSURL(string: firstSound)
        downloadFileFromURL(url: url!)
        soundLabel = example2Label
    }
    
    @IBAction func moveToExample3(_ sender: AnyObject) {
        setSubview(example2View, next: example3View)
        
        if examples[2].count > 1 {
            firstSound = examples[2][0]
            secondSound = examples[2][1]
        } else if examples[2].count == 1 {
            firstSound = examples[2][0]
            secondSound = examples[2][0]
        }
        
        let url = NSURL(string: firstSound)
        downloadFileFromURL(url: url!)
        soundLabel = example3Label
    }
    
    
    
    
    
    // MARK: - Delegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.firstSound != "" {
                self.soundLabel.text = "2"
                let url = NSURL(string: self.secondSound)
                self.downloadFileFromURL(url: url!)
            }
        
            self.firstSound = ""
        }
    }
    
}
