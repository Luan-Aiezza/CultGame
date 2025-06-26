//
//  Utilities.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 25/06/25.
//

import Foundation
import UniformTypeIdentifiers

extension Int {
    func positiveMod(_ m: Int) -> Int {
        if m != 0 {
            let r = self % m
            return r < 0 ? r + m : r
        } else {
            return 0
        }
    }
}

extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: (Key) -> T) -> [T: Value] {
        Dictionary<T, Value>(uniqueKeysWithValues: self.map { (transform($0.key), $0.value) })
    }
}

//UTI
extension UTType {
    static let card: UTType = UTType(exportedAs: "card")
}
