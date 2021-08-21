//
//  UIView+Awakable.swift
//  Composite
//
//  Created by Django on 2/20/20.
//  Copyright © 2020 LeeGame. All rights reserved.
//

import UIKit

// MARK: - Xib 扩展
public protocol ViewAwakable { }
extension UIView: ViewAwakable { }

extension ViewAwakable where Self: UIView {
    /// 从 xib 创建 默认从同名 xib 创建
    public static func createFromXib(nibName: String? = nil) -> Self? {
        let result: Self?
        let className = nibName ?? NSStringFromClass(self).components(separatedBy: ".").last
        if let className = className {
            result = UINib(nibName: className, bundle: Bundle.main)
                .instantiate(withOwner: nil, options: nil)[safe: 0] as? Self
        } else {
            result = nil
        }
        return result
    }
}
