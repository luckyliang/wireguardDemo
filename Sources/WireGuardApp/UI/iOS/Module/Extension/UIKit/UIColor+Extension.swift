//
//  UIColor+Extension.swift
//  Games
//
//  Created by Django on 30/08/2019.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import UIKit

extension UIColor {
    public static var random: UIColor {
        let r = arc4random_uniform(256).CGFloatValue / 255.0
        let g = arc4random_uniform(256).CGFloatValue / 255.0
        let b = arc4random_uniform(256).CGFloatValue / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }

    public static func colorWith(red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
    }

    /// 使用颜色对应的十六进制字符串创建颜色
    /// - Parameter colorString: 颜色对应的十六进制字符串
    public static func colorWithString(colorString: String) -> UIColor? {
        var usedColor: UIColor?

        if colorString.count == 6 {
            var isRight = false
            let temp = colorString.uppercased()
            for charact in temp {
                if (charact >= "0" && charact <= "9") {
                    isRight = true
                } else if (charact >= "A" && charact <= "F") {
                    isRight = true
                }
            }
            if isRight {
                let red1 = temp[temp.startIndex]
                let red2 = temp[temp.index(after: temp.startIndex)]

                let green1 = temp[temp.index(temp.startIndex, offsetBy: 2)]
                let green2 = temp[temp.index(temp.startIndex, offsetBy: 3)]

                let blue1  = temp[temp.index(temp.startIndex, offsetBy: 4)]
                let blue2  = temp[temp.index(temp.startIndex, offsetBy: 5)]

                let r = red1._toInt() * 16 + red2._toInt()
                let g = green1._toInt() * 16 + green2._toInt()
                let b = blue1._toInt() * 16 + blue2._toInt()

                usedColor = UIColor.colorWith(red: r, green: g, blue: b)
            }
        }
        return usedColor
    }

    /// 创建两个颜色过渡时的中间色
    /// - Parameters:
    ///   - beginColor: 开始的颜色
    ///   - endColor: 结束的颜色
    ///   - percent: 颜色变化比例
    public static func colorFrom(beginColor: UIColor, endColor: UIColor, percent: CGFloat) -> UIColor {

        let usedPercent = (percent > 1 ? 1 : percent) < 0 ? 0 : percent

        var r1: CGFloat = 1
        var r2: CGFloat = 1
        var g1: CGFloat = 1
        var g2: CGFloat = 1
        var b1: CGFloat = 1
        var b2: CGFloat = 1
        var alp1: CGFloat = 1
        var alp2: CGFloat = 1

        beginColor.getRed(&r1, green: &g1, blue: &b1, alpha: &alp1)
        endColor.getRed(&r2, green: &g2, blue: &b2, alpha: &alp2)

        let diffR = r2 - r1
        let diffG = g2 - g1
        let diffB = b2 - b1
        let diffAlp = alp2 - alp1

        let nowR = r1 + diffR * usedPercent
        let nowG = g1 + diffG * usedPercent
        let nowB = b1 + diffB * usedPercent
        let nowAlp = alp1 + diffAlp * usedPercent

        return UIColor(red: nowR, green: nowG, blue: nowB, alpha: nowAlp)
    }
}

extension Character {
    fileprivate func _toInt() -> Int {
        if self == "A" {
            return 10
        } else if self == "B" {
            return 11
        } else if self == "C" {
            return 12
        } else if self == "D" {
            return 13
        } else if self == "E" {
            return 14
        } else if self == "F" {
            return 15
        }
        return stringValue.intValue ?? 0
    }
}
