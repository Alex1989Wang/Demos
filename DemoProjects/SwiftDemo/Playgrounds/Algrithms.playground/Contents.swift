//: Playground - noun: a place where people can play

import UIKit

/*
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
 */
 

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


//最长子串的长度
/*
class Solution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        let stringIndices = s.indices
        var ans: Int = 0
        var charSets: Set<Character> = Set()
        var subStart = stringIndices.startIndex, subEnd = stringIndices.startIndex
        while subStart < stringIndices.endIndex && subEnd < stringIndices.endIndex {
            print(s[subStart])
            if !charSets.contains(s[subEnd]) {
                charSets.insert(s[subEnd])
                subEnd = s.index(subEnd, offsetBy: 1)
                ans = max(ans, s.distance(from: subStart, to: subEnd))
            }
            else {
                charSets.remove(s[subStart])
                subStart = s.index(subStart, offsetBy: 1)
            }
        }
        
        return ans
    }
}

let test1 = "abcabcbb"
let test2 = "bbbbb"
let test3 = "pwwkew"
let solution = Solution()
print(solution.lengthOfLongestSubstring(test1))
print(solution.lengthOfLongestSubstring(test2))
print(solution.lengthOfLongestSubstring(test3))
 */

//Median of two sorted arrays
/*
class Solution {
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        if nums1.count <= 1 {
            var temp2 = nums2.count/2
            
        }
        
        let temp1 = nums1.count
        let temp2 = nums2.count
        var i1 = 0, j1 = nums1.count
        var i2 = 0, j2 = nums2.count
        
        while i1 != j1 {
            if nums1[i1] < nums2[i2] {
                i1 = (i1 + j1)/2
            }
        }
        
    }
}
 */

/*
//ZigZag Conversion
class Solution {
    func convert(_ s: String, _ numRows: Int) -> String {
        if numRows <= 1 {
            return s
        }
        
        if numRows == 2 {
            var segOne: String = ""
            var segTwo: String = ""
            for (index, char) in s.enumerated() {
                print("char \(char) at index \(index)")
                if index%2 == 0 {
                    segOne = segOne + String(char)
                }
                else {
                    segTwo = segTwo + String(char)
                }
            }
            return segOne + segTwo
        }
        
        //>=3
        var array: Array<String> = Array()
        for _ in 0..<numRows {
            array.append("")
        }
        for (index, char) in s.enumerated() {
            let group = 2 * numRows - 2
            let groupIndex = index % group
            let rowIndex = (groupIndex < numRows) ? groupIndex :
                (numRows - 1) - (groupIndex - (numRows - 1))
            var segment = array[rowIndex]
            segment = segment + String(char)
            array[rowIndex] = segment
        }
        
        var result = ""
        for seg in array {
            result = result + seg
        }
        return result
    }
}

let solution = Solution()
let testStr = "PAYPALISHIRING"
let row3 = 3
print(solution.convert(testStr, 3) == "PAHNAPLSIIGYIR")
let row4 = 4
print(solution.convert(testStr, 4) == "PINALSIGYAHRPI")
 */

/*
//reverse integer
print(Int32.max)
print((1 << 31) - 1)
print((Int32.max/10 - 1) * 10 + 9)
print(Int32.min)
class Solution {
    func reverse(_ x: Int) -> Int {
        var ret: Int = 0
        var temp = x
        while temp != 0 {
            let mod = temp%10
            temp = temp/10
            if ret > Int32.max/10 || (ret == Int32.max/10 && mod > 7) {
                ret = 0
                break
            }
            if ret < Int32.min/10 || (ret == Int32.min/10 && mod < -8) {
                ret = 0
                break
            }
            ret = ret * 10 + mod
        }
        return ret
    }
}
let solution = Solution()
let testNum = 1534236469
print(9646324351>Int(Int32.max))
print(solution.reverse(testNum))
 */


//Palindrome Number
class Solution {
    func isPalindrome(_ x: Int) -> Bool {
        //negative numbers
        if x < 0 {
            return false
        }
        
        var normalDigits = [Int]()
        var reverseDigits = [Int]()
        var temp = x
        while temp != 0 {
            let mod = temp%10
            temp = temp/10
            normalDigits.append(mod)
            reverseDigits.insert(mod, at: 0)
        }
        
        var ret = true
        for (index, digit) in normalDigits.enumerated() {
            if digit != reverseDigits[index] {
                ret = false
                break
            }
        }
        return ret
    }
}
let testNum = 1
let solution = Solution()
print(solution.isPalindrome(testNum))
print(solution.isPalindrome(121))
print(solution.isPalindrome(22))

