import Foundation

enum Pulse {
    case high
    case low
}

enum ModuleType {
    case broadcaster
    case flipflop
    case conjunction
}

struct Module {
    var type: ModuleType
    var name: String
    var output: [String]
    var state: Bool = false
}

struct QueueElement {
    var source: String
    var pulse: Pulse
    var destination: String
}

let textFile: String = try String(contentsOfFile: "./puzzleInput.txt")
let puzzleInput: [String] = textFile.components(separatedBy: "\n")

func solvePuzzle(input: [String]) -> Int {
    var modules: [String: Module] = [:]
    var conjunctionStore: [String: [String: Pulse]] = [:]
    var queue: [QueueElement] = []
    var queueHistory: [QueueElement] = []

    for line in input {
        let name = line.split(separator: " -> ")[0]
        
        if (name == "broadcaster") {
            modules[String(name)] = Module(type: .broadcaster, name: String(name), output: line.split(separator: " -> ")[1].split(separator: ", ").map { return String($0) })
        } else {
            switch name.first {
            case "%":
                modules[String(name.dropFirst())] = Module(type: .flipflop, name: String(name.dropFirst()), output: line.split(separator: " -> ")[1].split(separator: ", ").map { return String($0) })
            case "&":
                modules[String(name.dropFirst())] = Module(type: .conjunction, name: String(name.dropFirst()), output: line.split(separator: " -> ")[1].split(separator: ", ").map { return String($0) })
            default:
                fatalError("Wrong type found")
            }
        }

        modules.filter { $0.value.type == .conjunction }.forEach { module in
        conjunctionStore[module.key] = [:]
            modules.filter { $0.value.output.contains(module.key)}.forEach {
                conjunctionStore[module.key]![$0.key] = .low
            }
        }
    }

    var buttonPressed = 0
    while true {
        buttonPressed += 1
        queue.append(QueueElement(source: "buttonPress", pulse: .low, destination: "broadcaster"))
        queueHistory.append(QueueElement(source: "buttonPress", pulse: .low, destination: "broadcaster"))

        while queue.count > 0 {
            let element = queue.removeFirst()
            if (!modules.contains(where: { $0.key == element.destination })) { continue }
            
            switch modules[element.destination]!.type {
            case .broadcaster:
                modules[element.destination]!.output.forEach { name in
                    queue.append(QueueElement(source: element.destination, pulse: element.pulse, destination: name))
                    queueHistory.append(QueueElement(source: element.destination, pulse: element.pulse, destination: name))
                }
            case .flipflop:
                if (element.pulse == .low) {
                    switch modules[element.destination]!.state {
                    case true:
                        modules[element.destination]!.state = false
                        modules[element.destination]!.output.forEach { name in
                            queue.append(QueueElement(source: element.destination, pulse: .low, destination: name))
                            queueHistory.append(QueueElement(source: element.destination, pulse: .low, destination: name))
                        }
                    case false:
                        modules[element.destination]!.state = true
                        modules[element.destination]!.output.forEach { name in
                            queue.append(QueueElement(source: element.destination, pulse: .high, destination: name))
                            queueHistory.append(QueueElement(source: element.destination, pulse: .high, destination: name))
                        }
                    }
                }
            case .conjunction:
                conjunctionStore[element.destination]![element.source] = element.pulse
                if (conjunctionStore[element.destination]!.filter { $0.value == .low}.count == 0) {
                    modules[element.destination]!.output.forEach { name in
                        queue.append(QueueElement(source: element.destination, pulse: .low, destination: name))
                        queueHistory.append(QueueElement(source: element.destination, pulse: .low, destination: name))
                    }
                } else {
                    modules[element.destination]!.output.forEach { name in
                        queue.append(QueueElement(source: element.destination, pulse: .high, destination: name))
                        queueHistory.append(QueueElement(source: element.destination, pulse: .high, destination: name))
                    }
                }
            }
        }

        if (queueHistory.contains(where: {$0.pulse == .low && $0.destination == "rx"})) {
            break
        }
    }

    return buttonPressed
}

print("AoC Day 20b")
print("Solution: \(solvePuzzle(input: puzzleInput))")
