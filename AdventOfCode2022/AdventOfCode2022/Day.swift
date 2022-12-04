//
//  Day.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/4.
//

import Foundation

protocol Day: AnyObject {
    init()

    func part1(_ input: String) -> CustomStringConvertible
    func part2(_ input: String) -> CustomStringConvertible
}
