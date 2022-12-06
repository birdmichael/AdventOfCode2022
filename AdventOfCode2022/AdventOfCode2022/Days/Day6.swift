//
//  Day6.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/6.
//

import Dispatch
import Foundation

final class Day6: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        findLongestSubstring(from: input, distinct: 4)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        findLongestSubstring(from: input, distinct: 14)
    }

    func findLongestSubstring(from input: String, distinct: Int) -> Int {
        let inputArray = Array(input)
        var start = 0
        var end = distinct - 1

        while end < inputArray.count {
            let subArray = inputArray[start ... end]
            if Set(subArray).count == distinct {
                return start + distinct
            }
            start += 1
            end += 1
        }
        return -1
    }
}
