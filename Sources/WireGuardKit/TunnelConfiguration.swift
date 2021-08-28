// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

//通道配置模型
public final class TunnelConfiguration {
    public var name: String?    //名称
    public var interface: InterfaceConfiguration //客服端接口
    public let peers: [PeerConfiguration]        //客户端对端

    public init(name: String?, interface: InterfaceConfiguration, peers: [PeerConfiguration]) {
        self.interface = interface
        self.peers = peers
        self.name = name

        let peerPublicKeysArray = peers.map { $0.publicKey }
        let peerPublicKeysSet = Set<PublicKey>(peerPublicKeysArray)
        if peerPublicKeysArray.count != peerPublicKeysSet.count {
            fatalError("Two or more peers cannot have the same public key")
        }
    }
}

extension TunnelConfiguration: Equatable {
    public static func == (lhs: TunnelConfiguration, rhs: TunnelConfiguration) -> Bool {
        return lhs.name == rhs.name &&
            lhs.interface == rhs.interface &&
            Set(lhs.peers) == Set(rhs.peers)
    }
}
