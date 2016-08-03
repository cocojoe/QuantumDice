//
//  RandomNumberGenerator.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RandomNumberGenerator {
    
    /* Cache quantum block */
    var quantumBlock:[UInt8] = []
    
    func refreshQuantumBlock() {
        
        let URL = "https://\(Constants.Quantum.domain)/API/jsonI.php"
        let parameters = ["length": Constants.Quantum.block, "type" :  Constants.Quantum.type]
        
        NetworkManager.sharedInstance.requestJSON(URL, parameters: parameters) {
            (result: Bool, jsonData: JSON?) in
            print(jsonData)
        }
    }
    
    func populateQuantumBlock(quantumJSON: JSON) {
        
    }
}
