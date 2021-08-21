// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit

class RouteHeaderView: UIView {
    @IBOutlet weak var _refreshBtn: UIButton!
    @IBOutlet weak var _modelSelectBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        _modelSelectBtn.reloadLayout(.right, 5)
    }

}

