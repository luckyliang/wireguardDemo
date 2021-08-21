//
//  ServerError.swift
//  Games
//
//  Created by Django on 12/7/19.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Foundation

/// 自己服务器错误
public enum ServerError: Swift.Error {
    /// 维护模型
    public struct MaintainModel: ServerModelTypeRes {
        let title: String
        let openTime: Int
        let service: String
    }

    case requestParamError

    /// 解析Json格式错误
    case parseJsonError

    /// 解析服务器定义StatusCode格式错误
    case parseStatusCodeTypeError

    /// 服务器维护
    case underMaintain(code: Int, maintainModel: ServerError.MaintainModel?)

    /// token 失效
    case invalidToken(code: Int, message: String?)

    /// 其他自定义错误
    case undefined(code: Int, message: String?)

    /// 受限地区
    case restricted(code: Int, message: String?)

    /// 无权访问 黑名单
    case blackList(code: Int, message: String?)


    /// 网络无法连接
    case notReachable(error: Error)

}

extension ServerError {

    /// 自己服务器错误描述
    public var errorServerDescription: String {
        switch self {
        case .parseJsonError:
            return "服务器返回数据 JSON 解析失败"
        case .parseStatusCodeTypeError:
            return "服务器返回状态码格式错误"
        case .restricted:
            return "访问来自受限地区"
        case .underMaintain(let code, let maintainModel):
            return maintainModel?.title.isEmpty()
                ?? "服务器正在维护中" + " \(code)"
        case .invalidToken(let code, let message):
            return message?.isEmpty()
                ?? "Token 失效，请重新登录" + " \(code)"
        case .undefined(let code, let message):
            return message?.isEmpty()
                ?? "未定义服务器错误" + " \(code)"
        case .blackList(let code, let message):
            return message?.isEmpty()
                ?? "受限制用户" + " \(code)"
        case .notReachable(let error):
            return error.errorDescription
        case .requestParamError:
            return "请求参数错误"
        }
    }
}
