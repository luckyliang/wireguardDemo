// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

//
//public struct RouterDataModel: ServerModelTypeRes {
//    let code: Int
//    let msg: String
//    let data: RouterListModel
//}

public struct RouterListModel: ServerModelTypeRes {
    let list: [RouterItemModel]
}

public struct RouterItemModel: ServerModelTypeRes {
    let name: String
    let interface: RouterInterface
    let peer: RouterPeer
    public struct RouterInterface: ServerModelTypeRes {
        let dns: String
        let address: String
        let privateKey: String
    }

    public struct RouterPeer: ServerModelTypeRes {
        let endPoint: String
        let allowedIps: String
        let persistentKeepalive: String
        let publicKey: String
    }
}

