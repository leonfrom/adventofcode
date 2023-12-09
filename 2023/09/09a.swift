import Foundation

let testInput: [String] = [
    "0 3 6 9 12 15",
    "1 3 6 10 15 21",
    "10 13 16 21 30 45"
]
let testSolution: Int = 114

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []

    let nodeList: [[Int]] = input.map { $0.split(separator: " ").map { Int($0)! } }
    
    for list in nodeList {
        var lines: [[Int]] = [list]

        while lines.last!.filter({ $0 != 0 }).count != 0 {
            var tmpLine: [Int] = []
            
            for (numberIndex, number) in lines.last!.enumerated() {
                if (numberIndex < lines.last!.count - 1) {
                    tmpLine.append(lines.last![numberIndex + 1] - number)
                }
            }

            lines.append(tmpLine)
        }

        lines[lines.count - 1].append(0)

        for lineIndex in lines.indices {
            if (lineIndex < lines.count - 1) {
                lines[lines.count - 2 - lineIndex].append(lines[lines.count - 1 - lineIndex].last! + lines[lines.count - 2 - lineIndex].last!)
            }
        }
        
        numberStore.append(lines[0].last!)
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 09a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
