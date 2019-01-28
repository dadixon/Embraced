//
//  InstructionsViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/6/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    var language = String()
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        return label
    }()
    
    let instructionsLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let nextBtn: NavigationButton = {
        var button = NavigationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        language = userDefaults.string(forKey: "language")!
        
        navigationItem.hidesBackButton = true
        
        view.addSubview(titleLabel)
        view.addSubview(instructionsLabel)
        view.addSubview(nextBtn)
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30.0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: instructionsLabel.topAnchor, constant: -8.0).isActive = true
        
        instructionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0).isActive = true
        instructionsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30.0).isActive = true
        instructionsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30.0).isActive = true

        nextBtn.widthAnchor.constraint(equalToConstant: nextBtn.intrinsicContentSize.width + 30.0).isActive = true
        nextBtn.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        nextBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
 

}
