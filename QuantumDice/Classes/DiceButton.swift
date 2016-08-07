//
//  DiceButton.swift
//  QuantumDice
//
//  Created by Martin Walsh on 04/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit

enum Dice:Int {
    case d0 = 0, d2 = 2, d3 = 3, d4 = 4, d6 = 6, d8 = 8, d10 = 10, d12 = 12, d20 = 20, d100 = 100
}

class DiceButton: UIButton {
    
    var base = Dice.d0 {
        didSet {
            
            // Custom insets
            switch base {
            case Dice.d100:
                contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            case Dice.d10:
                contentEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 35, right: 25)
            case Dice.d4:
                contentEdgeInsets = UIEdgeInsets(top: 60, left: 25, bottom: 10, right: 25)
            default:
                contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
                break
            }
            
            // Background Image
            let diceImage = UIImage(named: "\(base)")?.imageWithRenderingMode(.AlwaysOriginal)
            let colorImage = tintedImageWithColor(UIColor(complementaryFlatColorOf:Constants.Skin.diceColor), image:diceImage!)
            setBackgroundImage(colorImage, forState: .Normal)
            imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            
            resetLabel()
        }
    }
    
    func resetLabel() {
        // Default label
        if base == Dice.d0 {
            setTitle("", forState: .Normal)
        } else {
            setTitle("\(base.rawValue)", forState: .Normal)
        }
    }
    
}
