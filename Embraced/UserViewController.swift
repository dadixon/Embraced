//
//  UserViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 12/27/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var startBtn: NavigationButton!
    
    let participant = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        if let language = participant.string(forKey: "TesterLanguage") {
            startBtn.setTitle("Start_Test".localized(lang: language), for: .normal)
        } else {
            startBtn.setTitle("Start Test", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startTest(_ sender: Any) {
//        saveImageDocumentDirectory()
        let vc = UserInputViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    func saveImageDocumentDirectory(){
        // Download form url
        let strurl = URL(string: "http://api.girlscouts.harryatwal.com/static_images/naming_task/task/Image01.jpg")
        let dtinternet = NSData(contentsOf: strurl!)
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Image01.jpg")
//        let image = UIImage(named: "apple.jpg")
        let image = UIImage(data: dtinternet! as Data)
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
}
