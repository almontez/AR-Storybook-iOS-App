//
//  HighlightedButton.swift
//  AR-Storybook
//
//  Created by Angela Li Montez on 1/31/23.
//
//  Code Citation
//  Date: 01/31/2023
//  Title: "Highlight a button when Pressed in Swift
//  URL: https://stackoverflow.com/questions/48880031/highlight-a-button-when-pressed-in-swift

import UIKit

class HighlightedButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .gray : .yellow
        }
    }
}
