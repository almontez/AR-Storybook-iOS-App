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
    
    // Changes color of button when pressed down - UI feature ONLY
    @IBAction func soundButtonPressedDown(_ sender: UIButton) {
        soundButton.backgroundColor = UIColor(red: 138/255, green: 255/255, blue: 138/255, alpha: 1.0)
    }
    
    // Play audio for tutorial
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        print("Guide View Sound Button Pressed")
        // change color of button back to gray when released
        soundButton.backgroundColor = .gray
    }
        
}
