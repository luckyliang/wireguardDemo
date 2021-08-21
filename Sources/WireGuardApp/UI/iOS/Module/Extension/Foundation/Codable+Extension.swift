//
//  Codable+Extension.swift
//  Composite
//
//  Created by Django on 4/6/20.
//  Copyright © 2020 LeeGame. All rights reserved.
//

import Foundation

extension Encodable {
    public func dictValue() -> [String: Any]? {
        if let jsonData = try? JSONEncoder().encode(self),
            let dict = String(data: jsonData, encoding: .utf8)?.dictValue {
            return dict
        } else {
            return nil
        }
    }
}
