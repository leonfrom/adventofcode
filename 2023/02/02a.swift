import Foundation

let testInput: [String] = [
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
]
let testSet: Dictionary = ["red": 12, "green": 13, "blue": 14]
let testSolution: Int = 8

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")
let puzzleSet: Dictionary = ["red": 12, "green": 13, "blue": 14]

func solvePuzzle(input: [String], set: Dictionary <String, Int>) -> Int {
    var possibleIDs: [Int] = [];

    for line in input {
        let gameID = line.split(separator: ":")[0].components(separatedBy: .decimalDigits.inverted).filter { !$0.isEmpty }[0]
        let gameSets = line.split(separator: ": ")[1].split(separator: "; ")
        var gamePossible: Bool = true

        for sets in gameSets {
            let counts = sets.split(separator: ", ")

            for count in counts {
                let number: Int = Int(count.split(separator: " ")[0])!
                let color: String = String(count.split(separator: " ")[1])
                
                if (number > set[color]!) {
                    gamePossible = false
                    break
                }
            }
        }

        if (gamePossible) {
            possibleIDs.append(Int(gameID)!)
        }
    }

    let output: Int = possibleIDs.reduce(0, +)
    return output
}

print("AoC Day 02a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput, set: testSet)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput, set: puzzleSet))")
}