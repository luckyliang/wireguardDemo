//
//  File.swift
//  Games
//
//  Created by deck on 2019/10/7.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Foundation
import UIKit
public protocol PresentAnimateDelegate {}

extension PresentAnimateDelegate where Self: UIViewController {

//    设置动画代理、视图及动画类型
    public func presentAnimate(animateView: UIView?, bgColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4), animationTime: TimeInterval = PresentAnimate.present.animateDuration, animateType: PresentAnimate.AnimationType = PresentAnimate.AnimationType.scale(scale: 1.1)) {

        modalPresentationStyle = .custom
        view.backgroundColor = bgColor

        let present = PresentAnimate.present
        present.animateDuration = animationTime
        transitioningDelegate = present
        present.animateView = animateView
        present.animateType = animateType
    }
}

// 用来接管present动画
public final class PresentAnimate: NSObject {

//    动画类型，目前只有缩放和平移，后期可继续添加
    public enum AnimationType {
        case scale(scale: CGFloat)
        case transform(startPostion: CGPoint)
    }

//    用来记录动画展示和移除
    private enum CustomTransition {
        case present
        case dismiss
    }

    public static let present: PresentAnimate = PresentAnimate()
    fileprivate var animateView: UIView?
    fileprivate var animateType: AnimationType = .scale(scale: 1.1)
    public var animateDuration: TimeInterval = 0.25

    private var _transition: CustomTransition = .present
}

// MARK: - 动画实现
extension PresentAnimate {

    private func _presentAnimate(context: UIViewControllerContextTransitioning) {

        guard let fromVC = context.viewController(forKey: .from) , let toVC = context.viewController(forKey: .to), let animateView = animateView else { return }

        context.containerView.addSubview(toVC.view)
        toVC.view.frame = fromVC.view.bounds

        switch animateType {
        case .scale(let scale):
            _scaleAnimate(scale: scale, animateView: animateView, context: context)
        case .transform(let startPostion):
            _transformAnimate(startPostion: startPostion, animateView: animateView, context: context)
        }
    }


    private func _dismissAnimate(context: UIViewControllerContextTransitioning) {

        guard let fomeVC = context.viewController(forKey: .from)else { return }

        fomeVC.view.alpha = 1

        UIView.animate(withDuration: animateDuration, animations: {
            fomeVC.view.alpha = 0
        }) { _ in
            fomeVC.view.removeFromSuperview()
            context.completeTransition(true)
        }
    }

//    缩放动画
    private func _scaleAnimate(scale: CGFloat, animateView: UIView, context: UIViewControllerContextTransitioning) -> Void {

        animateView.transform = CGAffineTransform(scaleX: scale, y: scale)
        animateView.alpha = 0
        UIView.animate(withDuration: animateDuration, animations: {
            animateView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            animateView.alpha = 1
        }) { _ in
            animateView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            animateView.alpha = 1
            context.completeTransition(true)
        }
    }

//  位移动画
    private func _transformAnimate(startPostion: CGPoint, animateView: UIView, context: UIViewControllerContextTransitioning) -> Void {

        animateView.transform = CGAffineTransform(translationX: startPostion.x, y: startPostion.y)
        animateView.alpha = 0
        UIView.animate(withDuration: animateDuration, animations: {
            animateView.alpha = 1
            animateView.transform = .identity
        }) { _ in
            animateView.transform = .identity
            context.completeTransition(true)
        }
    }
}


// MARK: 动画的代理方法
extension PresentAnimate: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animateDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)

        guard toVC != nil else { return }

        if _transition == .present {
            _presentAnimate(context: transitionContext)
        } else {
            _dismissAnimate(context: transitionContext)
        }
    }
}

extension PresentAnimate: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        _transition = .present
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        _transition = .dismiss
        return self
    }
}
