import Foundation

let testInput: [String] = [
    "two1nine",
    "eightwothree",
    "abcone2threexyz",
    "xtwone3four",
    "4nineeightseven2",
    "zoneight234",
    "7pqrstsixteen"
]
let testSolution: Int = 281

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

extension String {
    var isNumber: Bool {
        let digitsCharacters: CharacterSet = CharacterSet(charactersIn: "0123456789")        
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []

    for row in input {
        let charArray = row.map { return $0 }
        var digits: [Int] = []

        charArray.enumerated().forEach { (char_index, char) in
            if (char.isNumber) {
                digits.append(char.wholeNumberValue ?? 0)
            }

            ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"].enumerated().forEach { (word_index, word) in
                if (row.dropFirst(char_index).starts(with: word)) {
                    digits.append(word_index + 1)
                }
            }
        }

        numberStore.append(Int("\(digits.first!)\(digits.last!)") ?? 0)
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 01b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}