//
//  OccupationViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 7/7/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class OccupationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        scrollView = UIScrollView(frame: view.bounds)
//        scrollView.backgroundColor = UIColor.blackColor()
//        scrollView.contentSize = contentView.bounds.size
//        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
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
