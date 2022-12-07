//
//  TreeRepresentable.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/7.
//

import Foundation

protocol TreeRepresentable {
    static var representableName: KeyPath<Self, String> { get }
    static var representableSubNode: KeyPath<Self, [Self]> { get }
}
