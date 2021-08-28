// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

public struct PeerConfiguration {
    public var publicKey: PublicKey
    public var preSharedKey: PreSharedKey?          //预共享密钥
    public var allowedIPs = [IPAddressRange]()      //路由段
    public var endpoint: Endpoint?                  //对端地址
    public var persistentKeepAlive: UInt16?         //连接保活间隔
    public var rxBytes: UInt64?
    public var txBytes: UInt64?
    public var lastHandshakeTime: Date?             //最后一次握手时间

    public init(publicKey: PublicKey) {
        self.publicKey = publicKey
    }
}

extension PeerConfiguration: Equatable {
    public static func == (lhs: PeerConfiguration, rhs: PeerConfiguration) -> Bool {
        return lhs.publicKey == rhs.publicKey &&
            lhs.preSharedKey == rhs.preSharedKey &&
            Set(lhs.allowedIPs) == Set(rhs.allowedIPs) &&
            lhs.endpoint == rhs.endpoint &&
            lhs.persistentKeepAlive == rhs.persistentKeepAlive
    }
}

extension PeerConfiguration: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(publicKey)
        hasher.combine(preSharedKey)
        hasher.combine(Set(allowedIPs))
        hasher.combine(endpoint)
        hasher.combine(persistentKeepAlive)

    }
}
