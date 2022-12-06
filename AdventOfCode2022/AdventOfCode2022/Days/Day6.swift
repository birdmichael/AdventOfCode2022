//
//  Day6.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/6.
//

import Algorithms
import Foundation

final class Day6: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        findMarker(with: 4, input: input)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        findMarker(with: 14, input: input)
    }

    func findMarker(from input: String, distinct: Int) -> Int {
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

    func findMarker(with range: Int, input: String) -> Int {
        Array(input)
            .indexed()
            .windows(ofCount: range)
            .first { windowSlice in
                Set(windowSlice.map(\.element)).count == range
            }!
            .last!
            .index + 1
    }
}
