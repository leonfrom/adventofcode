import Foundation

let testInput: [String] = [
    "???.### 1,1,3",
    ".??..??...?##. 1,1,3",
    "?#?#?#?#?#?#?#? 1,3,1,6",
    "????.#...#... 4,1,1",
    "????.######..#####. 1,6,5",
    "?###???????? 3,2,1"
]
let testSolution: Int = 525152

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func countArrangements(symbolGroups: String, numbers: [Int]) -> Int {
    let firstNumber = numbers[0]
    let restLength = numbers.dropFirst().reduce(0, +) + numbers.count - 1
    var count = 0

    for firstPosition in 0...(symbolGroups.count - restLength - firstNumber) {
        let pre = String(repeating: ".", count: firstPosition) + String(repeating: "#", count: firstNumber) + "."
        if (isPossiblePrefix(pre: pre, row: symbolGroups)) {
            if (numbers.count == 1) {
                if (!symbolGroups.dropFirst(pre.count).contains("#")) {
                    count += 1
                }
            } else {
                let startIndex = symbolGroups.index(symbolGroups.startIndex, offsetBy: pre.count)
                let remainingSymbols = String(symbolGroups[startIndex...])
                count += countArrangements(symbolGroups: remainingSymbols, numbers: Array(numbers.dropFirst()))
            }
        }
    }

    return count
}

func isPossiblePrefix(pre: String, row: String) -> Bool {
    if (pre.count > row.count) {
        if (pre.dropFirst(row.count).contains("#")) {
            return false
        }
    }

    for (char1, char2) in zip(pre, row) {
        if (char1 != char2 && char2 != "?") {
            return false
        }
    }

    return true
}

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []

    for line in input {
        var symbolGroups: String = ""
        for _ in 0..<5 {
            if (symbolGroups.count == 0) {
                symbolGroups += line.split(separator: " ")[0]
            } else {
                symbolGroups += "?\(line.split(separator: " ")[0])"
            }
        }
        var numbers: [Int] = []
        for _ in 0..<5 {
            line.split(separator: " ")[1].split(separator: ",").forEach {
                numbers.append(Int($0)!)
            }
        }

        let count = countArrangements(symbolGroups: symbolGroups, numbers: numbers)
        
        numberStore.append(count)
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 12b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
