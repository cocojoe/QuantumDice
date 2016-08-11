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
        static let block  = 120
        static let type   = "uint8"
        static let timeout = 7.0
    }
    
    struct Skin {
        static let backgroundColor = FlatSkyBlueDark()
        static let diceColor = FlatYellow()
        static let diceColorHighlight = FlatYellowDark()
    }
    
    struct Font {
        static let defaultPointSize:CGFloat = 60
        static let defaultSelectorPointSize:CGFloat = 32
        static let defaultIdleAlpha:CGFloat = 0.75
        static let defaultFadeTime:Double = 0.2
    }
    
    struct Dice {
        static let defaultLabelVerticalConstraintMultiplier:CGFloat = 0.65
    }
    
    struct Bar {
        static let defaultBarHeight:CGFloat = 32.0
    }
    
    struct AppStore {
        static let appID = "1142986245"
        static let reviewEvents:UInt = 60
    }
    
    struct Analytics {
        static let FlurryKey = "3XZB7CXZKQRV7CP67Q8C"
    }
}