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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        // Improve button title scaling
//        buttonDice.titleLabel?.adjustsFontSizeToFitWidth = true
//        buttonDice.titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        
        // Assign delegate
        randomNumberGenerator.delegate = self
        
        // Setup dice base
        buttonDice1.base = Dice.d20
        buttonDice2.base = Dice.d12
        
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
    
    func setupSkin() {
        // Setup Skin Color/Scheme
        view.backgroundColor = Constants.Skin.backgroundColor
        
        // Chamelon contrast status bar style
        setStatusBarStyle(UIStatusBarStyleContrast)
    }
    
    func refreshView() {
        // Clear display elements
        buttonDice1.setTitle(String("D20"), forState: .Normal)
        buttonDice2.setTitle(String("D12"), forState: .Normal)
        
        // Stock RNG
        randomNumberGenerator.refreshQuantumBlock()
    }
    
    @IBAction func rollDice(sender: DiceButton) {
        // Roll & update dice button
        
        guard let random = randomNumberGenerator.nextNumberInBase(sender.base) else {
            // Empty dice display on nil result
            sender.setTitle(String(""), forState: .Normal)
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
