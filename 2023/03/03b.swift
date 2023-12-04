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
let testSolution: Int = 467835

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

struct Point: Hashable {
    var x: Int
    var y: Int
}

func solvePuzzle(input: [String]) -> Int {
    let newInput = input.map { Array($0) }

    func checkGearSymbols(input: [[Character]], row: Int, startColumn: Int, endColumn: Int, number: Int) {
        let startY: Int = max(row - 1, 0)
        let endY: Int = min(row + 1, input.count - 1)
        let startX: Int = max(startColumn - 1, 0)
        let endX: Int = min(endColumn + 1, input[row].count - 1)

        for y in startY...endY {
            for x in startX...endX {
                if input[y][x] == "*" {
                    let point: Point = Point(x: x, y: y)
                    gears[point] = gears[point] != nil ? gears[point]! + [number] : [number]
                }
            }
        }
    }

    var gears: [Point: [Int]] = [:]

    var result = 0

    for y in 0..<newInput.count {
        var x: Int = 0

        while x < newInput[0].count {
            if newInput[y][x].isNumber {
                var number: String = String(newInput[y][x])
                var lastDigitX = x

                while lastDigitX < newInput[y].count - 1 && newInput[y][lastDigitX + 1].isNumber {
                    lastDigitX += 1
                    number.append(newInput[y][lastDigitX])
                }

                checkGearSymbols(input: newInput, row: y, startColumn: x, endColumn: lastDigitX, number: Int(number)!)

                x = lastDigitX + 1
            } else {
                x += 1
            }
        }
    }
    
    for (_, numbers) in gears {
        if numbers.count == 2 {
            result += numbers[0] * numbers[1]
        }
    }
    return result
}

print("AoC Day 03b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
