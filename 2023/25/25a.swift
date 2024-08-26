import Foundation

let testInput: [String] = [
    "jqt: rhn xhk nvd",
    "rsh: frs pzl lsr",
    "xhk: hfx",
    "cmg: qnr nvd lhk bvb",
    "rhn: xhk bvb hfx",
    "bvb: xhk hfx",
    "pzl: lsr hfx nvd",
    "qnr: nvd",
    "ntq: jqt hfx bvb xhk",
    "nvd: lhk",
    "lsr: lhk",
    "rzs: qnr cmg lsr rsh",
    "frs: qnr lhk lsr"
]
let testSolution: Int = 54

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func nodesInLine(start: String, components: [String: Set<String>]) -> Set<String> {
    var result = Set<String>()
    var nodes = [start]
    while let s = nodes.popLast() {
        result.insert(s)
        for next in components[s]! {
            if result.contains(next) { continue }
            nodes.append(next)
        }
    }
    return result
}

func solvePuzzle(input: [String]) -> Int {
    var components: [String: Set<String>] = [:]
    var triedCuts: Set<Set<Set<String>>> = Set<Set<Set<String>>>()

    for line in input {
        let name = String(line.split(separator: ": ")[0])
        let connectedTo = line.split(separator: ": ")[1].split(separator: " ").map { String($0) }
        components[name, default: []].formUnion(connectedTo)
        for node in connectedTo {
            components[node, default:[]].insert(name)
        }
    }

    var groupOne: Int = 0
    var groupTwo: Int = 0
    while true {
        var componentCopy = components
        var randomNodes: Set<String> = Set<String>()

        while randomNodes.count < 6 {
            randomNodes.insert(componentCopy.keys.randomElement()!)
        }

        let nodeArray = randomNodes.map { String($0) }
        if (triedCuts.contains(where: {$0.contains([nodeArray[0], nodeArray[1]])
                                        && $0.contains([nodeArray[2], nodeArray[3]])
                                        && $0.contains([nodeArray[4], nodeArray[5]])})) { continue }
        triedCuts.insert(Set([Set([nodeArray[0], nodeArray[1]]), Set([nodeArray[2], nodeArray[3]]), Set([nodeArray[4], nodeArray[5]])]))

        for p in [(nodeArray[0], nodeArray[1]), (nodeArray[2], nodeArray[3]), (nodeArray[4], nodeArray[5])] {
            componentCopy[p.0]?.remove(p.1)
            componentCopy[p.1]?.remove(p.0)
        }

        let start = componentCopy.keys.first!
        let nodesInLine1 = nodesInLine(start: start, components: componentCopy)
        groupOne = nodesInLine1.count
        if (Set(componentCopy.keys).subtracting(nodesInLine1).count > 0 && Set(componentCopy.keys).subtracting(nodesInLine1).count + nodesInLine1.count == components.count) {
            let start2 = Set(componentCopy.keys).subtracting(nodesInLine1).first!
            let nodesInLine2 = nodesInLine(start: start2, components: componentCopy)
            groupTwo = nodesInLine2.count
            break
        }
    }

    return groupOne * groupTwo
}

print("AoC Day 25a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
