//
//  UIButton+Layout.swift
//  Composite
//
//  Created by Django on 2/20/20.
//  Copyright © 2020 LeeGame. All rights reserved.
//

import UIKit

// MARK: - 图文位置变动
extension UIButton {
    /// 图文位置
    ///
    /// - top: 上图下文字
    /// - left: 左图右文字
    /// - bottom: 下图上文字
    /// - right: 右图左文字
    public enum ImageTextLayout {
        case top
        case left
        case bottom
        case right
    }

    /// style:图片位置 space:图片与文字的距离
    public func reloadLayout(_ style: ImageTextLayout,
                             _ space: CGFloat) {
        guard let btnImageView = imageView,
            let btnTitleLabel = titleLabel else { return }

        let labelWidth = btnTitleLabel.intrinsicContentSize.width
        let labelHeight = btnTitleLabel.intrinsicContentSize.height

        let imageEdgeInsetsT: UIEdgeInsets
        let labelEdgeInsetsT: UIEdgeInsets

        switch style {
        case .top:
            imageEdgeInsetsT = UIEdgeInsets(top: -labelHeight - space.half,
                                            left: 0,
                                            bottom: 0,
                                            right: -labelWidth)
            labelEdgeInsetsT = UIEdgeInsets(top: 0,
                                            left: -btnImageView.width,
                                            bottom: -btnImageView.height - space.half,
                                            right: 0)
        case .left:
            imageEdgeInsetsT = UIEdgeInsets(top: 0,
                                            left: -space.half,
                                            bottom: 0,
                                            right: 0)
            labelEdgeInsetsT = UIEdgeInsets(top: 0,
                                            left: space.half,
                                            bottom: 0,
                                            right: -space.half)
        case .bottom:
            imageEdgeInsetsT = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: -labelHeight - space.half,
                                            right: -labelWidth)
            labelEdgeInsetsT = UIEdgeInsets(top: -btnImageView.height - space.half,
                                            left: -btnImageView.width,
                                            bottom:0 ,
                                            right:0)
        case .right:
            imageEdgeInsetsT = UIEdgeInsets(top: 0,
                                            left: btnTitleLabel.width + space.half,
                                            bottom: 0,
                                            right: -btnTitleLabel.width - space.half)
            labelEdgeInsetsT = UIEdgeInsets(top: 0,
                                            left: -btnImageView.width - space.half,
                                            bottom: 0,
                                            right: btnImageView.width + space.half)
        }
        titleEdgeInsets = labelEdgeInsetsT
        imageEdgeInsets = imageEdgeInsetsT
    }
}
