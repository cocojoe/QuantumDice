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
        static let block  = 100
        static let type   = "uint8"
        static let timeout = 6.0
    }
    
    struct Skin {
        static let backgroundColor = FlatSkyBlueDark()
        static let diceColor = FlatYellow()
        static let diceColorHighlight = FlatYellowDark()
    }
    
    struct Font {
        static let defaultPointSize:CGFloat = 60
        static let defaultSelectorPointSize:CGFloat = 32
    }
    
    struct Dice {
        static let closeTimer = 1.5
    }
}