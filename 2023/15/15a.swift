import Foundation

let testInput: [String] = [
    "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7",
]
let testSolution: Int = 1320

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []
    let initSequence: [[Character]] = input[0].split(separator: ",").map { return $0.map { return $0 } }
    
    for value in initSequence {
        var currentValue: Int = 0
        
        for char in value {
            currentValue += Int(char.asciiValue!)
            currentValue *= 17
            currentValue %= 256
        }

        numberStore.append(currentValue)
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 15a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
