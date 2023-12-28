import Foundation

let testInput: [String] = [
    "19, 13, 30 @ -2,  1, -2",
    "18, 19, 22 @ -1, -1, -2",
    "20, 25, 34 @ -2, -2, -4",
    "12, 31, 28 @ -1, -2, -1",
    "20, 19, 15 @  1, -5, -3"
]
let testSolution: Int = 2

struct Position: Hashable {
    var x: Double
    var y: Double
    var z: Double
}

struct Velocity: Hashable {
    var x: Double
    var y: Double
    var z: Double
}

struct Hailstone: Hashable {
    var id: UUID = UUID()
    var position: Position
    var velocity: Velocity
}

struct HailstoneSet: Hashable {
    var first: Hailstone
    var second: Hailstone
}

struct Area {
    var xStart: Double
    var xEnd: Double
    var yStart: Double
    var yEnd: Double
}

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

// Thx to https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-point-where-two-lines-intersect
func linesCross(start1: Position, end1: Position, start2: Position, end2: Position) -> (x: Double, y: Double)? {
    let delta1x = end1.x - start1.x
    let delta1y = end1.y - start1.y
    let delta2x = end2.x - start2.x
    let delta2y = end2.y - start2.y

    let determinant = delta1x * delta2y - delta2x * delta1y

    if abs(determinant) < 0.0001 {
        return nil
    }

    let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant

    if ab > 0 && ab < 1 {
        let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

        if cd > 0 && cd < 1 {
            let intersectX = start1.x + ab * delta1x
            let intersectY = start1.y + ab * delta1y
            return (intersectX, intersectY)
        }
    }

    return nil
}

func solvePuzzle(input: [String], area: Area) -> Int {
    var numberStore: [Int] = []
    var alreadyChecked: Set<HailstoneSet> = Set<HailstoneSet>()
    var hailstones: [Hailstone] = []

    for line in input {
        let p = line.split(separator: " @ ")[0].split(separator: ",").map { return Double($0.trimmingCharacters(in: .whitespaces))!}
        let v = line.split(separator: " @ ")[1].split(separator: ",").map { return Double($0.trimmingCharacters(in: .whitespaces))!}
        hailstones.append(Hailstone(position: Position(x: p[0], y: p[1], z: p[2]),
                                    velocity: Velocity(x: v[0], y: v[1], z: v[2])))
    }

    for hailstone in hailstones {
        for otherHailstone in hailstones {
            if (hailstone.id == otherHailstone.id) { continue }
            if (alreadyChecked.contains(HailstoneSet(first: hailstone, second: otherHailstone)) || alreadyChecked.contains(HailstoneSet(first: otherHailstone, second: hailstone))) {
                continue
            } else {
                alreadyChecked.insert(HailstoneSet(first: hailstone, second: otherHailstone))
            }

            let hailstoneEnd: Position = Position(x: hailstone.position.x + hailstone.velocity.x * area.xEnd,
                                                    y: hailstone.position.y + hailstone.velocity.y * area.yEnd,
                                                    z: 0.0)
            let otherHailstoneEnd: Position = Position(x: otherHailstone.position.x + otherHailstone.velocity.x * area.xEnd,
                                                        y: otherHailstone.position.y + otherHailstone.velocity.y * area.yEnd,
                                                        z: 0.0)

            if let crossedAt = linesCross(start1: hailstone.position,
                                            end1: hailstoneEnd,
                                            start2: otherHailstone.position,
                                            end2: otherHailstoneEnd) {
                if (crossedAt.x >= area.xStart && crossedAt.x <= area.xEnd && crossedAt.y >= area.yStart && crossedAt.y <= area.yEnd) {
                    numberStore.append(1)
                }
            }
        }
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 24a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput, area: Area(xStart: 7, xEnd: 27, yStart: 7, yEnd: 27))
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput, area: Area(xStart: 200000000000000, xEnd: 400000000000000, yStart: 200000000000000, yEnd: 400000000000000)))")
}
