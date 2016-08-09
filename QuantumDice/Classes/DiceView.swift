//
//  DiceView.swift
//  QuantumDice
//
//  Created by Martin Walsh on 07/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit
import SwiftyTimer

class DiceView: UIView {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var label: LTMorphingLabel!
    
    var labelVerticalConstraint: NSLayoutConstraint!
    
    var pickerTapGesture:UITapGestureRecognizer!
    var optionBase:Dice = Dice.dSelect
    
    var holdTimer:NSTimer? = nil
    
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
        label.morphingEnabled = false
        
        pickerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pickerSelected(_:)))
        pickerTapGesture.delegate = self
        
        // Add label vertical constraints
        labelVerticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Baseline , relatedBy: NSLayoutRelation.Equal, toItem: backgroundImage, attribute: NSLayoutAttribute.Baseline, multiplier: Constants.Dice.defaultLabelMultiplier, constant: 0.0)
        
        addConstraint(labelVerticalConstraint)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        backgroundImage.highlighted = true
        
        // Hold down dice timer action
        holdTimer = NSTimer.after(1.5.seconds) { [ unowned self] in
            self.base = Dice.d0
            self.holdTimer?.invalidate()
        }
        
        // Immediate action on d0
        if (base == Dice.d0) {
            showPicker()
            return
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Roll dice
        
        // Cancel touch active actions
        backgroundImage.highlighted = false
        holdTimer?.invalidate()
        
        // Ignore d0
        if (base == Dice.d0) { return }
        
        // Random number
        guard let random = RandomNumberGenerator.sharedInstance.nextNumberInBase(base) else {
            // Empty dice display on nil result
            label.alpha = Constants.Font.defaultIdleAlpha
            label.text = String(base)
            return
        }
        
        // Display random number
        label.morphingEnabled = true
        label.alpha = 1.0
        label.text = String(random)
    }
    
    func setBackground(base: Dice) {
        
        // Setup background image
        let diceImage = UIImage(named: "\(base)")?.imageWithRenderingMode(.AlwaysOriginal)
        var colorImage = tintedImageWithColor(Constants.Skin.diceColor, image:diceImage!)
        backgroundImage.image = colorImage
        backgroundImage.contentMode = .ScaleAspectFit
        
        // Setup background image
        colorImage = tintedImageWithColor(Constants.Skin.diceColorHighlight, image:diceImage!)
        backgroundImage.highlightedImage = colorImage
        backgroundImage.highlighted = false
        
        print(labelVerticalConstraint)
        
        //First Label // Second background, multiplier 0.65 , constant 0
    }
    
    func showPicker() {
        // Dice picker
        
        // Ensure selection dice
        base = Dice.d0
        
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
        
        // Disable look
        label.morphingEnabled = false
        label.alpha = Constants.Font.defaultIdleAlpha
        
        // Label
        if base.rawValue <= Dice.d0.rawValue {
            label.text = ""
        } else {
            label.text = String(base.rawValue)
        }
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