//
//  DiceView.swift
//  QuantumDice
//
//  Created by Martin Walsh on 07/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit
import SwiftyTimer
import AVFoundation

class DiceView: UIView {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var miniLabel: UILabel!
    
    var labelVerticalConstraint: NSLayoutConstraint?
    
    var pickerTapGesture:UITapGestureRecognizer!
    var optionBase:Dice = Dice.dSelect
    
    var holdTimer:NSTimer? = nil
    
    var base:Dice = Dice.d20 {
        didSet {
            setBackground(base)
            resetDice()
        }
    }
    
    var audioPlayer:AVAudioPlayer?
    
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
        
        pickerTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.pickerSelected(_:)))
        pickerTapGesture.delegate = self
        
        // SFX
        let sfx = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dice_roll", ofType: "caf")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL:sfx)
            audioPlayer?.prepareToPlay()
        }catch {
            print("SFX Load Failed")
        }

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Highlight state
        backgroundImage.highlighted = true
        backgroundImage.tintColor = Constants.Skin.diceColorHighlight
        
        // Hold down dice timer action
        holdTimer = NSTimer.after(1.0.seconds) { [ unowned self] in
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

        // Cancel highlight state
        backgroundImage.highlighted = false
        backgroundImage.tintColor = Constants.Skin.diceColor
        holdTimer?.invalidate()
        
        // Ignore if no value dice
        if (base == Dice.d0) { return }
        
        rollDice()
    }
    
    func rollDice() {
        
        if (base.rawValue <= Dice.d0.rawValue) { return }
        
        // Random number
        guard let random = RandomNumberGenerator.sharedInstance.nextNumberInBase(base) else {
            
            // Empty dice display on nil result
            label.fadeViewTo(Constants.Font.defaultFadeTime, alpha: Constants.Font.defaultIdleAlpha)
            label.text = String(base.rawValue)
            return
        }
        
        // SFX
        audioPlayer?.play()
        
        // Fade out label
        label.fadeViewTo(Constants.Font.defaultFadeTime, alpha: 0.0)
        
        // Rotate view
        self.rotateView { [unowned self] in
            
            // Display number / animate label
            self.label.text = String(random)
            self.label.fadeViewTo(0.3, alpha: 1.0)
            
            //self.label.scalePop()
            self.scalePop()
        }
        
    }
    
    func setBackground(base: Dice) {
        
        // Setup background
        let diceImage = UIImage(named: "\(base)")?.imageWithRenderingMode(.AlwaysTemplate)
        backgroundImage.image = diceImage
        backgroundImage.tintColor = Constants.Skin.diceColor
        backgroundImage.contentMode = .ScaleAspectFit
        backgroundImage.scaleTo(1.00)
        
        // Set manual label vertical constraint
        if let labelVerticalConstraint = labelVerticalConstraint {
            removeConstraint(labelVerticalConstraint)
        }
        
        var multiplier = Constants.Dice.defaultLabelVerticalConstraintMultiplier
        
        switch(base) {
        case Dice.d10:
            multiplier = 0.55
        case Dice.d4:
            multiplier = 0.75
        case Dice.d0, Dice.dSelect, Dice.d100, Dice.d2:
            backgroundImage.scaleTo(0.90)
        case Dice.d6:
            backgroundImage.scaleTo(0.85)
        default:
            break
        }
        
        self.labelVerticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Baseline , relatedBy: NSLayoutRelation.Equal, toItem: backgroundImage, attribute: NSLayoutAttribute.Baseline, multiplier: multiplier, constant: 0.0)
        
        addConstraint(self.labelVerticalConstraint!)
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
        
        label.fadeViewTo(0.2, alpha: Constants.Font.defaultIdleAlpha)
        
        // Label
        if base.rawValue <= Dice.d0.rawValue {
            label.text = ""
            miniLabel.text = ""
        } else {
            label.text = String(base.rawValue)
            miniLabel.text = String(base.rawValue)
        }
    }
    
}

extension DiceView: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func pickerSelected(sender:UITapGestureRecognizer) {
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
    }
}