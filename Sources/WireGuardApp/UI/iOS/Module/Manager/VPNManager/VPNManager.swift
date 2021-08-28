// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

typealias tunnelsManagerBlock = (TunnelsManager?) -> ()

public class VPNManager {

    var tunnelsManager: TunnelsManager?
    public static let shared = VPNManager()
    private init() { }

}

//MARK: - Public
extension VPNManager {
    //刷新连接状态
   public func refreshTunnelConnectionStatuses() {
        if let tunnelsManager = tunnelsManager {
            tunnelsManager.refreshStatuses()
        }
    }
}

//MARK: - Private
extension VPNManager {

    //创建manager，会从偏好中读取manager
    func createTunnelsManager(_ tunnelsManagerBlock:  (( TunnelsManager? ) -> ())? ) {
        TunnelsManager.create { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                printDebug(error.localizedDescription)
                tunnelsManagerBlock?(nil)
            case .success(let tunnelsManager):
                tunnelsManager.activationDelegate = self
                self.tunnelsManager = tunnelsManager
                tunnelsManagerBlock?(tunnelsManager)
            }
        }
    }

    //删除没用的manager，增加后台新增的manager

}

extension VPNManager: TunnelsManagerActivationDelegate {

    //开启通道失败
    func tunnelActivationAttemptFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationAttemptError) {
        printDebug("tunnelActivationAttemptFailed")
    }
    //开启通道成功
    func tunnelActivationAttemptSucceeded(tunnel: TunnelContainer) {
        printDebug("tunnelActivationAttemptSucceeded")

    }
    //状态
    func tunnelActivationFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationError) {
        printDebug("tunnelActivationFailed")

    }

    func tunnelActivationSucceeded(tunnel: TunnelContainer) {
        printDebug("tunnelActivationSucceeded")
    }

}
