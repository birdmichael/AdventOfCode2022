//
//  Day4.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/5.
//

import Algorithms
import Foundation

final class Day4: Day {
    struct Range {
        let from: Int
        let to: Int
    }

    func part1(_ input: String) -> CustomStringConvertible {
        countDuplicateRanges(input: input, rangeCheck: contains)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        countDuplicateRanges(input: input, rangeCheck: overlaps)
    }

    private func countDuplicateRanges(input: String, rangeCheck: (Range, Range) -> Bool) -> Int {
        input
            .lines
            .map { $0.split(separator: ",") }
            .map(parseRanges)
            .filter { $0.crossCompareRangeCheck(with: rangeCheck) }
            .count
    }

    func parseRanges(line: [Substring]) -> [Range] {
        line.map {
            let fromTo = $0.split(separator: "-").map { Int($0)! }
            return Range(from: fromTo[0], to: fromTo[1])
        }
    }

    func contains(_ r1: Range, _ r2: Range) -> Bool {
        return r1.from <= r2.from && r2.to <= r1.to
    }

    func overlaps(_ r1: Range, _ r2: Range) -> Bool {
        return r1.to >= r2.from && r1.from <= r2.to
    }
}

extension Array where Element == Day4.Range {
    func crossCompareRangeCheck(with rangeCheck: (Day4.Range, Day4.Range) -> Bool) -> Bool {
        rangeCheck(self.first!, self.last!) || rangeCheck(self.last!, self.first!)
    }
}
