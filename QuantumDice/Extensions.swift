//
//  Helpers.swift
//  QuantumDice
//
//  Created by Martin Walsh on 03/08/2016.
//  Copyright © 2016 Frosty Cube. All rights reserved.
//

import UIKit

func print(items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        Swift.print(items[0], separator:separator, terminator: terminator)
    #endif
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        /* Image tinting */
        
        let maskImage = self.CGImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRectMake(0, 0, width, height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let bitmapContext = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        
        CGContextClipToMask(bitmapContext, bounds, maskImage)
        CGContextSetFillColorWithColor(bitmapContext, color.CGColor)
        CGContextFillRect(bitmapContext, bounds)
        
        //is it nil?
        if let cImage = CGBitmapContextCreateImage(bitmapContext) {
            let coloredImage = UIImage(CGImage: cImage)
            return coloredImage
        } else {
            return nil
        } 
    }
    
}

extension UILabel {
    
    public func actualFontSize()-> CGFloat {
        
        let context = NSStringDrawingContext()
        context.minimumScaleFactor = self.minimumScaleFactor

        let attributedString = NSAttributedString(string: self.text ?? "", attributes: [NSFontAttributeName: self.font])
        attributedString.boundingRectWithSize(self.frame.size, options: [.UsesLineFragmentOrigin], context: context)
        
        return ( self.font.pointSize * context.actualScaleFactor )
    }
}
