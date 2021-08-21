//
//  ServerRequestInterceptor.swift
//  swiftProject
//
//  Created by liangcheng on 2021/6/23.
//

import Alamofire

//请求拦截器
public struct ServerRequestInterceptor: RequestInterceptor {

    private let _prepare: ((URLRequest) -> URLRequest)?
    private let _willSend: ((URLRequest) -> Void)?

    init(prepare: ((URLRequest) -> URLRequest)? = nil,
         willSend: ((URLRequest) -> Void)? = nil
         ) {
        _prepare = prepare
        _willSend = willSend
    }


    //拦截网络请求
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {

        var request = _prepare?(urlRequest) ?? urlRequest

        request.setValue("application/json; charset=utf-8",
                         forHTTPHeaderField: "Content-Type")
        request.setValue(UIDevice.current.systemVersion,
                         forHTTPHeaderField: "os")
        _willSend?(request)
        completion(.success(request))
    }

}

//获取网络状态
extension NetworkReachabilityManager.NetworkReachabilityStatus {
    fileprivate func _getName() -> String {
        let statusName: String
        switch self {
        case .unknown:
            statusName = "unknown"

        case .notReachable:
            statusName = "notReachable"
        case .reachable(let type):
            switch type {
            case .ethernetOrWiFi:
                statusName = "ethernetOrWiFi"
            case .cellular:
                statusName = "cellular"
            }
        }
     return statusName
    }
}
