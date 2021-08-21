//
//  UIView+IB.swift
//  Composite
//
//  Created by Django on 2/20/20.
//  Copyright © 2020 LeeGame. All rights reserved.
//

import UIKit

// MARK: - UIView + IB 相关扩展
extension UIView {
    @IBInspectable var cornerRadius: Double {
        get { return layer.cornerRadius.doubleValue }
        set { layer.cornerRadius = newValue.CGFloatValue; clipsToBounds = true }
    }

    @IBInspectable var borderWidth: Double {
        get { return layer.borderWidth.doubleValue }
        set { layer.borderWidth = newValue.CGFloatValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get { return layer.borderColor.map(UIColor.init) }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var shadowColor: UIColor? {
        get { return layer.shadowColor.map(UIColor.init) }
        set { layer.shadowColor = newValue?.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowRadius: Double {
        get { return layer.shadowRadius.doubleValue }
        set { layer.shadowRadius = newValue.CGFloatValue }
    }
}
