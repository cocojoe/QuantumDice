//
//  Constants.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import ChameleonFramework

struct Constants {
    struct Quantum {
        static let domain = "qrng.anu.edu.au"
        static let block  = 60
        static let type   = "uint8"
    }
    
    struct Skin {
        static let backgroundColor = FlatSkyBlue()
    }
    
    struct Font {
        static let defaultPointSize:CGFloat = 64.0
    }
}