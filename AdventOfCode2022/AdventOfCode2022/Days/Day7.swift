//
//  Day7.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/7.
//

import Algorithms
import Foundation

final class Day7: Day {
    func part1(_ input: String) -> CustomStringConvertible {
        getTree(from: input)
            .sizes()
            .filter { $0 <= 100000 }
            .sum
    }

    func part2(_ input: String) -> CustomStringConvertible {
        let tree = getTree(from: input)
        let treeSize = tree.size()
        let sizeNeeded = 40000000
        let toDelete = treeSize - sizeNeeded
        return tree
            .sizes()
            .filter { $0 >= toDelete }
            .min()!
    }

    func getTree(from input: String) -> Directory {
        let instructions = input
            .lines
            .chunked { _, next in !next.starts(with: "$") }

        let rootDir = Directory(name: "/")
        var currentDir = rootDir

        for instruction in instructions {
            let command = instruction.first!
            let directories = instruction.dropFirst()

            switch command.dropFirst(2).prefix(2) {
                case "cd":
                    let newDirName = String(command.dropFirst(5))

                    switch newDirName {
                        case "..": currentDir = currentDir.parent!
                        case "/": break
                        default:
                            if let existingDir = currentDir.subdirectories.first(where: { $0.name == newDirName }) {
                                currentDir = existingDir
                            } else {
                                let newSubdir = Directory(name: newDirName)
                                currentDir.subdirectories.append(newSubdir)
                                newSubdir.parent = currentDir
                                currentDir = newSubdir
                            }
                    }
                case "ls":
                    for directory in directories {
                        if directory.starts(with: "dir") {
                            let newDir = Directory(name: String(directory.dropFirst(4)))
                            currentDir.subdirectories.append(newDir)
                            newDir.parent = currentDir
                        } else {
                            let components = directory.split(separator: " ")
                            let fileSize = Int(components.first!)!
                            let fileName = String(components.last!)
                            currentDir.files[fileName] = fileSize
                        }
                    }
                default: fatalError("bad input")
            }
        }

        return rootDir
    }
}

extension Day7 {
    final class Directory {
        weak var parent: Directory?

        var name: String
        var subdirectories: [Directory] = []
        var files: [String: Int] = [:]

        init(name: String, subdirectories: [Directory] = [], files: [String: Int] = [:]) {
            self.name = name
            self.subdirectories = subdirectories
            self.files = files
        }

        func size() -> Int {
            files.values.reduce(0, +)
                + subdirectories.map { $0.size() }.reduce(0, +)
        }

        func sizes() -> [Int] {
            [size()] + subdirectories.flatMap { $0.sizes() }
        }
    }
}

extension Day7.Directory: TreeRepresentable {
    static var representableName: KeyPath = \Day7.Directory.name
    static var representableSubNode: KeyPath = \Day7.Directory.subdirectories
}
