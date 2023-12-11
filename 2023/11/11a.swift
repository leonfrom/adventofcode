import Foundation

let testInput: [String] = [
    "...#......",
    ".......#..",
    "#.........",
    "..........",
    "......#...",
    ".#........",
    ".........#",
    "..........",
    ".......#..",
    "#...#....."
]
let testSolution: Int = 374

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

struct Point: Hashable {
    var x: Int
    var y: Int
}

struct Galaxy: Hashable, Identifiable {
    var id: Int
    var position: Point
}

func solvePuzzle(input: [String]) -> Int {
    var tmpInput: [String] = input
    var galaxys: [Galaxy] = []
    var numberStore: [Int] = []
    
    // Find and append vertical empty space
    var x: Int = 0
    while x < Array(tmpInput[0]).count {
        let emptyGalaxyCheck: [String] = tmpInput.map { return String(Array($0)[x]) }
        if (!emptyGalaxyCheck.contains("#")) {
            for row in tmpInput.indices {
                tmpInput[row].insert(".", at: tmpInput[0].index(tmpInput[0].startIndex, offsetBy: x))
            }
            x += 1
        }
        x += 1
    }

    var y: Int = 0
    while y < tmpInput.count {
        var x: Int = 0
        while x < Array(tmpInput[y]).count {
            if (Array(tmpInput[y])[x] == "#") {
                galaxys.append(Galaxy(id: galaxys.count + 1, position: Point(x: x, y: y)))
            }

            x += 1
        }

        // Find and append horizontal empty space
        if (!Array(tmpInput[y]).contains("#")) {
            tmpInput.insert(String(repeating: ".", count: Array(tmpInput[y]).count), at: y)
            y += 1
        }

        y += 1
    }

    for galaxy in galaxys {
        for otherGalaxy in galaxys {
            if (otherGalaxy.id != galaxy.id) {
                numberStore.append(abs(galaxy.position.x - otherGalaxy.position.x) + abs(galaxy.position.y - otherGalaxy.position.y))
            }
        }
    }

    let output: Int = numberStore.reduce(0, +)
    return output / 2
}

print("AoC Day 11a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
