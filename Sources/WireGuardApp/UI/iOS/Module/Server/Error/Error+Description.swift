//
//  Error+Description.swift
//  Games
//
//  Created by Django on 21/09/2019.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Moya

extension Swift.Error {

    /// Swift.Error错误描述 兼容所有错误类型的描述
    public var errorDescription: String {
        if let moyaError = self as? MoyaError {
            return moyaError.errorMoyaDescription
        } else if let serverError = self as? ServerError {
            return serverError.errorServerDescription
        } else if let resourceError = self as? ResourceError {
            return resourceError.errorResourceDescription
        } else {
            return localizedDescription
        }
    }
}

extension Swift.Error {
    /// 是否是 Moya被取消的网络请求
    public var isMoyaCancledType: Bool {
        let result: Bool

        guard let moyaError = self as? MoyaError else {
            result = false
            return result
        }

        switch moyaError {
        case .underlying(let err, _):
            result = (err as NSError).code == -999
        default:
            result = false
        }

        return result
    }

    /// 是否是无网络
    public var isMoyaNotReachableType: Bool {
        let result: Bool

        guard let moyaError = self as? MoyaError else {
            result = false
            return result
        }

        switch moyaError {
        case .underlying(let err, _):
            result = (err as NSError).code == -1009
        default:
            result = false
        }

        return result
    }
}
