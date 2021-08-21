//
//  MoyaError.swift
//  Games
//
//  Created by Django on 21/09/2019.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Moya

extension MoyaError {

    /// MoyaError错误描述
    public var errorMoyaDescription: String {
        switch self {
        case .imageMapping:
            return "网络异常，请检查: \(localizedDescription)"
        case .jsonMapping:
            return "网络异常，请检查: \(localizedDescription)"
        case .stringMapping:
            return "网络异常，请检查: \(localizedDescription)"
        case .objectMapping( _ , _):
            let string: String
//            #if DEBUG
            /*
            if let nsError = errorUserInfo[NSUnderlyingErrorKey] as? NSError,
                let resString = nsError.userInfo["NSDebugDescription"] as? String {
                string = resString
            } else {
                string = "请求异常 (Object Mapping): \(localizedDescription)"
            }
            */
            var res: String = .empty
            print(self, to: &res)
            string = res
//            #else
//            string = "请求异常 (Object Mapping): \(localizedDescription)"
//            #endif
            return string
        case .encodableMapping(let error):
            return "网络异常，请检查: \(error.errorDescription)"
        case .statusCode(let response):
            return ("请求失败,请重试! 错误码： " + "(\(response.statusCode))")
        case .requestMapping:
            return "网络异常，请检查: \(localizedDescription)"
        case .parameterEncoding(let error):
            return "网络异常，请检查: \(error.errorDescription)"
        case .underlying(let error, _):
            return "网络异常，请检查: \(error.errorDescription)"
        }
    }
}
