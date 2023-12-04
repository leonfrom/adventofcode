import Foundation

let testInput: [String] = [
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664.598.."
]
let testSolution: Int = 4361

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []

    input.enumerated().forEach { lineIndex, line in
        let matches = line.matches(of: try! Regex("\\d+"))

        for match in matches {
            let number = match[0].substring!
            let firstIndex = match[0].range!.lowerBound.utf16Offset(in: line)
            let endIndex = firstIndex + number.count

            if (lineIndex != 0) {
                var start: String.Index
                var end: String.Index
                if (firstIndex != 0) {
                    start = input[lineIndex - 1].index(input[lineIndex - 1].startIndex, offsetBy: firstIndex - 1)
                } else {
                    start = input[lineIndex - 1].index(input[lineIndex - 1].startIndex, offsetBy: firstIndex)
                }
                if (endIndex != line.count) {
                    end = input[lineIndex - 1].index(input[lineIndex - 1].startIndex, offsetBy: endIndex + 1)
                } else {
                    end = input[lineIndex - 1].index(input[lineIndex - 1].startIndex, offsetBy: endIndex )
                }

                if (input[lineIndex - 1][start..<end].contains(try! Regex("[^.\\d]"))) {
                    numberStore.append(Int(number) ?? 0)
                    continue
                }
            }

            var start: String.Index
            var end: String.Index
            if (firstIndex != 0) {
                start = input[lineIndex].index(input[lineIndex].startIndex, offsetBy: firstIndex - 1)
            } else {
                start = input[lineIndex].index(input[lineIndex].startIndex, offsetBy: firstIndex)
            }
            if (endIndex != line.count) {
                end = input[lineIndex].index(input[lineIndex].startIndex, offsetBy: endIndex + 1)
            } else {
                end = input[lineIndex].index(input[lineIndex].startIndex, offsetBy: endIndex )
            }

            if (input[lineIndex][start..<end].contains(try! Regex("[^.\\d]"))) {
                numberStore.append(Int(number) ?? 0)
                continue
            }

            if (lineIndex < input.count - 1) {
                var start: String.Index
                var end: String.Index
                if (firstIndex != 0) {
                    start = input[lineIndex + 1].index(input[lineIndex + 1].startIndex, offsetBy: firstIndex - 1)
                } else {
                    start = input[lineIndex + 1].index(input[lineIndex + 1].startIndex, offsetBy: firstIndex)
                }
                if (endIndex != line.count) {
                    end = input[lineIndex + 1].index(input[lineIndex + 1].startIndex, offsetBy: endIndex + 1)
                } else {
                    end = input[lineIndex + 1].index(input[lineIndex + 1].startIndex, offsetBy: endIndex )
                }

                if (input[lineIndex + 1][start..<end].contains(try! Regex("[^.\\d]"))) {
                    numberStore.append(Int(number) ?? 0)
                    continue
                }
            }
        }
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 03a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
