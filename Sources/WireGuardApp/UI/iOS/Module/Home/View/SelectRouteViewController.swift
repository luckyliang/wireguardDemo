// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit
import RxCocoa
import RxSwift
class SelectRouteViewController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet private weak var _topBgView: UIView!
    @IBOutlet private weak var _tableView: UITableView!

    private var _tunnelViewModel:  TunnelViewModel = TunnelViewModel(tunnelConfiguration: nil)
    private var _tunnelsManager: TunnelsManager?

    private let _viewModel = RouterListViewModel()
    private let _disposeBag = DisposeBag()

    public  let selectItemModel = PublishRelay<TunnelContainer>()
    private var _onDemandViewModel: ActivateOnDemandViewModel = ActivateOnDemandViewModel()

    private var _headerView: RouteHeaderView?
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupView()
        _bindData()
    }

//    init(tunnelsManager: TunnelsManager) {
//        _tunnelsManager = tunnelsManager
////        _tunnelViewModel = TunnelViewModel(tunnelConfiguration: nil)
////        _onDemandViewModel = ActivateOnDemandViewModel()
//
//        super.init()
//    }
    public func setTunnelsManager(manager: TunnelsManager) {
        _tunnelsManager = manager
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


//        _tableView.rx.modelSelected(RouterItemModel.self)
//            .asDriver()
//            .drive(onNext: {[weak self] itemModel in
//                self?.selectItemModel.accept(itemModel)
//                self?.dismiss(animated: true, completion: nil)
//            })
//            .disposed(by: _disposeBag)


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
        guard let routeCell = cell as? RouteTableViewCell else { return cell }
        routeCell.itemModel = _viewModel.dataRelay.value[indexPath.item]
        return routeCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemModel = _viewModel.dataRelay.value[indexPath.item]
        _saveConfig(itemModel)
//        selectItemModel.accept(itemModel)
//        dismiss(animated: true, completion: nil)
    }
}

extension SelectRouteViewController {

    //保存配置
    private func _saveConfig(_ itemModel: RouterItemModel) {
        //先根据名字判断是否存在通道Container
        if let tunnelConfig = _tunnelsManager?.tunnel(named: itemModel.name)  {
            //已经存在不需要再保存
            selectItemModel.accept(tunnelConfig)
            dismiss(animated: true, completion: nil)
            return
        }

        //配置接口和通道
       _configInterfaceAndPeer(itemModel)

        let tunnelSaveResult = _tunnelViewModel.save()
        switch tunnelSaveResult {
        case .error(let errorMessage):
            let alertTitle = (_tunnelViewModel.interfaceData.validatedConfiguration == nil || _tunnelViewModel.interfaceData.validatedName == nil) ?
                tr("alertInvalidInterfaceTitle") : tr("alertInvalidPeerTitle")
            ErrorPresenter.showErrorAlert(title: alertTitle, message: errorMessage, from: self)
//            tableView.reloadData() // Highlight erroring fields
        case .saved(let tunnelConfiguration):
            let onDemandOption = _onDemandViewModel.toOnDemandOption()
//            //如果编辑
//            if let tunnel = tunnel {
//                // We're modifying an existing tunnel
//                tunnelsManager.modify(tunnel: tunnel, tunnelConfiguration: tunnelConfiguration, onDemandOption: onDemandOption) { [weak self] error in
//                    if let error = error {
//                        ErrorPresenter.showErrorAlert(error: error, from: self)
//                    } else {
//                        self?.dismiss(animated: true, completion: nil)
//                        self?.delegate?.tunnelSaved(tunnel: tunnel)
//                    }
//                }
//            } else {
                //新增
                // We're adding a new tunnel
                _tunnelsManager?.add(tunnelConfiguration: tunnelConfiguration, onDemandOption: onDemandOption) { [weak self] result in
                    switch result {
                    case .failure(let error):
                        ErrorPresenter.showErrorAlert(error: error, from: self)
                    case .success(let tunnel):
                        self?.selectItemModel.accept(tunnel)
                        self?.dismiss(animated: true, completion: nil)

//                        self?.delegate?.tunnelSaved(tunnel: tunnel)
                    }
                }
//            }
        }
    }

    //赋值
    private func _configInterfaceAndPeer(_ itemModel:  RouterItemModel) {
        //配置interface
        let interface = itemModel.interface
        _tunnelViewModel.interfaceData[.privateKey] = interface.privateKey
        _tunnelViewModel.interfaceData[.name] = itemModel.name
        _tunnelViewModel.interfaceData[.addresses] = interface.address
        _tunnelViewModel.interfaceData[.dns] = interface.dns

        //配置peer
        _tunnelViewModel.appendEmptyPeer()

        let peer = itemModel.peer
        guard let peerData = _tunnelViewModel.peersData.first else { return  }
        peerData[.publicKey] = peer.publicKey
        peerData[.endpoint] = peer.endPoint
        peerData[.allowedIPs] = peer.allowedIps
        peerData[.persistentKeepAlive] = peer.persistentKeepalive

    }


//
//    private func _saveInterface(name: String, _ interfaceModel: RouterItemModel.RouterInterface) -> InterfaceConfiguration? {
//
//        //privateKey
//        guard  interfaceModel.privateKey.count == TunnelViewModel.keyLengthInBase64, let privateKey = PrivateKey(base64Key: interfaceModel.privateKey) else {
//            printDebug("interface缺少privateKey")
//            return nil
//        }
//        //publicKey这个不需要用，可以打印出来跟服务端对比是否正确
//        let publicKey = privateKey.publicKey.base64Key
//        printDebug("publicKey = \(publicKey)")
//
//        var config = InterfaceConfiguration(privateKey: privateKey)
//
//        //配置局域网ip地址
//        var addresses = [IPAddressRange]()
//        for addressString in interfaceModel.address.splitToArray(trimmingCharacters: .whitespacesAndNewlines) {
//            if let address = IPAddressRange(from: addressString) {
//                addresses.append(address)
//            } else {
//                printDebug("局域网ip地址无效")
//                return nil
//            }
//        }
//        config.addresses = addresses
//
//        //监听端口和mtu目前按自动配置,这里不配置
//        //dns可选配置
//        let dnsString = interfaceModel.dns
//        if !dnsString.isEmpty {
//            var dnsServers = [DNSServer]()
//            var dnsSearch = [String]()
//            for dnsServerString in dnsString.splitToArray(trimmingCharacters: .whitespacesAndNewlines) {
//                if let dnsServer = DNSServer(from: dnsServerString) {
//                    dnsServers.append(dnsServer)
//                } else {
//                    dnsSearch.append(dnsServerString)
//                }
//            }
//            config.dns = dnsServers
//            config.dnsSearch = dnsSearch
//        }
//        return config
//
//    }


}
