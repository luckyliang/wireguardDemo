// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import PromiseKit

public class RouterListViewModel {

    private var _pageNo: Int = 1
    private let _pageSize: Int = 10

    private let _disposeBag = DisposeBag()
    private let _serverProvider = ServerProvider()

    //加载状态
    private let _viewStateRelay = BehaviorRelay<ViewState>(value: .`init`)
    public  let viewStateDriver: Driver<ViewState>


    //数据
    public let dataRelay = BehaviorRelay<[RouterItemModel]>(value: [])


    init() {
        viewStateDriver = _viewStateRelay.asDriver()
    }
}


extension RouterListViewModel {

    public func loadData() {
        _viewStateRelay.accept(.loading)
        _loadDataFormServer().done { [weak self] resutl in
            self?._viewStateRelay.accept(.success)
            self?.dataRelay.accept(resutl.data.list)
        }.catch { [weak self] error in
            self?._viewStateRelay.accept(.failedWith(error))
        }
    }

    private func _loadDataFormServer() -> Promise<ServerResult<RouterListModel>> {
        let reqMode = ServerReouterModelReq(pageNo: _pageNo, pageSize: _pageSize)
        return _serverProvider.request(target: .routerList(reqMode))
    }
}
