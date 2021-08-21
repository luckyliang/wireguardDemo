// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit

public protocol TableViewCellAwakable{ }


extension TableViewCellAwakable where Self: UITableViewCell {

    public static var indentify: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? .empty
    }

    public static func nib(nibName: String? = nil) -> UINib? {
        let className = nibName ?? NSStringFromClass(self).components(separatedBy: ".").last
        if let className = className {
            return UINib(nibName: className, bundle: Bundle.main)
        }
        return nil
    }
}

extension TableViewCellAwakable where Self: UICollectionViewCell {
    public static var indentify: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? .empty
    }
    public static func nib(nibName: String? = nil) -> UINib? {
        let className = nibName ?? NSStringFromClass(self).components(separatedBy: ".").last
        if let className = className {
            return UINib(nibName: className, bundle: Bundle.main)
        }
        return nil    }
}


extension UITableViewCell: TableViewCellAwakable { }

extension UICollectionViewCell: TableViewCellAwakable { }
