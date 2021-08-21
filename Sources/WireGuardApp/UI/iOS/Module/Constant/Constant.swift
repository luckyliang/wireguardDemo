// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let WIDTH_NIT = SCREEN_WIDTH / 375

//状态栏高度
func statusBarHeight() -> CGFloat {
    return IS_IPHONE_X() ? 44.0 : 20.0
}

let NavigationBarHeight = 44.0

//tabBarHeight
func tabBarHeight() -> CGFloat {
    return IS_IPHONE_X() ? (49.0 + 34.0) : 49.0
}

/**TabbarSafe底部安全间距*/
func tabbarSafeBottomMargin() -> CGFloat {
    return IS_IPHONE_X() ? 34.0 : 0.0
}

/**StatusBar&NavigationBar高度*/
func statusBarAndNavigationBarHeight() -> CGFloat {
    return IS_IPHONE_X() ? 88.0 : 64.0
}

/**内容视图视图安全区域*/
func viewSafeAreInsets(view: UIView) -> UIEdgeInsets {
    guard #available(iOS 11.0, *) else {
        return .zero
    }
    return view.safeAreaInsets
}

let IPHONE_4         =     UIScreen.main.bounds.size.height == 480.0
let IPHONE_5         =     UIScreen.main.bounds.size.height == 568.0
let IPHONE_6         =     UIScreen.main.bounds.size.height == 667.0
let IPHONE_6_PLUS    =     UIScreen.main.bounds.size.height == 736.0
let IPHONE_X         =     UIScreen.main.bounds.size.height == 812.0
let IPHONE_XR        =     UIScreen.main.bounds.size.height == 896.0

func IS_IPHONE_X() -> Bool {

    guard #available(iOS 11.0, *) else {
        return false
    }

    guard let widown = UIApplication.shared.windows.first, widown.safeAreaInsets.bottom > 0 else {
        return false
    }

    return true
}
