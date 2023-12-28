import Foundation

let testInput: [String] = [
    "px{a<2006:qkq,m>2090:A,rfg}",
    "pv{a>1716:R,A}",
    "lnx{m>1548:A,A}",
    "rfg{s<537:gd,x>2440:R,A}",
    "qs{s>3448:A,lnx}",
    "qkq{x<1416:A,crn}",
    "crn{x>2662:A,R}",
    "in{s<1351:px,qqz}",
    "qqz{s>2770:qs,m<1801:hdj,R}",
    "gd{a>3333:R,R}",
    "hdj{m>838:A,pv}",
    "",
    "{x=787,m=2655,a=1222,s=2876}",
    "{x=1679,m=44,a=2067,s=496}",
    "{x=2036,m=264,a=79,s=2244}",
    "{x=2461,m=1339,a=466,s=291}",
    "{x=2127,m=1623,a=2188,s=1013}"
]
let testSolution: Int = 19114

struct Rule: Hashable {
    var param: String = ""
    var op: String = ""
    var val: Int = 0
    var dest: String
}

struct Workflow: Hashable {
    var name: String
    var rules: [Rule]
}

struct Item: Hashable {
    var x: Int
    var m: Int
    var a: Int
    var s: Int
}

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    var numberStore: [Int] = []
    var workflows: [String: Workflow] = [:]
    var items: [Item] = []

    for line in input.joined(separator: "\n").split(separator: "\n\n")[0].split(separator: "\n") {
        let name = String(line.split(separator: "{")[0])
        let ruleLine = line.split(separator: "{")[1].dropLast()
        let rules = ruleLine.split(separator: ",").map {
            if ($0.contains(where: {$0 == "<" || $0 == ">"})) {
                let value: Int = Int(String($0.split(whereSeparator: { $0 == "<" || $0 == ">" || $0 == ":"})[1]))!
                return Rule(param: String($0.first!), op: String($0.dropFirst().first!), val: value, dest: String($0.dropFirst(2).split(separator: ":")[1]))
            } else {
                return Rule(dest: String($0))
            }
        }
        workflows[name] = Workflow(name: name, rules: rules)
    }

    for line in input.joined(separator: "\n").split(separator: "\n\n")[1].split(separator: "\n") {
        let itemLine = line.dropFirst().dropLast().split(separator: ",")
        items.append(Item(x: Int(itemLine[0].dropFirst(2))!, m: Int(itemLine[1].dropFirst(2))!, a: Int(itemLine[2].dropFirst(2))!, s: Int(itemLine[3].dropFirst(2))!))
    }

    for item in items {
        var currentNode: String = "in"
        while true {
            if (currentNode == "A" || currentNode == "R") { break }

            let currentWorkflow = workflows[currentNode]!

            ruleLoop: for rule in currentWorkflow.rules {
                if (rule.op == "<" || rule.op == ">") {
                    switch rule.op {
                    case "<":
                        switch rule.param {
                        case "x":
                            if (item.x < rule.val) { currentNode = rule.dest; break ruleLoop }
                        case "m":
                            if (item.m < rule.val) { currentNode = rule.dest; break ruleLoop }
                        case "a":
                            if (item.a < rule.val) { currentNode = rule.dest; break ruleLoop }
                        case "s":
                            if (item.s < rule.val) { currentNode = rule.dest; break ruleLoop }
                        default:
                            fatalError("Wrong parameter")
                        }
                    case ">":
                        switch rule.param {
                        case "x":
                            if (item.x > rule.val) { currentNode = rule.dest; break ruleLoop }
                        case "m":
                            if (item.m > rule.val) { currentNode = rule.dest; break ruleLoop }
                        case "a":
                            if (item.a > rule.val) { currentNode = rule.dest; break ruleLoop }
                        case "s":
                            if (item.s > rule.val) { currentNode = rule.dest; break ruleLoop }
                        default:
                            fatalError("Wrong parameter")
                        }
                    default:
                        fatalError("Wrong operator")
                    }
                } else {
                    currentNode = rule.dest
                }
            }
        }

        if (currentNode == "A") {
            numberStore.append(item.x)
            numberStore.append(item.m)
            numberStore.append(item.a)
            numberStore.append(item.s)
            continue
        }
    }

    let output: Int = numberStore.reduce(0, +)
    return output
}

print("AoC Day 19a")
let testPassing: Bool = testSolution == solvePuzzle(input: testInput)
print("Test passing? \(testPassing)")
if (testPassing) {
    print("Solution: \(solvePuzzle(input: puzzleInput))")
}
