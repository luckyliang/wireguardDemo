//
//  NetWorksActivityPlugin.swift
//  swiftProject
//
//  Created by liangcheng on 2021/6/23.
//

import Moya

/// 网络状态观察
public final class NetWorksActivityPlugin: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        NetWorksIndicatorScheduler.shared.pushActivityIndicator()
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        NetWorksIndicatorScheduler.shared.popActivityIndicator()
    }
}
