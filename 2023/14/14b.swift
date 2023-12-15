import Foundation

let testInput: [String] = [
    "O....#....",
    "O.OO#....#",
    ".....##...",
    "OO.#O....O",
    ".O.....O#.",
    "O.#..O.#.#",
    "..O..#O..O",
    ".......O..",
    "#....###..",
    "#OO..#...."
]
let testSolution: Int = 64

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

enum Element {
    case roundRock
    case cubeRock
    case empty
}

enum Direction {
    case north
    case east
    case south
    case west
}

struct Point {
    var x: Int
    var y: Int
}

func getNextPointForDirection(point: Point, direction: Direction) -> Point {
    switch direction {
    case .north: return Point(x: point.x, y: point.y - 1)
    case .east: return Point(x: point.x + 1, y: point.y)
    case .south: return Point(x: point.x, y: point.y + 1)
    case .west: return Point(x: point.x - 1, y: point.y)
    }
}

func getElementFromCoord(point: Point, map: [[Element]]) -> Element {
    return map[point.y][point.x]
}

func tiltMap(map: [[Element]], direction: Direction) -> [[Element]] {
    var tiltingMap = map

    var canMove = true
    while canMove {
        canMove = false
        for y in 0..<tiltingMap.count {
            for x in 0..<tiltingMap[y].count {
                if (tiltingMap[y][x] == .roundRock) {
                    let rollingTo = getNextPointForDirection(point: Point(x: x, y: y), direction: direction)
                    if ((0..<tiltingMap.count).contains(rollingTo.y) && (0..<tiltingMap[y].count).contains(rollingTo.x)) {
                        if (getElementFromCoord(point: rollingTo, map: tiltingMap) == .empty) {
                            canMove = true
                            tiltingMap[rollingTo.y][rollingTo.x] = .roundRock
                            tiltingMap[y][x] = .empty
                        }
                    }
                }
            }
        }
    }

    return tiltingMap
}

func getMapString(map: [[Element]]) -> String {
    var string: String = ""
    for y in 0..<map.count {
        var line = ""
        for x in 0..<map[y].count {
            switch map[y][x] {
            case .roundRock: line += "1"
            case .cubeRock: line += "2"
            case .empty: line += "0"
            }
        }
        string += line
    }
    return string
}

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []
    var map: [[Element]] = []
    let cycles: Int = 1000000000

    var cycleResults: Set<String> = Set<String>()
    var cycleResultIndices: [String: Int] = [:]

    for line in input {
        map.append(line.map {
            if ($0 == "O") {
                return .roundRock
            } else if ($0 == "#") {
                return .cubeRock
            } else {
                return .empty
            }
        })
    }

    var currentCycle: Int = 0

    var cycleStartIndex: Int = 0
    var cycleLength: Int = 0

    while currentCycle < cycles {
        let mapString = getMapString(map: map)
        if (cycleResults.contains(mapString)) {
            let repeatingIndex = cycleResultIndices[mapString]!
            cycleStartIndex = repeatingIndex
            cycleLength = currentCycle - repeatingIndex
            break
        }
        cycleResults.insert(mapString)
        cycleResultIndices[mapString] = currentCycle

        map = tiltMap(map: map, direction: .north)
        map = tiltMap(map: map, direction: .west)
        map = tiltMap(map: map, direction: .south)
        map = tiltMap(map: map, direction: .east)
        
        currentCycle += 1
    }

    let finalCycles = cycleStartIndex + (cycles - cycleStartIndex) % cycleLength;
    while cycleStartIndex < finalCycles {
        map = tiltMap(map: map, direction: .north)
        map = tiltMap(map: map, direction: .west)
        map = tiltMap(map: map, direction: .south)
        map = tiltMap(map: map, direction: .east)
        
        cycleStartIndex += 1
    }

    for y in 0..<map.count {
        for x in 0..<map[y].count {
            if (map[y][x] == .roundRock) {
                numberStore.append(map.count - y)
            }
        }
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 14b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
