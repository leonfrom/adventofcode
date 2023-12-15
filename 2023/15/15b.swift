import Foundation

let testInput: [String] = [
    "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7",
]
let testSolution: Int = 145

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []
    let initSequence: [[Character]] = input[0].split(separator: ",").map { return $0.map { return $0 } }
    var lensBoxes: [Int: [String]] = [:]
    
    for value in initSequence {
        var currentValue: Int = 0

        let label = value.split(whereSeparator: { $0 == "=" || $0 == "-"})[0]
        
        for char in label {
            currentValue += Int(char.asciiValue!)
            currentValue *= 17
            currentValue %= 256
        }

        if (value.contains("-")) {
            if let box = lensBoxes[currentValue] {
                if (box.contains(where: { $0.split(whereSeparator: { $0 == "=" || $0 == "-"})[0] == String(label) })) {
                    lensBoxes[currentValue]!.removeAll(where: { $0.split(whereSeparator: { $0 == "=" || $0 == "-"})[0] == String(label) })
                }
            }
        } else {
            if let box = lensBoxes[currentValue] {
                if let index = box.firstIndex(where: {$0.split(separator: "=")[0] == String(label)}) {
                    lensBoxes[currentValue]![index] = String(value)
                } else {
                    lensBoxes[currentValue]!.append(String(value))
                }
            } else {
                lensBoxes[currentValue] = [String(value)]
            }
        }
    }

    for (key, value) in lensBoxes {
        for (lensIndex, lens) in value.enumerated() {
            numberStore.append((key + 1) * (lensIndex + 1) * Int(lens.split(separator: "=")[1])!)
        }
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 15b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
