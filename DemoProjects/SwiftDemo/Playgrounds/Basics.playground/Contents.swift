//: Playground - noun: a place where people can play

import UIKit

/*
var str = "Hello, playground"

let constant = 10
var variable = "Variable"

print([constant, variable], separator: "0", terminator: "\n")

print(Int.min)
print(Int.max)

//let tooBig: UInt8 = UInt8.max + UInt8.max
//let tooBig: UInt8 = arc4random_uniform(UInt32.max)

//string interpolation
print("string interpoletion \(constant)")

let http200Status = (statusCode: 200, message: "OK")
print("Status code: \(http200Status.statusCode)")

let numberString1 = "123"
let numberString2 = "sig"

if let number1 = Int(numberString1), let number2 = Int(numberString2), number1 >= number2 {
    print("optional binding syntax: if");
}
else {
    print("optional binding syntax: else");
}

//nil-colescesing operator
let optionalValue: Int? = nil
let result = optionalValue ?? 2
print(result)

//strings
for char in "Hello, world" {
    print(char)
}

//"hello"["hello".index(before: "hello".endIndex)]
//"hello"["hello".endIndex]

//closure
let array = ["B", "C", "D", "A"]
let sorted = array.sorted { (str1: String, str2: String) -> Bool in
    str1 > str2
}
print(array)
print(sorted)
let sortedTwo = array.sorted(by: {(str1: String, str2: String) -> Bool in
    return str1 < str2
})
print(sortedTwo)

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let mappedNumbers = numbers.map({(number: Int) -> String in
    var output = ""
    var tempNum = number
    repeat {
        output = (digitNames[tempNum%10] ?? "") + output
        tempNum = tempNum/10
    } while tempNum > 0
   return output
})
print(mappedNumbers)

//enums
enum Direction {
    case north
    case south
    case east
    case west
}
var direction = Direction.north
direction = .east
let north: Direction = .north
switch direction {
case .east:
    print("swift enums do not fall through")
default:
    print("otehr dirctions")
}

struct Resolution {
    var width: Float = 0
    var height: Float = 0
}
class VideoMode {
    var resolution = Resolution()
    var name: String?
    var frameRate: Float = 0.0
}

//memberwise initialization
let p720 = Resolution(width: 480, height: 640)
print(p720)
 */

//subscripts
/*
struct TimeTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        get {
            return multiplier * index
        }
    }
}
let timeTable4 = TimeTable.init(multiplier: 2)
print(timeTable4[1])

struct Matrix {
    //MARK: init
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array.init(repeating: 0.0, count: rows * columns)
    }
    
    func isIndexValid(row: Int, column: Int) -> Bool {
        return ((row >= 0 && row < rows) && (column >= 0 && column < columns))
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(isIndexValid(row: row, column: column), "row or column index out of range")
            return grid[row * column + column]
        }
        
        set (value) {
            assert(isIndexValid(row: row, column: column), "row or column index out of range")
            grid[row * column + column] = value
        }
    }
}
var matrix45 = Matrix.init(rows: 4, columns: 5)
print(matrix45.rows)
//print(matrix45[5, 6])
matrix45[3, 4] = 10
print(matrix45[3, 4])
 */


/*
//initializers
class MyClass {
    var myProperty: Int = 0
//    init(with property: Int) {
//        myProperty = property
//    }
}

//let myClass = MyClass.init(with: 2)
//print(myClass.myProperty)
let myClass = MyClass()
print(myClass.myProperty)

struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}

//parameter names and argument label
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(_ white: Double) {
        red   = white
        green = white
        blue  = white
    }
    
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
    
    init(withWhite white: Double) {
        red   = white
        green = white
        blue  = white
    }
}

let color = Color.init(withWhite: 2)

//default initializer
class Initilizer {
    var dummyProperty = 0
    init(dummy: Int) {
        dummyProperty = dummy
    }
    
    init() {
        
    }
}

class SubInitilizer: Initilizer {
    var anotherDummy: Int = 1
}

let sub = SubInitilizer()
print(sub.anotherDummy)
 */

//funnel point
class RootClass {
    var dummyRoot = 0
    
    //designated initializer
    init(dummy: Int) {
        dummyRoot = dummy
    }
    
    convenience init() {
        self.init(dummy: 0)
    }
}

class SubClass: RootClass {
    //designated initilizer
    var anotherDummy = 0
    init(anotherDummy: Int, dummy: Int) {
        super.init(dummy: dummy)
        self.anotherDummy = anotherDummy
    }
    
    convenience init() {
        self.init(anotherDummy: 0, dummy: 0)
    }
}

