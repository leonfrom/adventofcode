import Foundation

let testInput: [String] = [
    "1abc2",
    "pqr3stu8vwx",
    "a1b2c3d4e5f",
    "treb7uchet"
]
let testSolution: Int = 142

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

        for char in charArray {
            if (char.isNumber) {
                digits.append(char.wholeNumberValue ?? 0)
            }
        }

        numberStore.append(Int("\(digits.first!)\(digits.last!)") ?? 0)
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 01a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
