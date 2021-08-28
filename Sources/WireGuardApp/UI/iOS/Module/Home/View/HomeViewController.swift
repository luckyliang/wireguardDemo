// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit
import TXScrollLabelView
import SnapKit
import SDCycleScrollView
import RxCocoa
import RxSwift

let lastTunnlNameKey = "lastTunnlName"

class HomeViewController: BaseViewController {


    var tunnelsManager: TunnelsManager?
    var onTunnelsManagerReady: ((TunnelsManager) -> Void)?
    var _currentTunnels: TunnelContainer? {
        didSet {
            returnRoute.text = _currentTunnels?.name
            nameObservationToken = _currentTunnels?.observe(\.name) { [weak self] tunnel, _ in
                self?.returnRoute.text = tunnel.name
            }
            statusObservationToken = _currentTunnels?.observe(\.status) { [weak self] tunnel, _ in
                self?.update(from: tunnel.status, animated: true)
            }
        }
    }

    private var statusObservationToken: NSKeyValueObservation?
    private var nameObservationToken: NSKeyValueObservation?

    @IBOutlet private weak var imageCycleBgView: UIView!
    @IBOutlet private weak var titleCycleBgView: UIView!
    @IBOutlet private weak var statusBgView: UIView!
    @IBOutlet private weak var selectBgView: UIView!
    @IBOutlet private weak var returnRoute: UILabel!
    @IBOutlet private weak var modelType: UILabel!
    private let _disposeBag = DisposeBag()


    @IBOutlet weak var _connectBtn: UIButton!

    private var _scrollerLabelView: TXScrollLabelView?
    private var _scrollerImageView: SDCycleScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()
        _createManager()
        _setupView()
    }
}


//action
extension HomeViewController {

    //跳转到选择路线界面
    @objc private func _routerSelected() {
        guard let tunnelsManager = tunnelsManager else { return  }
//        let routeVC = SelectRouteViewController(tunnelsManager: tunnelsManager)
        let routeVC = SelectRouteViewController()
        routeVC.setTunnelsManager(manager: tunnelsManager)

        //选择路线回调
        routeVC.selectItemModel.subscribe(onNext:{ [weak self] itemModel in

            let userdefault = UserDefaults.standard
            userdefault.set(itemModel.name, forKey: lastTunnlNameKey)
            userdefault.synchronize()

            self?._currentTunnels = itemModel

        }).disposed(by: _disposeBag)

        present(routeVC, animated: true, completion: nil)
    }
    @objc func _connectBtnClick() {
        guard let tunnel = _currentTunnels else { return  }
        let connectStatus = tunnel.status

        switch connectStatus {
        case .active:
//            _connectBtn.setTitle("断开连接...", for: .normal)
            _startDisConnect(tunnel)
        case .inactive:
//            _connectBtn.setTitle("连接中...", for: .normal)
            _startConnect(tunnel)
        default:
            break
        }
    }

    //更新连接状态
    private func update(from status: TunnelStatus?, animated: Bool) {
        guard let status = status else {
//            reset(animated: animated)
            return
        }
        //只在断开连接和已连接状态下可点击
        _connectBtn.isEnabled = (status == .inactive || status == .active)
        switch status {
        case .inactive: //未连接状态
            _connectBtn.setTitle("连接", for: .normal)
        case .active: //已连接状态
            _connectBtn.setTitle("断开连接", for: .normal)
        default:
            printDebug("status = \(status)")
            break
        }

    }

    //开始连接
    private func _startConnect(_ tunnel: TunnelContainer) {
        tunnelsManager?.startActivation(of: tunnel)
    }

    //断开连接
    private func _startDisConnect(_ tunnel: TunnelContainer) {
        tunnelsManager?.startDeactivation(of: tunnel)
    }

}

//TunnelesManager
extension HomeViewController {
    private func _createManager () {
        VPNManager.shared.createTunnelsManager(_configMamager(_:))
    }

    private func _configMamager(_ manager: TunnelsManager?) {
        guard let tunnelsM = manager else { return  }
        tunnelsManager = tunnelsM
        tunnelsManager?.tunnelsListDelegate = self
        tunnelsManager?.activationDelegate = self

        //1.取出上次的配置
        guard let lastTunnlName = UserDefaults.standard.string(forKey: lastTunnlNameKey) else { return }
        self._currentTunnels = tunnelsManager?.tunnel(named: lastTunnlName)
        update(from: self._currentTunnels?.status, animated: true)

    }
}

extension HomeViewController: TunnelsManagerActivationDelegate {

    func tunnelActivationAttemptFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationAttemptError) {
        printDebug("连接尝试失败")
    }

    func tunnelActivationAttemptSucceeded(tunnel: TunnelContainer) {
        printDebug("尝试连接成功")

    }

    func tunnelActivationFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationError) {
        printDebug("连接失败")
//        _connectBtn.setTitle("连接", for: .normal)
    }

    func tunnelActivationSucceeded(tunnel: TunnelContainer) {
        printDebug("连接成功")
//        _connectBtn.setTitle("断开连接", for: .normal)
    }


}

extension HomeViewController: TunnelsManagerListDelegate {

    //通道增加成功回调
    func tunnelAdded(at index: Int) {

    }

    func tunnelModified(at index: Int) {

    }

    func tunnelMoved(from oldIndex: Int, to newIndex: Int) {

    }

    func tunnelRemoved(at index: Int, tunnel: TunnelContainer) {
    }

}


extension HomeViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {

    }
}

//View
extension HomeViewController {

    private func _setupView() {
        _connectBtn.addTarget(self, action: #selector(_connectBtnClick), for: .touchUpInside)
        let scrollerTitle = "温馨提示：尊敬的贵宾，您好，在测试在测试在测试在测试在测试在测试在测试在测试在测试在测试在测试在测试在测试"
        _createScrollerLabelViewWithTitle(titles: [scrollerTitle])
        _createScrollerImageView()
        _createSelecetView()
    }

    //路线选择
    private func _createSelecetView() {
        selectBgView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(_routerSelected))
        selectBgView.addGestureRecognizer(tap)
    }


    //跑马灯
    private func _createScrollerLabelViewWithTitle(titles: [String]){
        _scrollerLabelView?.removeFromSuperview()
        let temp = TXScrollLabelView(textArray: titles, type: .leftRight, velocity: 1.0, options: .curveEaseInOut, inset: .zero)?.then {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.scrollTitleColor = .darkGray
            $0.backgroundColor = .clear
            _scrollerLabelView = $0
        }

        if let used = temp {
            titleCycleBgView.addSubview(used)
            used.snp.makeConstraints{
                $0.edges.equalToSuperview()
            }
        }
        temp?.beginScrolling()
    }

    //轮播图
    private func _createScrollerImageView() {
        _scrollerImageView?.removeFromSuperview()
        let temp = SDCycleScrollView(frame: CGRect.zero, imageNamesGroup: ["scrollerImage02", "scrollerImage02"])?.then{
            $0.delegate = self
        }
        _scrollerImageView = temp

        if let used = temp {
            imageCycleBgView.addSubview(used)
            used.snp.makeConstraints{
                $0.left.equalTo(10)
                $0.right.equalTo(-10)
                $0.top.bottom.equalToSuperview()
            }
        }
    }
}


