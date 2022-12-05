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
        input.forEach { line in
            line.enumerated().forEach { index, ch in
                if ch.isNumber || ch == " " {
                    return
                }
                if (index - 1).isMultiple(of: 4) {
                    let crate = 1 + (index - 1) / 4
                    crates.items[crate, default: []].insert(ch, at: 0)
                }
            }
        }

//        // better way:
//        var crates = Crates()
//        crates.items = input.reduce(into: Crates.ItemType()) { stacks, line in
//            for (i, char) in line.enumerated() {
//                guard char.isLetter else { continue }
//                stacks[(i / 4) + 1, default: []].insert(char, at: 0)
//            }
//        }
//
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
            let search = /move (\d+) from (\d+) to (\d+)/
            let result = try! search.wholeMatch(in: str)!
            amount = Int(result.1)!
            from = Int(result.2)!
            to = Int(result.3)!

//            // better way:
//            /// /move (\d+) from (\d+) to (\d+)/
//            /// Spaces are easily erased after formatting. 😊
//            ///
//            let numbers = Capture { OneOrMore(.digit) } transform: { Int($0)! }
//
//            let lineParser = Regex {
//                "move "
//                numbers
//                " from "
//                numbers
//                " to "
//                numbers
//            }
//
//            let match = try! lineParser.wholeMatch(in: str)!.output
//            amount = match.1
//            from = match.2
//            to = match.3
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


final class Day6: Day {
  func part1(_ input: String) -> CustomStringConvertible {
    let parts = input.components(separatedBy: "\n\n")
    var stacks = parseStacks(from: parts[0])
    let instructions = parseInstructions(from: parts[1])
    
    for (stackNumber, from, to) in instructions {
      for _ in 1...stackNumber {
        let val = stacks[from]!.popLast()!
        stacks[to]?.append(val)
      }
    }
    
    return stacks
      .keys
      .sorted()
      .map { String(stacks[$0]!.last!) }
      .joined()
  }
  
  func part2(_ input: String) -> CustomStringConvertible {
    let parts = input.components(separatedBy: "\n\n")
    var stacks = parseStacks(from: parts[0])
    let instructions = parseInstructions(from: parts[1])
    
    for (stackNumber, from, to) in instructions {
      var values = Array<Character>()
      for _ in 1...stackNumber {
        values.append(stacks[from]!.popLast()!)
      }
      
      for value in values.reversed() {
        stacks[to]?.append(value)
      }
    }
    
    return stacks
      .keys
      .sorted()
      .map { String(stacks[$0]!.last!) }
      .joined()
  }
  
  func parseStacks(from input: String) -> Dictionary<Int, Array<Character>> {
    input
      .lines
      .reduce(into: Dictionary<Int, Array<Character>>()) { stacks, line in
        for (i, char) in line.enumerated() {
          guard char.isLetter else { continue }
          stacks[(i / 4) + 1, default: []].insert(char, at: 0)
        }
      }
  }
  
  func parseInstructions(from input: String) -> [(stackNumber: Int, from: Int, to: Int)] {
    input
      .lines
      .map { line in
        let numbers = Capture { OneOrMore(.digit) } transform: { Int($0)! }
        
        let lineParser = Regex {
          "move "
          numbers
          " from "
          numbers
          " to "
          numbers
        }
        
        let match = try! lineParser.wholeMatch(in: line)!.output
        return (match.1, match.2, match.3)
      }
  }
}
