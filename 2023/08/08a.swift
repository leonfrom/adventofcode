import Foundation

let testInput: [String] = [
    "LLR",
    "",
    "AAA = (BBB, BBB)",
    "BBB = (AAA, ZZZ)",
    "ZZZ = (ZZZ, ZZZ)"
]
let testSolution: Int = 6

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

struct Node: Hashable, Identifiable {
    var id: String
    var left: String
    var right: String
}

func solvePuzzle(input: [String]) -> Int {
    let instructions = Array(input[0])
    let nodes = input.dropFirst(2).map {
        let id = String($0.split(separator: " = ")[0])
        let destinations = $0.split(separator: " = ")[1]
        return Node(id: id,
                left: String(destinations.split(separator: ", ")[0].dropFirst()),
                right: String(destinations.split(separator: ", ")[1].dropLast()))
    }

    var currentNode = nodes.first { $0.id == "AAA" }!
    let destinationNode = "ZZZ"
    var steps = 0
    var nextStep: Int = 0

    while currentNode.id != destinationNode {
        let direction = instructions[nextStep]

        switch direction {
        case "L":
            currentNode = nodes.first { $0.id == currentNode.left }!
        case "R":
            currentNode = nodes.first { $0.id == currentNode.right }!
        default:
            print("No direction")
        }

        steps += 1
        if (nextStep == instructions.count - 1) {
            nextStep = 0
        } else {
            nextStep += 1
        }
    }

    return steps
}

print("AoC Day 08a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
