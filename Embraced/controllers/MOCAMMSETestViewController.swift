//
//  MOCAMMSETestViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/6/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class MOCAMMSETestViewController: FrontViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "http://girlscouts.harryatwal.com/MoCA_MMSE.php");
        let requestObj = NSURLRequest(URL: url!);
        myWebView.loadRequest(requestObj);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
