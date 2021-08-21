// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit
import RxCocoa
import RxSwift
class SelectRouteViewController: BaseViewController {

    @IBOutlet private weak var _topBgView: UIView!
    @IBOutlet private weak var _tableView: UITableView!

    private let _viewModel = RouterListViewModel()
    private let _disposeBag = DisposeBag()

    public  let selectItemModel = PublishRelay<RouterItemModel>()

    private var _headerView: RouteHeaderView?
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupView()
        _bindData()
    }
}

//data
extension SelectRouteViewController {
    private func _bindData() {

        _viewModel.loadData()


        _viewModel.dataRelay
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?._tableView.reloadData()
            })
            .disposed(by: _disposeBag)


        _tableView.rx.modelSelected(RouterItemModel.self)
            .asDriver()
            .drive(onNext: {[weak self] itemModel in
                self?.selectItemModel.accept(itemModel)
            })
            .disposed(by: _disposeBag)

        _viewModel.viewStateDriver.asObservable()
            .subscribe(onNext: { [weak self] state in
                switch state{
                case .loading:
                    self?.view.makeActivity()
                case .success:
                    self?.view.hideToast()
                case .failedWith(let error):
                    self?.view.makeToast(error.errorDescription)
                default:
                    break
                }
            })
            .disposed(by: _disposeBag)
    }
}
//View
extension SelectRouteViewController {

    private func _setupView() {
        _configTopView()
        _configTableView()
    }

    private func _configTopView() {
        let temp = RouteHeaderView.createFromXib()
        _headerView = temp
        guard let headerView = temp else { return  }

        _topBgView.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        _headerView?._refreshBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?._viewModel.loadData()

        }).disposed(by: _disposeBag)
    }

    private func _configTableView() {
        _tableView.rowHeight = 44.0
        _tableView.dataSource = self
        _tableView.tableFooterView = UIView(frame: CGRect.zero)
        _tableView.register(RouteTableViewCell.nib(), forCellReuseIdentifier: RouteTableViewCell.indentify)
        _tableView.rx.setDelegate(self).disposed(by: _disposeBag)
    }
}

extension SelectRouteViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _viewModel.dataRelay.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = _tableView.dequeueReusableCell(withIdentifier: RouteTableViewCell.indentify, for: indexPath)

        return cell
    }


}
