//
//  Sequence+Helpers.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/8.
//

import Foundation

extension Sequence where Element: Numeric {
    var sum: Element {
        return reduce(0, +)
    }
    
    var product: Element {
        return reduce(1, *)
    }
}

extension Sequence {
    func count(where: (Element) -> Bool) -> Int {
        return filter(`where`).count
    }
}
