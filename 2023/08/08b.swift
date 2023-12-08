import Foundation

let testInput: [String] = [
    "LR",
    "",
    "11A = (11B, XXX)",
    "11B = (XXX, 11Z)",
    "11Z = (11B, XXX)",
    "22A = (22B, XXX)",
    "22B = (22C, 22C)",
    "22C = (22Z, 22Z)",
    "22Z = (22B, 22B)",
    "XXX = (XXX, XXX)"
]
let testSolution: Int = 6

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

struct Node: Hashable, Identifiable {
    var id: String
    var left: String
    var right: String
}

func findPrimesUntil(limit: Int) -> [Int]? {
    guard limit > 1 else {
        return nil
    }

    var primes: [Bool] =  [Bool](repeating: true, count: limit + 1)

    for i in 0..<2 {
        primes[i] = false
    }

    for j in 2..<primes.count where primes[j] {
        var k: Int = 2
        while k * j < primes.count {
            primes[k * j] = false
            k += 1
        }
    }

    return primes.enumerated().compactMap { (index: Int, element: Bool) -> Int? in
        if element {
            return index
        }
        return nil
    }
}

func leastCommonMultiple(numbers: [Int]) -> Int {
    guard let primes = findPrimesUntil(limit: numbers.max()!) else {
        return numbers.reduce(1, *)
    }
    var values = numbers
    var res: Int = 1
    var currPrimeIdx: Int = 0
    while values.contains(where: { $0 != 1 }) {
        var found: Bool = false
        for (idx, value) in values.enumerated() {
            if value % primes[currPrimeIdx] == 0 {
                values[idx] /= primes[currPrimeIdx]
                found = true
            }
        }
        if !found {
            currPrimeIdx += 1
        } else {
            res *= primes[currPrimeIdx]
        }
    }
    return res
}

func solvePuzzle(input: [String]) -> Int {
    let instructions = Array(input[0])
    var nodes: [String: Node] = [:]
    for node in input.dropFirst(2) {
        let id = String(node.split(separator: " = ")[0])
        let destinations = node.split(separator: " = ")[1]
        nodes[id] = Node(id: id,
                left: String(destinations.split(separator: ", ")[0].dropFirst()),
                right: String(destinations.split(separator: ", ")[1].dropLast()))
    }

    let currentNodes = nodes.filter { Array($0.key).last! == "A" }.map { return $0.value }
    var steps: [Int] = []

    for node in currentNodes {
        var currentNode = node
        var tmpSteps: Int = 0
        var nextStep: Int = 0

        while true {
            let direction = instructions[nextStep]

            switch direction {
            case "L":
                currentNode = nodes[currentNode.left]!
            case "R":
                currentNode = nodes[currentNode.right]!
            default:
                print("No direction")
            }

            tmpSteps += 1
            if (nextStep == instructions.count - 1) {
                nextStep = 0
            } else {
                nextStep += 1
            }

            if (Array(currentNode.id).last! == "Z") {
                steps.append(tmpSteps)
                break
            }
        }
    }

    return leastCommonMultiple(numbers: steps)
}

print("AoC Day 08b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
