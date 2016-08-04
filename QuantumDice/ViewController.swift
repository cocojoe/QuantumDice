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
    
    @IBOutlet weak var buttonDice: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Improve button title scaling
        buttonDice.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonDice.titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        
        // Assign delegate
        randomNumberGenerator.delegate = self
        
        setupSkin()
        
        // Chamelon contrast status bar style
        self.setStatusBarStyle(UIStatusBarStyleContrast)
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
        buttonDice.setTitle(String(""), forState: .Normal)
        
        // Stock RNG
        randomNumberGenerator.refreshQuantumBlock()
    }
    
    @IBAction func rollDice(sender: UIButton) {
        // Update dicE with random ROLL
        
        guard let random = randomNumberGenerator.nextNumberInBase(Dice.d12) else {
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
