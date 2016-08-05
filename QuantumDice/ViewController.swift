//
//  ViewController.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit
import SwiftSpinner
import ChameleonFramework

class ViewController: UIViewController {
    
    var randomNumberGenerator = RandomNumberGenerator()
    
    @IBOutlet weak var buttonDice1: DiceButton!
    @IBOutlet weak var buttonDice2: DiceButton!
    @IBOutlet weak var buttonDice3: DiceButton!
    @IBOutlet weak var buttonDice4: DiceButton!
    @IBOutlet weak var buttonDice5: DiceButton!
    @IBOutlet weak var buttonDice6: DiceButton!
    
    var buttonArray:[DiceButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Assign delegate
        randomNumberGenerator.delegate = self
        
        // Setup dice button default base
        setupDice()
        
        // Add Colors
        setupSkin()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }
    
    func setupDice() {
        // Setup dice button default base
        buttonDice1.base = Dice.d20
        buttonDice2.base = Dice.d12
        buttonDice3.base = Dice.d10
        buttonDice4.base = Dice.d0
        buttonDice5.base = Dice.d0
        buttonDice6.base = Dice.d0
        
        // Add buttons to array
        buttonArray.append(buttonDice1)
        buttonArray.append(buttonDice2)
        buttonArray.append(buttonDice3)
        buttonArray.append(buttonDice4)
        buttonArray.append(buttonDice5)
        buttonArray.append(buttonDice6)
        
        // Additional button setup
        for dice in buttonArray {
            
            // Set dice image
            let diceImage = UIImage(named: "\(dice.base)")?.imageWithRenderingMode(.AlwaysOriginal)
            dice.setBackgroundImage(diceImage, forState: .Normal)
            dice.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            
            // Setup dice button font, builder max too small
            let maxScaleFont = dice.titleLabel?.font.fontWithSize(Constants.Font.superSize)
            dice.titleLabel?.font = maxScaleFont
            
            // Adjust scale down to fit resolution
            dice.titleLabel?.adjustsFontSizeToFitWidth = true
            dice.titleLabel?.baselineAdjustment = .AlignCenters
            dice.titleLabel?.minimumScaleFactor = 0.10
        }
        
    }
    
    func setupSkin() {
        // Setup Skin Color/Scheme
        view.backgroundColor = Constants.Skin.backgroundColor
        
        // Chamelon contrast status bar style
        setStatusBarStyle(UIStatusBarStyleContrast)
    }
    
    func refreshView() {
        
        // Reset Dice
        for dice in buttonArray {
            
            if dice.base == Dice.d0 {
                dice.setTitle("", forState: .Normal)
            } else {
                dice.setTitle("\(dice.base.rawValue)", forState: .Normal)
            }
        }
        
        // Manual font fixing
        for dice in buttonArray {
            
            /* Manual font size adjustment, size of dice max value */
            let fontSize = dice.titleLabel?.actualFontSize()
            print("\(dice.titleLabel?.font.pointSize),\(fontSize)")
            //let minScaleFont = dice.titleLabel?.font.fontWithSize(fontSize!)
            //dice.titleLabel?.font = minScaleFont
        }
        
        // Stock RNG
        randomNumberGenerator.refreshQuantumBlock()
    }
    
    @IBAction func rollDice(sender: DiceButton) {
        // Roll & update dice button
        
        if sender.base == Dice.d0 { return }
        
        guard let random = randomNumberGenerator.nextNumberInBase(sender.base) else {
            // Empty dice display on nil result
            return
        }
        
        sender.setTitle(String(random), forState: .Normal)
    }
    
}

extension ViewController : RandomNumberGeneratorDelegate {
    
    func didChangeStatus(status: Status) {
        switch status {
        case .charging:
            // Display loading modal
            SwiftSpinner.show("Quantum Capacitor Charging")
        case .charged:
            // Remove modal
            SwiftSpinner.hide()
        case .empty:
            refreshView()
        case .error:
            // TODO: Handle data download retry loop
            break
        }
    }
}
