//
//  ServerModelTypeRes.swift
//  swiftProject
//
//  Created by liangcheng on 2021/6/23.
//

import Foundation


//请求结果遵循Codable协议
public protocol ServerModelTypeRes: Codable { }

extension Optional: ServerModelTypeRes where Wrapped: ServerModelTypeRes { }
