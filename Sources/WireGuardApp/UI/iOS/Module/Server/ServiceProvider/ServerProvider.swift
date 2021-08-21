// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Moya
import RxSwift
import PromiseKit
import Alamofire

public struct ServerProvider {

    private let _disposeBag = DisposeBag()

    //请求超时时间
    private static let _timeout: TimeInterval = 20

    //请求发起者
    private let _provider = MoyaProvider<ServerApi>(
        callbackQueue: .global(),
        session: { () -> Session in

            let requestInterceptor = ServerRequestInterceptor()
            //
            let serverTrustManager = ServerTrustManager()

            //配置网络请求
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            configuration.timeoutIntervalForRequest = _timeout

            return Session(configuration: configuration,
                           interceptor: requestInterceptor,
                           serverTrustManager: serverTrustManager,
                           redirectHandler: nil,
                           cachedResponseHandler: nil,
                           eventMonitors: [])

        }(), plugins: [NetWorksLoggerPlugin(),
                       NetWorksActivityPlugin()])



    /// 网络请求
    ///
    /// - Parameters:
    ///   - target: API类型
    ///   - observeOn: 发起请求的Scheduler
    ///   - subscribeOn: 相应请求返回的Scheduler
    ///   - retryCount: 发生错误时重试次数
    /// - Returns: 指定范型的Promise
    public func request<T:ServerModelTypeRes>(target: ServerApi,
                                              observeOn: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(queue: .global()),
                                              subscribeOn: ImmediateSchedulerType = MainScheduler.instance) -> Promise<T> {

//        return _requestPromise(target: target, observeOn: observeOn, subscribeOn: subscribeOn)
        return _resourcePromise(target: target)
    }

    //从本地请求，用于测试数据
    private func _resourcePromise<T: ServerModelTypeRes>(target: ServerApi) -> Promise<T> {

        return Promise{ seal in

            let name: String
            switch target {
            case .routerList:
                name = "RouterJsonList"
            }

            ResourceProvider<T>().fetchAsync(name: name, type: "json", callbackQueue: DispatchQueue.main) { result in
                switch result{
                case .success(let data):
                    seal.fulfill(data)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }


    }

    //发送网络请求
    private func _requestPromise<T: ServerModelTypeRes>(target: ServerApi,
                                                        observeOn: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(queue: .global()),
                                                        subscribeOn: ImmediateSchedulerType = MainScheduler.instance) -> Promise<T>{
        return Promise {seal in
            _provider.rx
                .request(target, callbackQueue: .global())
                .observeOn(observeOn)
                .map{
                    try $0._catchRandomDomainFlag()
                        .filterSuccessfulStatusCodes()
                        ._filterServerSuccessData()
                        .map(T.self)
                }
                //可用于出现某些错误后重试
//                .retryWhen { rxError -> Observable<Int> in
//                    // 失败后重新请求逻辑 可以添加一些特殊操作
//                    rxError.enumerated().flatMap { (index, error) -> Observable<Int> in
//                        if case .userRefresh = target { // 是否是刷新接口 请求出错 直接退出
//                            defer { //重新处理登陆请求逻辑
//            AppManager.shared.windowManager.goToLoginVcAndSetNeedLogin(error: error) }
//                            return Observable.error(error)
//                        }
//                        判断是否是token失效
//                        guard let serverInvalidTokenError = error as? ServerError,
//                            case .invalidToken = serverInvalidTokenError else { // 是普通错误，则不关注，不重试
//                                return Observable.error(error)
//                        }
//
//                        // 非 refresh 请求出现了 invalidToken 错误
//                        guard index <= .zero else { // 两次以上 直接退出
//                            defer { AppManager.shared.windowManager.goToLoginVcAndSetNeedLogin(error: error) }
//                            return Observable.error(serverInvalidTokenError)
//                        }
//
//                        return Observable<Int>.create { observer -> Disposable in // 一次以内
                             //刷新token
//                            AppManager.shared.accountManager.refreshToken(with: serverInvalidTokenError) { res in
//                                switch res {
//                                case.success(_):
//                                    observer.onNext(.zero)
//                                case .failure(let err):
//                                    observer.onError(err)
//                                }
//                            }
//                            return Disposables.create()
//                        }
//                    } }
                .subscribeOn(subscribeOn)
                .subscribe(onSuccess: { seal.fulfill($0)}) {
                    if $0.isMoyaCancledType{}
                    if $0.isMoyaNotReachableType {
                        seal.reject(ServerError.notReachable(error: $0))
                        return
                    }
                    seal.reject($0)
                }.disposed(by: _disposeBag)
        }

    }

    //返回为String类型的数据
    public func requestString(target: ServerApi,
                              observeOn: ImmediateSchedulerType = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()),
                              subscribeOn: ImmediateSchedulerType = MainScheduler.instance) -> Promise<String> {
        return Promise { seal in
            _provider.rx
                .request(target, callbackQueue: DispatchQueue.global())
                .observeOn(observeOn)
                .map { try $0
                    .filterSuccessfulStatusAndRedirectCodes()
                    .mapString() }
                .retryWhen { rxError -> Observable<Int> in
                    // 失败后重新请求逻辑 可以添加一些特殊操作
                    rxError.enumerated().flatMap { (index, error) -> Observable<Int>  in
                        if index >= .zero {
                            return Observable.error(error)
                        } else {
                            return Observable<Int>.just(.zero)
                        }
                    } }
                .subscribeOn(subscribeOn)
                .subscribe(onSuccess: { seal.fulfill($0) },
                           onError: {
                            // 网络请求被取消
                            if $0.isMoyaCancledType {  }
                            if $0.isMoyaNotReachableType { seal.reject(ServerError.notReachable(error: $0)); return }
                            seal.reject($0) })
                .disposed(by: _disposeBag)
        }
    }
}

extension Response {

    //服务器返回数据格式错误
    fileprivate func _filterServerSuccessData() throws -> Response {
        do {
            let responseJson = try mapJSON(failsOnEmptyData: false)
            guard let dic = responseJson as? [String: Any] else { throw ServerError.parseJsonError }
            if let error = _praseServerError(dict: dic) {
                throw error
            }
            return self
        }catch {
            throw error
        }
    }

    /// 解析规则，返回服务器自定义错误
    private func _praseServerError(dict: [String: Any]) -> Error? {

        //判断服务器返回状态码
        guard let code = dict["code"] as? Int else {
            return ServerError.parseStatusCodeTypeError
        }

        let message = dict["msg"] as? String

        switch code {
        case 0: // 请求成功
            return nil
        case 2:
            return ServerError.requestParamError
        case 100000:
            return ServerError.invalidToken(code: code,
                                            message: message)
        case 400000:
            return ServerError.restricted(code: code,
                                          message: message)
        case 700000:
            return ServerError.blackList(code: code,
                                         message: message)
        default:
            return ServerError.undefined(code: code,
                                         message: message)
        }
    }

    /// 根据http返回 处理特殊逻辑 如切换域名
    fileprivate func _catchRandomDomainFlag() -> Response {
        if [403, 502, 503].contains(statusCode) {
            // 有错误可以抛特殊异常 用与retry
            printDebug("http 错误码: \(statusCode)")
        }
        return self
    }
}
