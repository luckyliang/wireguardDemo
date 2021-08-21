// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

public enum ViewState {
    case `init`
    case loading
    case success
    case failedWith(_ error: Error)
}

public enum ListViewState {
    case `init`
    case loading
    case success
    case successWithNoMoreData
    case failedWith(_ error: Error)
}

public enum LoadDataState {
    case `init`
    case refresh
    case loadMore
}
