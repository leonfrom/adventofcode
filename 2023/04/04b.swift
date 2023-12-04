import Foundation

let testInput: [String] = [
    "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
    "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
    "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
    "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
    "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
    "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
]
let testSolution: Int = 30

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    var cards: [Int] = input.map { _ in return 1 }

    for (lineIndex, line) in input.enumerated() {
        let cardNumbers = line.split(separator: ": ")[1].split(separator: " | ")
        let winningNumbers = cardNumbers[0].split(separator: " ")
        let numbersYouHave = cardNumbers[1].split(separator: " ")

        let numbersThatWin = numbersYouHave.map { number in
            if (winningNumbers.contains(number)) {
                return number
            }
            return ""
        }.filter { !($0).isEmpty }

        for number in 0..<numbersThatWin.count {
            cards[number + lineIndex + 1] += cards[lineIndex]
        }
    }

    let output: Int = cards.reduce(0, +)
    return output
}

print("AoC Day 04b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
