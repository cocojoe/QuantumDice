//
//  DiceView.swift
//  QuantumDice
//
//  Created by Martin Walsh on 07/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit
import LTMorphingLabel
import UIPicker

class DiceView: UIView {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var label: LTMorphingLabel!
    
    var pickerTapGesture:UITapGestureRecognizer!
    var optionBase:Dice = Dice.dSelect
    
    var startTimer:CFAbsoluteTime = 0
    var endTimer:CFAbsoluteTime = 0
    
    var base:Dice = Dice.d20 {
        didSet {
            setBackground(base)
            resetDice()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load XIB
        let xibView = NSBundle.mainBundle().loadNibNamed("DiceView", owner: self, options: nil)[0] as! UIView
        xibView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        xibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(xibView)
        
        // Transparent View
        self.backgroundColor = UIColor.clearColor()
        
        // Color / Morphing
        label.textColor = UIColor(contrastingBlackOrWhiteColorOn:Constants.Skin.backgroundColor, isFlat:true)
        label.morphingEffect = LTMorphingEffect.Sparkle
        
        pickerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pickerSelected(_:)))
        pickerTapGesture.delegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        startTimer = CFAbsoluteTimeGetCurrent()
        
        if (base == Dice.d0) {
            showPicker()
            return
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Roll dice
        
        endTimer = CFAbsoluteTimeGetCurrent()
        let heldTime = endTimer - startTimer
        
        if (heldTime >= Constants.Dice.closeTimer) {
            showPicker()
            return
        }
        
        if (base == Dice.d0) { return }
        
        // Random number
        guard let random = RandomNumberGenerator.sharedInstance.nextNumberInBase(base) else {
            // Empty dice display on nil result
            label.alpha = 0.5
            label.text = String(base)
            return
        }
        
        // Display random number
        label.alpha = 1.0
        label.text = String(random)
    }
    
    func setBackground(base: Dice) {
        
        // Setup background image
        let diceImage = UIImage(named: "\(base)")?.imageWithRenderingMode(.AlwaysOriginal)
        let colorImage = tintedImageWithColor(Constants.Skin.diceColor, image:diceImage!)
        backgroundImage.image = colorImage
        backgroundImage.contentMode = .ScaleAspectFit
        
        // Disable look d0
        if base == Dice.d0 {
            backgroundImage.alpha = 0.5
        } else {
            backgroundImage.alpha = 1.0
        }
    }
    
    func showPicker() {
        // Dice picker
        
        // Options
        let optionsArray = ["d100", "d20", "d12","d10", "d8", "d6", "d4" , "d3", "d2", "None"]
        
        // Instantiate new UIPicker with array of options
        let picker = UIPicker(options: optionsArray)!
        picker.frame = backgroundImage.frame
        picker.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        picker.pickerDelegate = self
        
        // Add to view
        addSubview(picker)
        bringSubviewToFront(picker)
        
        // Add tap gesture
        picker.addGestureRecognizer(pickerTapGesture)
        
        // Change background / Clear text
        setBackground(Dice.dSelect)
        label.text = ""
        
        // Default to Dice 100 as no notification give on default
        optionBase = Dice.d100
        
    }
    
    func resetDice() {
        
        // Label
        if base.rawValue <= Dice.d0.rawValue {
            label.text = ""
        } else {
            label.text = String(base.rawValue)
        }
        
        // Disable look
        label.alpha = 0.5
    }
}

extension DiceView: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func pickerSelected(sender:UITapGestureRecognizer) {
        // TODO: Close picker, apply choice
        let pickerTapped = sender.view as! UIPicker
        
        // Remove picker
        pickerTapped.removeGestureRecognizer(pickerTapGesture)
        pickerTapped.pickerDelegate = nil
        pickerTapped.removeFromSuperview()
        
        // Change Dice
        base = optionBase
    }
}

extension DiceView: UIPickerDelegate {
    
    func selectedOption(option: String) {
        
        switch option {
        case "d100":
            optionBase = Dice.d100
        case "d20":
            optionBase = Dice.d20
        case "d12":
            optionBase = Dice.d12
        case "d10":
            optionBase = Dice.d10
        case "d8":
            optionBase = Dice.d8
        case "d6":
            optionBase = Dice.d6
        case "d4":
            optionBase = Dice.d4
        case "d3":
            optionBase = Dice.d3
        case "d2":
            optionBase = Dice.d2
        default:
            optionBase = Dice.d0
            break
        }
        
        setBackground(optionBase)
    }
}