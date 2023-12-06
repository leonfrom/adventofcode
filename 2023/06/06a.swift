import Foundation

let testInput: [String] = [
    "Time:      7  15   30",
    "Distance:  9  40  200"
]
let testSolution: Int = 288

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    let times = input[0].split(separator: ":")[1]
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .split(separator: " ")
                                .map { return $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    let distances = input[1].split(separator: ":")[1]
                                    .trimmingCharacters(in: .whitespacesAndNewlines)
                                    .split(separator: " ")
                                    .map { return $0.trimmingCharacters(in: .whitespacesAndNewlines) }

    var possibleTimes: [[Int]] = []
    var possibleDistances: [[Int]] = []

    for (index, bestTime) in times.enumerated() {
        possibleTimes.append([])
        possibleDistances.append([])
        for time in (0...Int(bestTime)!) {
            let distance = time * (Int(bestTime)! - time)
            if (distance > Int(distances[index])!) {
                possibleTimes[index].append(time)
                possibleDistances[index].append(time)
            }

            if (possibleDistances[index].count != 0 && distance < possibleDistances[index].last! && distance < Int(distances[index])!) {
                break
            }
        }
    }

    let output: Int = possibleTimes.map { return $0.count }.reduce(1, *)
    return output
}

print("AoC Day 06a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
