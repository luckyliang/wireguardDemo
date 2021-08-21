//
//  URL+Extension.swift
//  Composite
//
//  Created by Django on 2/7/20.
//  Copyright © 2020 LeeGame. All rights reserved.
//

import Foundation

extension URL {
    public enum DomianProtocol: String {
        case http
        case https
    }

    public func switchProtocol(_ domainProtocol: DomianProtocol = .https) -> URL? {
        let oldUrlString = absoluteString
        guard let oldProtocolString = scheme,
            let oldProtocolRange = oldUrlString.range(of: oldProtocolString) else {
            return self
        }
        let newString = oldUrlString.replacingOccurrences(of: oldProtocolString,
                                                          with: domainProtocol.rawValue,
                                                          range: oldProtocolRange)
        return newString.urlValue
    }

    public func getBaseUrl() -> URL? {
        guard let schemeT = scheme, let hostT = host else { return nil }
        return (schemeT + "://" + hostT).urlValue
    }
}
