// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation
import Network

//接口配置模型
public struct InterfaceConfiguration {
    public var privateKey: PrivateKey           //必须
    public var addresses = [IPAddressRange]()   //私有ip地址,最好让后台返回
    public var listenPort: UInt16?              //监听端口，自动无需配置
    public var mtu: UInt16?                     //自动
    public var dns = [DNSServer]()              //可选
    public var dnsSearch = [String]()

    public init(privateKey: PrivateKey) {
        self.privateKey = privateKey
    }
}

extension InterfaceConfiguration: Equatable {
    public static func == (lhs: InterfaceConfiguration, rhs: InterfaceConfiguration) -> Bool {
        let lhsAddresses = lhs.addresses.filter { $0.address is IPv4Address } + lhs.addresses.filter { $0.address is IPv6Address }
        let rhsAddresses = rhs.addresses.filter { $0.address is IPv4Address } + rhs.addresses.filter { $0.address is IPv6Address }

        return lhs.privateKey == rhs.privateKey &&
            lhsAddresses == rhsAddresses &&
            lhs.listenPort == rhs.listenPort &&
            lhs.mtu == rhs.mtu &&
            lhs.dns == rhs.dns &&
            lhs.dnsSearch == rhs.dnsSearch
    }
}
