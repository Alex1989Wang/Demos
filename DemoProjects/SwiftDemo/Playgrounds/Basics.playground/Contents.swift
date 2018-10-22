//: Playground - noun: a place where people can play

import UIKit

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



