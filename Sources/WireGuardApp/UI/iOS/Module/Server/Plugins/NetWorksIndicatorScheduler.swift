//
//  NetWorksIndicatorScheduler.swift
//  swiftProject
//
//  Created by liangcheng on 2021/6/23.
//

import UIKit

/// 网络活动指示器
public final class NetWorksIndicatorScheduler {

    private init() { }

    public static let shared = NetWorksIndicatorScheduler()

    private let _lock = NSRecursiveLock()
    private var _activityCount: Int = 0

    public func pushActivityIndicator() {
        _lock.lock()
        _activityCount += 1
        let count = _activityCount
        _lock.unlock()
        _updateActivityIndicator(with: count)
    }

    public func popActivityIndicator() {
        _lock.lock()
        _activityCount -= 1
        if _activityCount < 0 {
            _activityCount = 0
        }
        let count = _activityCount
        _lock.unlock()
        _updateActivityIndicator(with: count)
    }

    private func _updateActivityIndicator(with count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = count > 0
        }
    }
}

