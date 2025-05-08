//
//  UIColor.swift
//  CameraRGBTest
//
//  Created by Muhammad Raihan Abdillah Lubis on 06/05/25.
//

import UIKit

extension UIColor {
    var hueComponent: CGFloat? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return hue * 360 // dari 0.0–1.0 ke 0–360 derajat
        } else {
            return nil
        }
    }
    
    func toHSB() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat)? {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        guard self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            return nil
        }
        return (hue: h * 360, saturation: s, brightness: b)
    }
}

