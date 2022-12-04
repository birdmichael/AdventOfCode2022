//
//  String+Extension.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/4.
//

import Foundation

extension String {
    var lines: [Substring] {
        split(separator: "\n")
    }
    
    var ints: [Int] {
        lines.compactMap { Int($0) }
    }
}
