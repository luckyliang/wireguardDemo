// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation


public struct ServerResult<T: ServerModelTypeRes>: ServerModelTypeRes {

    let code: Int
    let msg: String
    let data: T
}
