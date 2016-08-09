//
//  RandomNumberGenerator.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Status {
    case empty, charging, charged, error
}

enum Dice:Int {
    case dSelect = -1, d0 = 0, d2 = 2, d3 = 3, d4 = 4, d6 = 6, d8 = 8, d10 = 10, d12 = 12, d20 = 20, d100 = 100
}

class RandomNumberGenerator {
    
    /* Singleton */
    static let sharedInstance = RandomNumberGenerator()
    
    // Cache quantum block
    var quantumBlock:[UInt8] = []
    var delegate:RandomNumberGeneratorDelegate?
    var status = Status.empty {
        didSet {
            delegate?.didChangeStatus(status)
        }
    }
    
    private init() {
        arc4random_stir()
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
    
    func emergencyFallBack() {
        // Generate random, store in array
        
        quantumBlock.removeAll()
        
        for _ in 0...Constants.Quantum.block {
            let random = arc4random_uniform(256)
            quantumBlock.append(UInt8(random))
        }
        
        status = Status.charged
    }
    
    func populateQuantumBlock(quantumJSON: JSON) {
        // Parse JSON, extract numbers, store in array
        
        quantumBlock.removeAll()
        
        for number in quantumJSON["data"].arrayValue {
            quantumBlock.append(number.uInt8Value)
        }
        
        status = Status.charged
    }
    
    func nextNumberInBase(base: Dice) -> Int? {
        // Convert number from block to appropriate base range
        
        guard let nextNumber = quantumBlock.popLast() else {
            status = Status.empty
            return nil
        }
        
        // Range conversion
        let random = convertRange(baseMin: 0.0,baseMax: Double(UInt8.max), limitMin: 1.0, limitMax: Double(base.rawValue), value: Double(nextNumber))
        let randomInt = Int(round(random))
        print("Method1: \(nextNumber), Base: \(base), Random: \(random), RandomInt: \(randomInt)")

        return randomInt
        
    }
}

// MARK: Protocol
protocol RandomNumberGeneratorDelegate: class {
    func didChangeStatus(status: Status)
}
