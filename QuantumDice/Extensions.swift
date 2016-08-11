//
//  Helpers.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit
import AVFoundation

func print(items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}

// MARK: Number conversion
func convertRange(baseMin baseMin: Double, baseMax: Double, limitMin: Double, limitMax: Double, value: Double) -> Double {
    return ((limitMax - limitMin) * (value - baseMin) / (baseMax - baseMin)) + limitMin;
}

// MARK: View Animations
extension UIView {
    
    func rotateView(completionHandler: () -> Void ) {
        
        let direction: CGFloat = CGFloat.randomSign()
        let duration = Double(CGFloat.random(min: 0.9, max: 1.3))
        
        self.transform = CGAffineTransformIdentity
        
        UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: [.CalculationModePaced ], animations: {() -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: {() -> Void in
                self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * 2.0 / 3.0 * direction)
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: {() -> Void in
                self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * 4.0 / 3.0 * direction)
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: {() -> Void in
                self.transform = CGAffineTransformIdentity
            })
            }, completion: {(finished: Bool) -> Void in
                completionHandler()
        })
    }
    
    func fadeViewTo(duration: Double, alpha: CGFloat) {
        
        UIView.animateWithDuration(duration, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
            self.alpha = alpha
            }, completion: {(finished: Bool) -> Void in
        })
    }
    
    func scalePop() {
        
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeScale(1.10, 1.10)
            }, completion: {(finished: Bool) -> Void in
                
                UIView.animateWithDuration(0.1, animations: {
                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    }, completion: nil)
                
        })
        
    }
    
    func scaleTo(scale: CGFloat) {
        
        UIView.animateWithDuration(0.0, animations: {
            self.transform = CGAffineTransformMakeScale(scale, scale)
            }, completion: {(finished: Bool) -> Void in
        })
        
    }
}
