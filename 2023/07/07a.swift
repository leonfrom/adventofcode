import Foundation

let testInput: [String] = [
    "32T3K 765",
    "T55J5 684",
    "KK677 28",
    "KTJJT 220",
    "QQQJA 483"
]
let testSolution: Int = 6440

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

let cardOrder: [Character] = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

struct Hand: Hashable {
    var cards: [Character]
    var bid: Int

    var worth: Int {
        var cardSums: [Character: Int] = [:]
        for card in self.cards {
            if (cardSums[card] != nil) {
                cardSums[card]! += 1
            } else {
                cardSums[card] = 1
            }
        }
        var tmpWorth = 1
        for cardSum in cardSums {
            if (cardSum.value == 5) {                                               // Five of a kind
                tmpWorth = max(tmpWorth, 7)
            } else if (cardSum.value == 4) {                                        // Four of a kind
                tmpWorth = max(tmpWorth, 6)
            } else if (cardSums.contains{ $0.value == 3 && cardSums.count == 2}) {  // Full house
                tmpWorth = max(tmpWorth, 5)
            } else if (cardSum.value == 3) {                                        // Three of a kind
                tmpWorth = max(tmpWorth, 4)
            } else if (cardSums.contains{ $0.value == 2 } && cardSums.count == 3) { // Two pair
                tmpWorth = max(tmpWorth, 3)
            } else if (cardSums.contains{ $0.value == 2 && $0.value != 3}) {        // One pair
                tmpWorth = max(tmpWorth, 2)
            }
        }
        return tmpWorth
    }
}

func solvePuzzle(input: [String]) -> Int {
    var hands = input.map { return Hand(cards: Array($0.split(separator: " ")[0]), bid: Int($0.split(separator: " ")[1])!) }
    hands.sort {
        if ($0.worth == $1.worth) {
            for (sortIndex, card) in $0.cards.enumerated() {
                let val1: Int = Int("\(cardOrder.firstIndex(of: card)!)")!
                let val2: Int = Int("\(cardOrder.firstIndex(of: $1.cards[sortIndex])!)")!
                if (val1 != val2) {
                    return val1 > val2
                }
            }
        }

        return $0.worth < $1.worth
    }

    var numberStore: [Int] = []

    for (handIndex, hand) in hands.enumerated() {
        numberStore.append(hand.bid * (handIndex + 1))
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 07a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
