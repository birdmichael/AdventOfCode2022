//
//  main.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/4.
//

import Algorithms
import Foundation

func run(dayNumber: Int, inputPath: String) {
    guard let dayClass = Bundle.main.classNamed("AdventOfCode2022.Day\(dayNumber)") as? Day.Type
    else {
        debugPrint("Day \(dayNumber) could not be initialized")
        return
    }

    guard let input = try? String(contentsOfFile: (inputPath as NSString).appendingPathComponent("day\(dayNumber).txt"))
    else {
        debugPrint("Could not read day\(dayNumber).txt file")
        return
    }
    let day = dayClass.init()

    print("===Day \(dayNumber)===")

    let part1StartDate = Date()
    let part1 = day.part1(input)
    print("Part 1 (\(-part1StartDate.timeIntervalSinceNow * 1000) ms): \(part1)")

    let part2StartDate = Date()
    let part2 = day.part2(input)
    print("Part 2 (\(-part2StartDate.timeIntervalSinceNow * 1000) ms): \(part2)")
    print("")
}

var dayNumber: Int?
var inputPath: String?

CommandLine.arguments.adjacentPairs().forEach { arg1, arg2 in
    switch arg1 {
    case "-i":
        inputPath = arg2
    default:
        break
    }
}

guard let inputPath = inputPath else {
    fatalError("Please provide the path to the inputs using the -i command line argument")
}

while(true) {
    print("Please enter dayNumber\n")

    if let readNumber = Int(readLine()?.lines.first ?? "") {
        dayNumber = readNumber
    } else {
       print("please input dayNumber")
    }
    
    if let dayNumber = dayNumber {
        // If a day is specified, just run that single day
        run(dayNumber: dayNumber, inputPath: inputPath)
    } else {
        // Otherwise, run all the days
        for i in 1 ... 25 {
            run(dayNumber: i, inputPath: inputPath)
        }
    }
    print("""

========= End =======

""")
    sleep(1)
}

