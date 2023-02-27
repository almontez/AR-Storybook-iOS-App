//
//  GuideViewController.swift
//  AR-Storybook
//
//  Created by Angela Li Montez on 1/30/23.
//

import UIKit
import AVFoundation

class GuideViewController: UIViewController {
    
    @IBOutlet var soundButton: UIButton!
    // Create a speech synthesizer
    let synthesizer = AVSpeechSynthesizer()
    
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
        if let path = Bundle.main.path(forResource: "tutorial", ofType: "txt") {
            do {
                // retrieve instructions from textfile
                let contents = try String(contentsOfFile: path)
                let lines = contents.components(separatedBy: .newlines)
                
                // initialize utterance for each line of text in tutorial.txt and have the synthesizer speak them
                for line in lines {
                    let utterance = AVSpeechUtterance(string: line)
                    utterance.rate = 0.45
                    utterance.volume = 0.8
                    utterance.postUtteranceDelay = 0.8
                    synthesizer.speak(utterance)
                }
            } catch {
                print(error)
            }
        }
        // Change color of button back to gray when released
        soundButton.backgroundColor = .gray
    }
        
}
