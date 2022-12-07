//
//  TreePrinter.swift
//  AdventOfCode2022
//
//  Created by bm on 2022/12/7.
//

import Foundation

class TreePrinter {
    public struct TreePrinterOptions {
        public let spacesPerDepth: Int
        public let spacer: String
        public let verticalLine: String
        public let intermediateConnector: String
        public let finalConnector: String
        public let connectorSuffix: String
        
        public init(spacesPerDepth: Int = 4,
                    spacer: String = " ",
                    verticalLine: String = "│",
                    intermediateConnector: String = "├",
                    finalConnector: String = "└",
                    connectorSuffix: String = "── ") {
            self.spacesPerDepth = spacesPerDepth
            self.spacer = spacer
            self.verticalLine = verticalLine
            self.intermediateConnector = intermediateConnector
            self.finalConnector = finalConnector
            self.connectorSuffix = connectorSuffix
        }
        
        public static var alternateDefaults: TreePrinterOptions {
            TreePrinterOptions(spacesPerDepth: 5,
                               spacer: " ",
                               verticalLine: "|",
                               intermediateConnector: "+",
                               finalConnector: "`",
                               connectorSuffix: "-- ")
        }
    }
    
    static func printTree<Node>(root: Node,
                                options: TreePrinterOptions = TreePrinterOptions()) -> String where Node: TreeRepresentable {
        return printNode(node: root,
                         depth: 0,
                         depthsFinished: Set(),
                         options: options)
    }
    
    private static func printNode<Node>(node: Node,
                                        depth: Int,
                                        depthsFinished: Set<Int>,
                                        options: TreePrinterOptions) -> String where Node: TreeRepresentable {
        var retVal = ""
        
        for i in 0 ..< max(depth - 1, 0) * options.spacesPerDepth {
            if i % options.spacesPerDepth == 0, !depthsFinished.contains(i / options.spacesPerDepth + 1) {
                retVal += options.verticalLine
            } else {
                retVal += options.spacer
            }
        }
        
        if depth > 0 {
            if depthsFinished.contains(depth) {
                retVal += options.finalConnector
            } else {
                retVal += options.intermediateConnector
            }
            
            retVal += options.connectorSuffix
        }
        retVal += node[keyPath: Node.representableName].description
        retVal += "\n"
        
        for (index, subnode) in node[keyPath: Node.representableSubNode].enumerated() {
            var newDepthsFinished = depthsFinished
            if depth == 0 {
                newDepthsFinished.insert(depth)
            }
            if index == node[keyPath: Node.representableSubNode].count - 1 {
                newDepthsFinished.insert(depth + 1)
            }
            retVal += printNode(node: subnode,
                                depth: depth + 1,
                                depthsFinished: newDepthsFinished,
                                options: options)
        }
        
        return retVal
    }
}
