//
//  NonIntegerNumber+Extension.swift
//  Games
//
//  Created by Django on 18/08/2019.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Foundation
import UIKit

extension Float {

    /*
     const
     */
    public static let zero: Float = 0.0

    /*
     mathematic
     */
    public var half: Float {
        return self / 2.0
    }

    public var double: Float {
        return self * 2.0
    }

    /*
     value  conversion
     */
    public var intValue: Int {
        return Int(self)
    }

    public var CGFloatValue: CGFloat {
        return CGFloat(self)
    }

    public var doubleValue: Double {
        return Double(self)
    }

    public var stringValue: String {
        return String(self)
    }

    public var ceilValue: Int {
        return ceil(self).intValue
    }

    public var floorValue: Int {
        return floor(self).intValue
    }

    public var roundValue: Int {
        return roundf(self).intValue
    }
}

extension CGFloat {

    /*
     const
     */
    public static let zero: CGFloat = 0.0

    /*
     mathematic
     */
    public var half: CGFloat {
        return self / 2.0
    }

    public var double: CGFloat {
        return self * 2.0
    }

    /*
     value  conversion
     */
    public var intValue: Int {
        return Int(self)
    }

    public var floatValue: Float {
        return Float(self)
    }

    public var doubleValue: Double {
        return Double(self)
    }

    public var stringValue: String {
        return String(Float(self))
    }

    public var ceilValue: Int {
        return ceil(self).intValue
    }

    public var floorValue: Int {
        return floor(self).intValue
    }

    public var roundValue: Int {
        return roundf(floatValue).intValue
    }
}

extension Double {

    /*
     const
     */
    public static let zero: Double = 0.0

    /*
     mathematic
     */
    public var half: Double {
        return self / 2.0
    }

    public var double: Double {
        return self * 2.0
    }

    /*
     value  conversion
     */
    public var intValue: Int {
        return Int(self)
    }

    public var floatValue: Float {
        return Float(self)
    }

    public var CGFloatValue: CGFloat {
        return CGFloat(self)
    }

    public var stringValue: String {
        return String(self)
    }

    public var ceilValue: Int {
        return ceil(self).intValue
    }

    public var floorValue: Int {
        return floor(self).intValue
    }

    public var roundValue: Int {
        return roundf(floatValue).intValue
    }
}
