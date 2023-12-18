import Foundation

let testInput: [String] = [
    "R 6 (#70c710)",
    "D 5 (#0dc571)",
    "L 2 (#5713f0)",
    "D 2 (#d2c081)",
    "R 2 (#59c680)",
    "D 2 (#411b91)",
    "L 5 (#8ceee2)",
    "U 2 (#caa173)",
    "L 1 (#1b58a2)",
    "U 2 (#caa171)",
    "R 2 (#7807d2)",
    "U 3 (#a77fa3)",
    "L 2 (#015232)",
    "U 2 (#7a21e3)"
]
let testSolution: Int = 62

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

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

struct PlanPart {
    var direction: Direction
    var lenght: Int
    var color: String
}

func getNextPoint(current: Point, part: PlanPart) -> Point {
    switch part.direction {
    case .north: return Point(x: current.x, y: current.y - part.lenght)
    case .east: return Point(x: current.x + part.lenght, y: current.y)
    case .south: return Point(x: current.x, y: current.y + part.lenght)
    case .west: return Point(x: current.x - part.lenght, y: current.y)
    }
}

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []
    var plan: [PlanPart] = []
    var path: [Point] = [Point(x: 0, y: 0)]

    for line in input {
        let inputPart = line.split(separator: " ")
        
        var direction: Direction = .north
        switch inputPart[0] {
        case "U": direction = .north
        case "R": direction = .east
        case "D": direction = .south
        case "L": direction = .west
        default: fatalError("Invalid direction")
        }

        plan.append(PlanPart(direction: direction, lenght: Int(inputPart[1])!, color: String(inputPart[2])))
    }

    for part in plan {
        let lastPosition = path.last!
        let nextPoint = getNextPoint(current: lastPosition, part: part)
        path.append(Point(x: nextPoint.x, y: nextPoint.y))
    }

    let minY = path.max(by: {$0.y > $1.y})!.y
    let minX = path.max(by: {$0.x > $1.x})!.x
    let maxY = path.max(by: {$0.y < $1.y})!.y
    let maxX = path.max(by: {$0.x < $1.x})!.x

    print("Y: \(minY)...\(maxY)")
    print("X: \(minX)...\(maxX)")

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 18a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
