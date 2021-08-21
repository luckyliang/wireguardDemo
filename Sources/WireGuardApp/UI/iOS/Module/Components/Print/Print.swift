//
//  Print.swift
//  Composite
//
//  Created by Django on 12/21/19.
//  Copyright © 2019 LeeGame. All rights reserved.
//

import Foundation

#if DEBUG
public func printDebug(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    assertMessage: String? = nil,
    file: String = #file,
    function: String = #function,
    line: Int = #line) {
    if let msg = assertMessage {
        assertionFailure(msg)
    }
    let gFormatter = DateFormatter()
    gFormatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = gFormatter.string(from: Date())
    let queue = Thread.isMainThread ? "UI" : "BG"
    let fileURL = URL(string: file)?.lastPathComponent ?? "Unknown file"
    Swift.print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: ")
    var idx = items.startIndex
    let endIdx = items.endIndex
    repeat {
        Swift.print(items[idx],
                    separator: separator,
                    terminator: idx == (endIdx - 1) ? terminator : separator)
        idx += 1
    } while idx < endIdx
}

public func printDebug<Target>(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    assertMessage: String? = nil,
    to output: inout Target,
    file: String = #file,
    function: String = #function,
    line: Int = #line) where Target : TextOutputStream {
    if let msg = assertMessage {
        assertionFailure(msg)
    }
    let gFormatter = DateFormatter()
    gFormatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = gFormatter.string(from: Date())
    let queue = Thread.isMainThread ? "UI" : "BG"
    let fileURL = URL(string: file)?.lastPathComponent ?? "Unknown file"
    var idx = items.startIndex
    let endIdx = items.endIndex
    var resString: String = .empty
    repeat {
        var temString: String = .empty
        Swift.print(items[idx],
                    separator: separator,
                    terminator: idx == (endIdx - 1) ? terminator : separator,
                    to: &temString)
        resString.append(temString)
        idx += 1
    } while idx < endIdx
    if let res = resString as? Target {
        output = res
    }
    Swift.print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]:")
    Swift.print(resString)
}
#else
public func printDebug(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    assertMessage: String? = nil) {
}

public func printDebug<Target>(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    assertMessage: String? = nil,
    to output: inout Target) {
}
#endif
