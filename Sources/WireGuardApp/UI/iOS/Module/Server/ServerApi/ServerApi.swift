// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation
import Moya
public enum ServerApi {
    case routerList(_ model: ServerReouterModelReq)
}

extension ServerApi: TargetType {

    //baseURl
    public var baseURL: URL {
        return "http://www.test.com".urlValue ?? "".urlValue!
    }

    //请求路径
    public var path: String {
        switch self {
        case .routerList:
            return "api/getRouterList"
        }
    }

    //配置请求方式
    public var method: Moya.Method {
        switch self {
        case .routerList:
            return .get
        }
    }

    //样本数据
    public var sampleData: Data {
        return String.empty.data(using: .utf8)!
    }

    //请求任务
    public var task: Task {
        switch self {
        case .routerList(let model):

            return .requestJSONEncodable(model)
//            return .requestParameters(parameters: ["pageNo":model.pageNo], encoding: URLEncoding.default)
//            return .requestPlain
        }
    }

    //添加头部
    public var headers: [String : String]? {
        return nil
    }


}
