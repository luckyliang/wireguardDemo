// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit
import TXScrollLabelView
import SnapKit
import SDCycleScrollView
import RxCocoa
import RxSwift

class HomeViewController: BaseViewController {

    @IBOutlet private weak var imageCycleBgView: UIView!
    @IBOutlet private weak var titleCycleBgView: UIView!
    @IBOutlet private weak var statusBgView: UIView!
    @IBOutlet private weak var selectBgView: UIView!
    @IBOutlet private weak var returnRoute: UILabel!
    @IBOutlet private weak var modelType: UILabel!
    private let _disposeBag = DisposeBag()


    private var _scrollerLabelView: TXScrollLabelView?
    private var _scrollerImageView: SDCycleScrollView?

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupView()
    }
}


//action
extension HomeViewController {
    @objc private func _routerSelected() {
        let routeVC = SelectRouteViewController()
        routeVC.selectItemModel.subscribe(onNext:{ _ in

        }).disposed(by: _disposeBag)
        present(routeVC, animated: true, completion: nil)
    }
}

extension HomeViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {

    }
}

//View
extension HomeViewController {

    private func _setupView() {
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


