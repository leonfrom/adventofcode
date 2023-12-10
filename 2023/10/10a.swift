import Foundation

let testInput: [String] = [
    "..F7.",
    ".FJ|.",
    "SJ.L7",
    "|F--J",
    "LJ..."
]
let testSolution: Int = 8

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

struct Point: Hashable {
    var x: Int
    var y: Int
}

enum Direction {
    case north
    case east
    case south
    case west
}

struct Tile: Hashable {
    var value: String
    var position: Point
}

func moveToPoint(sourcePoint: Point, direction: Direction) -> Point {
    switch direction {
    case .north: return Point(x: sourcePoint.x, y: sourcePoint.y - 1)
    case .east: return Point(x: sourcePoint.x + 1, y: sourcePoint.y)
    case .south: return Point(x: sourcePoint.x, y: sourcePoint.y + 1)
    case .west: return Point(x: sourcePoint.x - 1, y: sourcePoint.y)
    }
}

func solvePuzzle(input: [String]) -> Int {
    var tileMap: [[Tile]] = []
    var startingPos: Point? = nil

    for (lineIndex, line) in input.enumerated() {
        tileMap.append([])

        for (characterIndex, character) in Array(line).enumerated() {
            let tile: Tile = Tile(value: String(character), position: Point(x: characterIndex, y: lineIndex))
            tileMap[lineIndex].append(tile)

            if (tile.value == "S") {
                startingPos = tile.position
            }
        }
    }

    if (startingPos == nil) {
        fatalError("No starting position found")
    }

    var direction: Direction = .south

    if startingPos!.x > 0 && "-LF".contains(tileMap[startingPos!.y][startingPos!.x - 1].value) {
        direction = .west
    } else if startingPos!.x < tileMap[startingPos!.y].count - 1 && "-7J".contains(tileMap[startingPos!.y][startingPos!.x + 1].value) {
        direction = .east
    } else if startingPos!.y > 0 && "|F7".contains(tileMap[startingPos!.y - 1][startingPos!.x].value) {
        direction = .north
    }

    var currentLocation = startingPos!
    currentLocation = moveToPoint(sourcePoint: currentLocation, direction: direction)

    var moves: Int = 1

    while currentLocation != startingPos! {
        switch tileMap[currentLocation.y][currentLocation.x].value {
        case "F": direction = (direction == .north ? .east : .south)
        case "7": direction = (direction == .north ? .west : .south)
        case "L": direction = (direction == .south ? .east : .north)
        case "J": direction = (direction == .south ? .west : .north)
        case "|": break
        case "-": break
        default: fatalError("Bad direction")
        }

        currentLocation = moveToPoint(sourcePoint: currentLocation, direction: direction)
        moves += 1
    }

    return moves / 2
}

print("AoC Day 10a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
