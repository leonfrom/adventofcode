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
let testSolution: Int = 8410

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

func solvePuzzle(input: [String], expension: Int) -> Int {
    var galaxys: [Galaxy] = []
    var numberStore: [Int] = []

    var y: Int = 0
    while y < input.count {
        var x: Int = 0
        while x < Array(input[y]).count {
            if (Array(input[y])[x] == "#") {
                galaxys.append(Galaxy(id: galaxys.count + 1, position: Point(x: x, y: y)))
            }

            x += 1
        }

        y += 1
    }
    
    // Expend vertical space
    let minY = galaxys.min { $0.position.y < $1.position.y }!.position.y
    let maxY = galaxys.max { $0.position.y < $1.position.y }!.position.y

    var tmpExpandedGalaxys: [Galaxy] = []
    var distance = 0

    for y in minY...maxY {
        let galaxysInRow = galaxys.filter { $0.position.y == y }
        if (!galaxysInRow.isEmpty) {
            for galaxy in galaxysInRow {
                tmpExpandedGalaxys.append(Galaxy(id: galaxy.id, position: Point(x: galaxy.position.x, y: galaxy.position.y + distance)))
            }
        } else {
            distance += expension - 1
        }
    }

    // Expend horizontal space
    let minX = galaxys.min { $0.position.x < $1.position.x }!.position.x
    let maxX = galaxys.max { $0.position.x < $1.position.x }!.position.x

    var expandedGalaxys: [Galaxy] = []
    distance = 0
    
    for x in minX...maxX {
        let galaxysInCol = tmpExpandedGalaxys.filter { $0.position.x == x }
        if (!galaxysInCol.isEmpty) {
            for galaxy in galaxysInCol {
                expandedGalaxys.append(Galaxy(id: galaxy.id, position: Point(x: galaxy.position.x + distance, y: galaxy.position.y)))
            }
        } else {
            distance += expension - 1
        }
    }

    for galaxy in expandedGalaxys {
        for otherGalaxy in expandedGalaxys {
            if (otherGalaxy.id != galaxy.id) {
                numberStore.append(abs(galaxy.position.x - otherGalaxy.position.x) + abs(galaxy.position.y - otherGalaxy.position.y))
            }
        }
    }

    let output: Int = numberStore.reduce(0, +)
    return output / 2
}

print("AoC Day 11b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput, expension: 100)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput, expension: 1000000))")
}
