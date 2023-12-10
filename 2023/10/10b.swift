import Foundation

let testInput: [String] = [
    "FF7FSF7F7F7F7F7F---7",
    "L|LJ||||||||||||F--J",
    "FL-7LJLJ||||||LJL-77",
    "F--JF--7||LJLJ7F7FJ-",
    "L---JF-JLJ.||-FJLJJ7",
    "|F|F-JF---7F7-L7L|7|",
    "|FFJF7L7F-JF7|JL---7",
    "7-L-JL7||F7|L7F-7F7|",
    "L.L7LFJ|||||FJL7||LJ",
    "L7JLJL-JLJLJL--JLJ.L"
]
let testSolution: Int = 10

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
    var passedTiles: [Tile] = [tileMap[currentLocation.y][currentLocation.x]]
    currentLocation = moveToPoint(sourcePoint: currentLocation, direction: direction)

    var moves: Int = 1

    while currentLocation != startingPos! {
        passedTiles.append(tileMap[currentLocation.y][currentLocation.x])

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

    var crossingLoop: Int = 0
    var insideLoop: Int = 0

    for y in tileMap.indices {
        for x in tileMap[y].indices {
            let point = Point(x: x, y: y)
            if let steps = passedTiles.firstIndex(where: ({ $0.position == point })) {
                if let stepsBelow = passedTiles.firstIndex(where: ({ $0.position == moveToPoint(sourcePoint: point, direction: .south) })) {
                    if stepsBelow == (steps + 1) % passedTiles.count {
                        crossingLoop += 1
                    }

                    if steps == (stepsBelow + 1) % passedTiles.count {
                        crossingLoop -= 1
                    }
                }
            } else {
                if crossingLoop != 0 {
                    insideLoop += 1
                }
            }
        }
    }

    return insideLoop
}

print("AoC Day 10b")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
