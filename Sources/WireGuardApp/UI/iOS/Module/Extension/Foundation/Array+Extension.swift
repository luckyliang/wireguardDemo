//
//  Array+Extension.swift
//  Games
//
//  Created by Django on 18/08/2019.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        return (0 <= index && count > index) ? self[index] : nil
    }

    public func getMaxCount(_ num: Int) -> [Element] {
        let numT: Int
        if num < 0 {
            let msg = "num can't be under 0"
            (msg, assertMessage: msg)
            numT = 0
        } else if num > count {
            let msg = "num can't be above the count"
            printDebug(msg, assertMessage: msg)
            numT = count
        } else {
            numT = num
        }
        return Array(self[0..<numT])
    }
}

extension NSArray {
    public subscript(safe index: Int) -> Element? {
        return (0 <= index && count > index) ? self[index] : nil
    }

    public func getMaxCount(_ num: Int) -> NSArray {
        return (self as Array).getMaxCount(num) as NSArray
    }
}
