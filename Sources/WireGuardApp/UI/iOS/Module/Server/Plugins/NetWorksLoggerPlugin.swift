//
//  NetWorksLoggerPlugin.swift
//  swiftProject
//
//  Created by liangcheng on 2021/6/23.
//

import Moya

/// 网络活动日志统计
public final class NetWorksLoggerPlugin: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        printDebug(request.request?.url ?? "request error")
        printDebug(request.request?.allHTTPHeaderFields ?? String.empty)
        #endif
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        switch result {
        case .success(let response):
            let printString = response.request?.url?.absoluteString ?? "无法找到请求路径"
            printDebug("success: " + printString)
        case .failure(let error):
            printDebug("error" + error.errorMoyaDescription)
        }
        #endif
    }
}
