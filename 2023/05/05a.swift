import Foundation

let testInput: [String] = [
    "seeds: 79 14 55 13",
    "",
    "seed-to-soil map:",
    "50 98 2",
    "52 50 48",
    "",
    "soil-to-fertilizer map:",
    "0 15 37",
    "37 52 2",
    "39 0 15",
    "",
    "fertilizer-to-water map:",
    "49 53 8",
    "0 11 42",
    "42 0 7",
    "57 7 4",
    "",
    "water-to-light map:",
    "88 18 7",
    "18 25 70",
    "",
    "light-to-temperature map:",
    "45 77 23",
    "81 45 19",
    "68 64 13",
    "",
    "temperature-to-humidity map:",
    "0 69 1",
    "1 0 69",
    "",
    "humidity-to-location map:",
    "60 56 37",
    "56 93 4"
]
let testSolution: Int = 35

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

struct SeedMap: Hashable {
    var destinationStart: Int
    var sourceStart: Int
    var rangeLength: Int
}

func solvePuzzle(input: [String]) -> Int {
    var lowestLocation: Int = Int.max
    let seeds = input[0].split(separator: ": ")[1].split(separator: " ").map { return Int($0)! }
    let maps = input.joined(separator: "\n").split(separator: "\n\n")

    func lineToSeedMap(line: Substring.SubSequence) -> [SeedMap] {
        return line.split(separator: "\n").map { return SeedMap(destinationStart: Int($0.split(separator: " ")[0])!, sourceStart: Int($0.split(separator: " ")[1])!, rangeLength: Int($0.split(separator: " ")[2])!) }
    }

    let sts = lineToSeedMap(line: maps[1].split(separator: ":\n")[1])
    let stf = lineToSeedMap(line: maps[2].split(separator: ":\n")[1])
    let ftw = lineToSeedMap(line: maps[3].split(separator: ":\n")[1])
    let wtl = lineToSeedMap(line: maps[4].split(separator: ":\n")[1])
    let ltt = lineToSeedMap(line: maps[5].split(separator: ":\n")[1])
    let tth = lineToSeedMap(line: maps[6].split(separator: ":\n")[1])
    let htl = lineToSeedMap(line: maps[7].split(separator: ":\n")[1])

    for seed in seeds {
        var stsD: Int = seed
        for map in sts {
            if ((map.sourceStart..<map.sourceStart + map.rangeLength).contains(seed)) {
                stsD = seed - map.sourceStart + map.destinationStart
            }
        }

        var stfD: Int = stsD
        for map in stf {
            if ((map.sourceStart..<map.sourceStart + map.rangeLength).contains(stsD)) {
                stfD = stsD - map.sourceStart + map.destinationStart
            }
        }

        var ftwD: Int = stfD
        for map in ftw {
            if ((map.sourceStart..<map.sourceStart + map.rangeLength).contains(stfD)) {
                ftwD = stfD - map.sourceStart + map.destinationStart
            }
        }

        var wtlD: Int = ftwD
        for map in wtl {
            if ((map.sourceStart..<map.sourceStart + map.rangeLength).contains(ftwD)) {
                wtlD = ftwD - map.sourceStart + map.destinationStart
            }
        }

        var lttD: Int = wtlD
        for map in ltt {
            if ((map.sourceStart..<map.sourceStart + map.rangeLength).contains(wtlD)) {
                lttD = wtlD - map.sourceStart + map.destinationStart
            }
        }

        var tthD: Int = lttD
        for map in tth {
            if ((map.sourceStart..<map.sourceStart + map.rangeLength).contains(lttD)) {
                tthD = lttD - map.sourceStart + map.destinationStart
            }
        }

        var htlD: Int = tthD
        for map in htl {
            if ((map.sourceStart..<map.sourceStart + map.rangeLength).contains(tthD)) {
                htlD = tthD - map.sourceStart + map.destinationStart
            }
        }

        if (htlD <= lowestLocation) {
            lowestLocation = htlD
        }
    }

    return lowestLocation
}

print("AoC Day 05a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
