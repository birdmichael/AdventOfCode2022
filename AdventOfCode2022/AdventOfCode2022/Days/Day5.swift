//
//  Day5.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/5.
//

import Foundation
import RegexBuilder

final class Day5: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        var model = parseInput(input: input.lines)
        return moveCrates(crates: &model.0, moves: model.1, oneByOne: true)
    }

    func part2(_ input: String) -> CustomStringConvertible {
        var model = parseInput(input: input.lines)
        return moveCrates(crates: &model.0, moves: model.1, oneByOne: false)
    }

    func parseInput(input: [String]) -> (Crates, [Move]) {
        let rowData = input.split(whereSeparator: \.isEmpty)
        let crates = parseCrates(rowData[0])
        let moves = parseMoves(rowData[1])
        return (crates, moves)
    }

    func parseCrates(_ input: some Collection<String>) -> Crates {
        var crates = Crates()
        crates.items = input.reduce(into: Crates.ItemType()) { stacks, line in
            for (i, char) in line.enumerated() {
                guard char.isLetter else { continue }
                stacks[(i / 4) + 1, default: []].insert(char, at: 0)
            }
        }
        return crates
    }

    func parseMoves(_ input: some Collection<String>) -> [Move] {
        return input.map(Move.init)
    }

    private func moveCrates(crates: inout Crates, moves: [Move], oneByOne: Bool) -> String {
        moves.forEach { crates.move($0, oneByOne: oneByOne) }
        return crates.topOfEach
            .map { String($0) }
            .joined()
    }
}

extension Day5 {
    struct Move {
        let amount: Int
        let from: Int
        let to: Int

        init(_ str: String) {
            let numbers = Capture { OneOrMore(.digit) } transform: { Int($0)! }

            let lineParser = Regex {
                "move "
                numbers
                " from "
                numbers
                " to "
                numbers
            }

            let match = try! lineParser.wholeMatch(in: str)!.output
            amount = match.1
            from = match.2
            to = match.3
        }
    }

    struct Crates {
        typealias ItemType = [Int: [Character]]

        var items: ItemType = [:]

        mutating func move(_ move: Move, oneByOne: Bool) {
            let moveFrom = items[move.from]!
            items[move.from] = moveFrom.dropLast(move.amount)
            var moving = Array(moveFrom.suffix(move.amount))
            if oneByOne {
                moving = Array(moving.reversed())
            }
            items[move.to, default: []].append(contentsOf: moving)
        }

        var topOfEach: [Character] {
            items
                .sorted { $0.key < $1.key }
                .compactMap { $0.value.last }
        }
    }
}
