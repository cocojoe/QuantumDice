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
    
    var randomNumberGenerator = RandomNumberGenerator.sharedInstance
    
    @IBOutlet weak var diceView1: DiceView!
    @IBOutlet weak var diceView2: DiceView!
    @IBOutlet weak var diceView3: DiceView!
    @IBOutlet weak var diceView4: DiceView!
    @IBOutlet weak var diceView5: DiceView!
    @IBOutlet weak var diceView6: DiceView!
    
    var diceArray:[DiceView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Assign delegate
        randomNumberGenerator.delegate = self
        
        // Setup dice
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
        diceView1.base = Dice.d20
        diceView2.base = Dice.d12
        diceView3.base = Dice.d0
        diceView4.base = Dice.d0
        diceView5.base = Dice.d0
        diceView6.base = Dice.d0
        
        // Add dice to array
        diceArray.append(diceView1)
        diceArray.append(diceView2)
        diceArray.append(diceView3)
        diceArray.append(diceView4)
        diceArray.append(diceView5)
        diceArray.append(diceView6)

    }
    
    func setupSkin() {
        // Setup Skin Color/Scheme
        view.backgroundColor = Constants.Skin.backgroundColor
        
        // Chamelon contrast status bar style
        setStatusBarStyle(UIStatusBarStyleContrast)
    }
    
    func refreshView() {
        
        for dice in diceArray {
            dice.resetDice()
        }
        
        // Stock RNG
        randomNumberGenerator.refreshQuantumBlock()
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
            randomNumberGenerator.emergencyFallBack()
            break
        }
    }
}
