//
//  ServerTrusManager.swift
//  swiftProject
//
//  Created by liangcheng on 2021/6/23.

import Alamofire

/// 服务器证书信任管理
public final class ServerTrustManager: Alamofire.ServerTrustManager {
    init() {
        //这里不需要信任
        let allHostsMustBeEvaluated = false
        let evaluators = [String.empty: DisabledTrustEvaluator()]
        super.init(allHostsMustBeEvaluated: allHostsMustBeEvaluated,
                   evaluators: evaluators)
    }
}
