//
//  UIView+Gradient.swift
//  Composite
//
//  Created by Django on 2/20/20.
//  Copyright © 2020 LeeGame. All rights reserved.
//

import UIKit

/// GradientDirection
public enum GradientDirection {
    case horizontal
    case vertical
    case other(startPoint: CGPoint, endPoint: CGPoint)
}

/// gradient 协议
public protocol ViewGradientable: NSObjectProtocol {
    func setGradient(fromColor: UIColor,
                     toColor: UIColor,
                     direction: GradientDirection)
}

extension UIView: ViewGradientable { }

extension ViewGradientable where Self: UIView {
    public func setGradient(fromColor: UIColor,
                            toColor: UIColor,
                            direction: GradientDirection) {
        if let oldGradientLayer = layer.sublayers?
            .first(where: { $0.isKind(of: CAGradientLayer.self) }) {
            oldGradientLayer.removeFromSuperlayer()
        }
        let gradientColors = [fromColor.cgColor, toColor.cgColor]
        let gradientLayerT = CAGradientLayer().then {
            $0.colors = gradientColors
            $0.frame = bounds
            switch direction {
            case .horizontal:
                $0.startPoint = CGPoint(x:0, y:0)
                $0.endPoint = CGPoint(x:1, y:0)
            case .vertical:
                $0.startPoint = CGPoint(x:0, y:0)
                $0.endPoint = CGPoint(x:0, y:1)
            case .other(let start, let end):
                $0.startPoint = start
                $0.endPoint = end
            }
        }
        layer.insertSublayer(gradientLayerT, at: 0)
    }

    public func removeGradientLayer() {
        _ = layer.sublayers?
            .filter { $0.isKind(of: CAGradientLayer.self) }
            .map { $0.removeFromSuperlayer() }
    }
}
