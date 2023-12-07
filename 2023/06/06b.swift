import Foundation

let testInput: [String] = [
    "Time:      7  15   30",
    "Distance:  9  40  200"
]
let testSolution: Int = 71503

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    let bestTime = input[0].split(separator: ":")[1]
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .split(separator: " ")
                                .map { return $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                .joined(separator: "")
    let bestDistance = input[1].split(separator: ":")[1]
                                    .trimmingCharacters(in: .whitespacesAndNewlines)
                                    .split(separator: " ")
                                    .map { return $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                                    .joined(separator: "")

    var possibleTimes: [Int] = []
    var possibleDistances: [Int] = []

    for time in (0...Int(bestTime)!) {
        let distance = time * (Int(bestTime)! - time)

        if (distance > Int(bestDistance)!) {
            possibleTimes.append(time)
            possibleDistances.append(distance)
        }

        if (possibleDistances.count != 0 && distance < possibleDistances.last! && distance < Int(bestDistance)!) {
            break
        }
    }

    let output: Int = possibleTimes.count
    return output
}

print("AoC Day 06b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
