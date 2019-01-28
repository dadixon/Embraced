//
//  ActiveStepViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class ActiveStepViewController: InstructionsViewController {

    let contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(contentView)
        
        instructionsLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -16.0).isActive = true
        
        contentView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 16.0).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: nextBtn.topAnchor, constant: -16.0).isActive = true
        
        nextBtn.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16.0).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
