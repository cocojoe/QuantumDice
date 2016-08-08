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

func convertRange(baseMin baseMin: Double, baseMax: Double, limitMin: Double, limitMax: Double, value: Double) -> Double {
    return ((limitMax - limitMin) * (value - baseMin) / (baseMax - baseMin)) + limitMin;
}

func tintedImageWithColor(tintColor: UIColor, image: UIImage) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
    let context: CGContextRef = UIGraphicsGetCurrentContext()!
    CGContextTranslateCTM(context, 0, image.size.height)
    CGContextScaleCTM(context, 1.0, -1.0)
    let rect: CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
    // draw alpha-mask
    CGContextSetBlendMode(context, CGBlendMode.Normal)
    CGContextDrawImage(context, rect, image.CGImage)
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, CGBlendMode.SourceIn)
    tintColor.setFill()
    CGContextFillRect(context, rect)
    let coloredImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return coloredImage
}
