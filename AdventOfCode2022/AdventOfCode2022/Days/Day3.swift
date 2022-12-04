//
//  Day3.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/4.
//

import Algorithms
import Foundation

final class Day3: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        input
            .lines
            .map { priority(for: $0) }
            .reduce(0, +)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        input
            .lines
            .chunks(ofCount: 3)
            .map { badge(for: $0) }
            .reduce(0, +)
    }

    func priority(for rucksack: Substring) -> Int {
        let mid = rucksack.count / 2
        let compOne = rucksack.prefix(mid)
        let compTwo = rucksack.suffix(mid)
        let shared = Set(compOne).intersection(compTwo)
        return shared
            .map(\.priority)
            .reduce(0, +)
    }

    func badge(for group: some Collection<Substring>) -> Int {
        group
            .dropFirst()
            .reduce(into: Set(group.first!)) { characters, groupMember in
                characters.formIntersection(groupMember)
            }
            .map(\.priority)
            .reduce(0, +)
    }
}

extension Character {
    var priority: Int {
        Int(asciiValue! - (isUppercase ? 38 : 96))
    }
}
