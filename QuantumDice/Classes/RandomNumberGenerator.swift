//
//  RandomNumberGenerator.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import Foundation
import Alamofire

class RandomNumberGenerator {
    
    /* Cache quantum block */
    var quantumBlock:[UInt8] = []
    
    func random() -> Bool {
        return true
    }
    
    func populateQuantumBlock() {
        
        /* Request quantum rng block, 10 numbers between 0 - 255 */
        NetworkManager.sharedInstance.requestJSON("https://\(Constants.quantumDomain)/API/jsonI.php", parameters: ["length": "10", "type" : "uint8"])
    }
    
}
