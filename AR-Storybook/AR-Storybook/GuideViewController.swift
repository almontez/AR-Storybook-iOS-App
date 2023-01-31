//
//  GuideViewController.swift
//  AR-Storybook
//
//  Created by Angela Li Montez on 1/30/23.
//

import UIKit

class GuideViewController: UIViewController {
    
    @IBOutlet var soundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Circle Button
        soundButton.layer.cornerRadius = soundButton.frame.width / 2
        soundButton.layer.masksToBounds = true
        
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        print("Guide View Sound Button Pressed")
    }
        
}
