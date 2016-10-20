//
//  MOCAMMSETestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 9/2/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class MOCAMMSETestViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(MOCAMMSETestViewController.next(_:)))
        
        let url = URL (string: "http://girlscouts.harryatwal.com/MoCA_MMSE.php");
        let requestObj = URLRequest(url: url!);
        myWebView.loadRequest(requestObj);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    @IBAction func next(_ sender: AnyObject) {
//        var navigationArray = self.navigationController?.viewControllers
        
//        navigationArray?.remove(at: 0)
        
        let reyComplexFigureViewController:ReyComplexFigureViewController = ReyComplexFigureViewController()
//        navigationArray?.append(reyComplexFigureViewController)
        
        self.navigationController?.pushViewController(reyComplexFigureViewController, animated: true)
//        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }
}
