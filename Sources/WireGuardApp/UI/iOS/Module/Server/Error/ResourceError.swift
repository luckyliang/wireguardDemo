//
//  ResourceError.swift
//  Composite
//
//  Created by Django on 12/7/19.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Foundation

/// 资源错误
public enum ResourceError: Swift.Error {

    /// 找不到资源
    case notFound

    /// 资源为空
    case empty

    /// 解析 Json 失败
    case mapJsonFailed(error: Error)
}

extension ResourceError {

    /// 资源错误描述
    public var errorResourceDescription: String {
        switch self {
        case .notFound:
            return "未找到资源"
        case .empty:
            return "资源为空"
        case .mapJsonFailed( _):
            return "json解析失败"
        }
    }
}
