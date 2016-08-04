//
//  RandomNumberGenerator.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Dice:UInt8 {
    case d2 = 2, d4 = 4, d6 = 6, d8 = 8, d10 = 10, d12 = 12, d20 = 20, d100 = 100
}

enum Status {
    case empty, charging, charged, error
}

class RandomNumberGenerator {
    
    // Cache quantum block
    var quantumBlock:[UInt8] = []
    var delegate:RandomNumberGeneratorDelegate?
    var status = Status.empty {
        didSet {
            delegate?.didChangeStatus(status)
        }
    }
    
    func refreshQuantumBlock() {
        
        status = Status.charging
        
        // Refresh quantum number block data
        let URL = "https://\(Constants.Quantum.domain)/API/jsonI.php"
        let parameters = ["length": String(Constants.Quantum.block), "type" :  Constants.Quantum.type]
        
        NetworkManager.sharedInstance.requestJSON(URL, parameters: parameters) {
            (result: Bool, jsonData: JSON?) in
            
            guard let jsonData = jsonData else {
                self.status = Status.error
                return
            }
            
            self.populateQuantumBlock(jsonData)
        }
    }
    
    func populateQuantumBlock(quantumJSON: JSON) {
        // Parse JSON, extract numbers, store in array
        
        for number in quantumJSON["data"].arrayValue {
            quantumBlock.append(number.uInt8Value)
        }
        
        status = Status.charged
    }
    
    func nextNumberInBase(base: Dice) -> UInt8? {
        // Convert number from block to appropriate base range
        
        guard let nextNumber = quantumBlock.popLast() else {
            status = Status.empty
            return nil
        }
        
        let ratio = Float(base.rawValue) / Float(UInt8.max)
        let random = UInt8( Float(nextNumber) * ratio ) + 1

        return random
        
    }
}

// MARK: Protocol
protocol RandomNumberGeneratorDelegate: class {
    func didChangeStatus(status: Status)
}
