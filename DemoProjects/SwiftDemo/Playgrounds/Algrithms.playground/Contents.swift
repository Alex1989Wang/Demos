//: Playground - noun: a place where people can play

import UIKit

 //两数之和
class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        //at lease two elements
        if nums.count < 2 {
            return [Int]()
        }
        
        var resultIndexes = [Int]()
        
        outerFor : for (index, elOne) in nums.enumerated() {
            innerFor : for (latter, elTwo) in nums.enumerated() {
                if index == latter {
                    continue innerFor
                }
                
                if elOne + elTwo == target {
                    resultIndexes.append(index)
                    resultIndexes.append(latter)
                    break outerFor
                }
            }
        }
        return resultIndexes
    }
    
    func twoSumsV2(_ nums: [Int], _ target: Int) -> [Int] {
        
        var results = [Int]()
        var map: Dictionary<Int, Int> = Dictionary()
        
        
        for (index, elOne) in nums.enumerated() {
            let diff = target - elOne
            if map.keys.contains(diff) {
                results.append(index)
                results.append(map[diff]!)
                break
            }
            else {
                map.updateValue(index, forKey: elOne)
            }
        }
        
        return results
    }
}

let solution = Solution()
print(solution.twoSumsV2([1, 2, 3, 4], 5))
print(solution.twoSumsV2([], 0))
print(solution.twoSumsV2([1], 0))
print(solution.twoSumsV2([1, 2], 0))
print(solution.twoSumsV2([1, 2], 1))
print(solution.twoSumsV2([3, 2, 4], 6))
 

// Definition for singly-linked list.
/*
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    public var description: String {
        var tempNode: ListNode? = self
        var des = "\(tempNode?.val ?? 0)"
        while tempNode?.next != nil {
            des += "-> \(tempNode?.next?.val ?? 0)"
            tempNode = tempNode?.next
        }
        return des
    }
}

class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        
        var result: ListNode? = nil
        
        if l1 == nil && l2 == nil {
            return result
        }

        if l1 != nil && l2 == nil {
            return l1
        }
        
        if l1 == nil && l2 != nil {
            return l1
        }
        
        let val = l1!.val + l2!.val
        var counter = val / 10
        result = ListNode(val%10)
        var resultTemp = result
        
        var tempL1 = l1, tempL2 = l2
        while tempL1?.next != nil || tempL2?.next != nil || counter > 0 {
            let value = (tempL1?.next?.val ?? 0) + (tempL2?.next?.val ?? 0) + counter
            counter = value / 10
            resultTemp?.next = ListNode(value%10)
            tempL1 = tempL1?.next
            tempL2 = tempL2?.next
            resultTemp = resultTemp?.next
        }
        
        return result
    }
}


let l3 = ListNode(1)
var tempL1: ListNode? = l3
for num in 2...3 {
    tempL1?.next = ListNode(num)
    tempL1 = tempL1?.next
}
print(l3.description)

let l2 = ListNode(6)
var templ2: ListNode? = l2
for num in 7...9 {
    templ2?.next = ListNode(num)
    templ2 = templ2?.next
}
print(l2.description)

let solution = Solution()
print(String(describing: solution.addTwoNumbers(l3, l2)!.description))

 */
