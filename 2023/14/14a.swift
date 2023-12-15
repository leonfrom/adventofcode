import Foundation

let testInput: [String] = [
    "O....#....",
    "O.OO#....#",
    ".....##...",
    "OO.#O....O",
    ".O.....O#.",
    "O.#..O.#.#",
    "..O..#O..O",
    ".......O..",
    "#....###..",
    "#OO..#...."
]
let testSolution: Int = 136

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

enum Element {
    case roundRock
    case cubeRock
    case empty
}

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []
    var map: [[Element]] = []

    for line in input {
        map.append(line.map {
            if ($0 == "O") {
                return .roundRock
            } else if ($0 == "#") {
                return .cubeRock
            } else {
                return .empty
            }
        })
    }

    var canMove = true
    while canMove {
        canMove = false
        for y in 1..<map.count {
            for x in 0..<map[y].count {
                if (map[y][x] == .roundRock) {
                    if (map[y - 1][x] == .empty) {
                        canMove = true
                        map[y - 1][x] = .roundRock
                        map[y][x] = .empty
                    }
                }
            }
        }
    }

    for y in 0..<map.count {
        for x in 0..<map[y].count {
            if (map[y][x] == .roundRock) {
                numberStore.append(map.count - y)
            }
        }
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 14a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
