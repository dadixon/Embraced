//
//  RCFTPracticeViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/3/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import UIKit

class RCFTPracticeViewController: ActiveStepViewController {
    
    let canvas: CanvasView = {
        var canvasView = CanvasView()
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.layer.borderColor = UIColor.black.cgColor
        canvasView.layer.borderWidth = 0.5
        canvasView.isUserInteractionEnabled = true
        return canvasView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orientation = .landscapeLeft
        rotateOrientation = .landscapeLeft
        
        instructionsLabel.text = "rcft_1_instructions_2".localized(lang: language)
        
        nextBtn.setTitle("Next".localized(lang: language), for: .normal)
        nextBtn.addTarget(self, action: #selector(moveOn), for: .touchUpInside)
        
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(canvas)
        
        canvas.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        canvas.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        canvas.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @objc func moveOn() {
//        self.performSegue(withIdentifier: "moveToInstructions", sender: nil)
        let vc = RCFTInstructions2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
