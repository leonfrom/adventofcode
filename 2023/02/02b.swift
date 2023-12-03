import Foundation

let testInput: [String] = [
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
]
let testSolution: Int = 2286

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    var powers: [Int] = [];

    for line in input {
        let gameSets = line.split(separator: ": ")[1].split(separator: "; ")
        var minCubes: Dictionary = ["red": 0, "green": 0, "blue": 0]

        for sets in gameSets {
            let counts = sets.split(separator: ", ")

            for count in counts {
                let number: Int = Int(count.split(separator: " ")[0])!
                let color: String = String(count.split(separator: " ")[1])
                
                if (number >= minCubes[color]!) {
                    minCubes[color] = number
                }
            }
        }

        powers.append((minCubes["red"]! * minCubes["green"]! * minCubes["blue"]!))
    }

    let output: Int = powers.reduce(0, +)
    return output
}

print("AoC Day 02b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}