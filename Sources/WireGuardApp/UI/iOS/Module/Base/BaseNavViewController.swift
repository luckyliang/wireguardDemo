// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit

class BaseNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {

        return super.pushViewController(viewController, animated: true)
    }
}
