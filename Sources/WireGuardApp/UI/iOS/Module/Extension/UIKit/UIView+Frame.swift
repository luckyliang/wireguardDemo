//
//  UIView+Frame.swift
//  Composite
//
//  Created by Django on 2/20/20.
//  Copyright © 2020 LeeGame. All rights reserved.
//

import UIKit

// MARK: - UIView + Frame 相关扩展
extension UIView {
    /// X 轴方向起点
    public var x: CGFloat {
        get { return frame.origin.x }
        set {
            var newFrame = frame
            newFrame.origin.x = newValue
            frame = newFrame
        }
    }

    /// Y 轴方向起点
    public var y: CGFloat {
        get { return frame.origin.y }
        set {
            var newFrame = frame
            newFrame.origin.y = newValue
            frame = newFrame
        }
    }

    public var size: CGSize {
        get { return bounds.size }
        set { bounds.size = newValue }
    }

    /// 视图宽度
    public var width: CGFloat {
        get { return frame.size.width }
        set {
            var newFrame = frame
            newFrame.size.width = newValue
            frame = newFrame
        }
    }

    /// 视图宽度的一半
    public var halfWidth: CGFloat {
        return width.half
    }

    /// 视图高度
    public var height: CGFloat {
        get { return frame.size.height }
        set {
            var newFrame = frame
            newFrame.size.height = newValue
            frame = newFrame
        }
    }

    /// 视图高度的一半
    public var halfHeight: CGFloat {
        return height.half
    }

    /// X 轴方向中点
    public var centerX: CGFloat {
        get { return center.x }
        set {
            var newCenter = center
            newCenter.x = newValue
            center = newCenter
        }
    }

    /// Y 轴方向中点
    public var centerY : CGFloat {
        get { return center.y }
        set {
            var newCenter = center
            newCenter.y = newValue
            center = newCenter
        }
    }
}
