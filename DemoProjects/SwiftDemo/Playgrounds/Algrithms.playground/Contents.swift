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


/*
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
*/

/*
//Roman to Integer
class Solution {
    func romanToInt(_ s: String) -> Int {
        let uppercase = s.uppercased()
        let dict: Dictionary<String, Int> = [
            "I": 1,
            "V": 5,
            "X": 10,
            "L": 50,
            "C": 100,
            "D": 500,
            "M": 1000,
            "IV": 4,
            "IX": 9,
            "XL": 40,
            "XC": 90,
            "CD": 400,
            "CM": 900,
            ]
        let specialChars: Array<Character> = ["I", "X", "C"]
        
        var index = uppercase.startIndex
        var ret = 0
        while index != uppercase.endIndex {
            let char = uppercase[index]
            let latterIndex = uppercase.index(index, offsetBy: 1)
            var specialValue = 0
            if specialChars.contains(char) && (latterIndex < uppercase.endIndex)  {
                let range = index...latterIndex
                let subStr = uppercase[range]
                if let value = dict[String(subStr)] {
                    specialValue = value
                }
            }
            
            ret = ret + specialValue //如果有特殊值
            if specialValue == 0 {
                //没有特殊值
                if let value = dict[String(uppercase[index])] {
                    ret = ret + value
                }
            }

            index = (specialValue != 0) ? uppercase.index(index, offsetBy: 2) : uppercase.index(index, offsetBy: 1)
        }
        
        return ret
    }
}

let solution = Solution()
print(solution.romanToInt("XII"))
print(solution.romanToInt("IX"))
 */


/*
//longest common prefix
class Solution {
    func longestCommonPrefix(_ strs: [String]) -> String {
        //是否为空数组
        if strs.count == 0 || strs.contains("") {
            return ""
        }
        
        var prefixStack: Array<Character> = Array(strs.first!)

        outerLoop: for str in strs {
            //str的最长长度-cap一下
            if prefixStack.count > str.count {
                prefixStack.removeSubrange(str.count..<prefixStack.count)
            }
            
            innerLoop: for (index, char) in str.enumerated() {
                if index < prefixStack.count {
                    let value = prefixStack[index]
                    if value != char {
                        prefixStack.removeSubrange(index..<prefixStack.count)
                        
                        //决定是退出那一层循环
                        if prefixStack.count <= 0 {
                            break outerLoop
                        }
                        break innerLoop
                    }
                }
            }
        }
        return String(prefixStack)
    }
}

let solution = Solution()
//print(solution.longestCommonPrefix(["flower", "floor", "fl"]))
//print(solution.longestCommonPrefix(["aaa", "aa", "aaa"]))
print(solution.longestCommonPrefix(["a", "ac"]))
 */

/*
//Valid parenthesis
class Solution {
    func isValid(_ s: String) -> Bool {
        if s.isEmpty {
            return true
        }

        let leftRightMap: Dictionary<Character, Character> = ["(":")", "{": "}", "[": "]"]
        let keys = Array(leftRightMap.keys)
        let values = Array(leftRightMap.values)

        var stack: Array<Character> = [Character]()
        var ret = false

        for (index, char) in s.enumerated() {
            
            if !keys.contains(char) &&
                !values.contains(char) {
                ret = false
                break
            }
            
            if index == 0 && values.contains(char) {
                ret = false
                break;
            }
            
            //left contains char?
            if keys.contains(char) {
                stack.append(char)
            }
            else {
                if stack.isEmpty {
                    ret = false
                    break
                }
                
                let left = stack.removeLast()
                let right = leftRightMap[left]

                if right == nil {
                    ret = false
                    break
                }
                
                let rightValue = right!
                if rightValue != char {
                    ret = false
                    break
                }
            }
            
            //全部检查过了
            if index == (s.count - 1) && stack.isEmpty {
                ret = true
            }
        }
        
        return ret
    }
}

let solution = Solution()
print(solution.isValid("()"))
print(solution.isValid("()[]{}"))
print(solution.isValid("(]"))
print(solution.isValid("([)]"))
print(solution.isValid("{[]}"))
print(solution.isValid(""))
print(solution.isValid("["))
 */


/*
//merge two sorted lists
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
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        //是否有空
        var tempL1 = l1
        var tempL2 = l2
        var resultTemp: ListNode? = ListNode.init(0)
        let result = resultTemp

        repeat {

            if tempL1 == nil {
                resultTemp?.next = tempL2
                tempL2 = tempL2?.next
                break
            }
            
            if tempL2 == nil {
                resultTemp?.next = tempL1
                tempL1 = tempL1?.next
                break
            }
            
            if let l1Value = tempL1?.val, let l2Value = tempL2?.val {
                if l1Value <= l2Value {
                    resultTemp?.next = ListNode.init(l1Value)
                    tempL1 = tempL1?.next
                }
                else {
                    resultTemp?.next = ListNode.init(l2Value)
                    tempL2 = tempL2?.next
                }
            }
            
            resultTemp = resultTemp?.next
        } while tempL1 != nil || tempL2 != nil

        return result?.next
    }
}

let solution = Solution()
let node1: ListNode? = ListNode.init(1)
var tempNode1: ListNode? = node1
for intValue in [2, 4] {
    tempNode1?.next = ListNode.init(intValue)
    tempNode1 = tempNode1?.next
}

let node2: ListNode? = ListNode.init(1)
var tempNode2 = node2
for intValue in [3, 4] {
    tempNode2?.next = ListNode.init(intValue)
    tempNode2 = tempNode2?.next
}

let result = solution.mergeTwoLists(node2, node1)
print(result?.description)
 */


/*
//remove duplicates from sorted array
class Solution {
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        if nums.count == 0 {
            return 0
        }
        
        var index = nums.count - 1
        var tempValue: Int? = nil
        while index >= 0 {
            if let duplicate = tempValue, duplicate == nums[index] {
                nums.remove(at: index)
            }
            
            //temp value forward
            tempValue = nums[index]
            index -= 1
        }
        return nums.count
    }
}

let solution = Solution()
var array = [0,0,1,1,1,2,2,3,3,4]
print(solution.removeDuplicates(&array))
print(array)

var test01 = [0,0]
print(solution.removeDuplicates(&test01))
print(test01)

var test02 = [0]
print(solution.removeDuplicates(&test02))
print(test02)

var test03 = [Int]()
print(solution.removeDuplicates(&test03))
print(test03)
 */

/*
//remove element
class Solution {
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        if nums.count == 0 {
            return 0
        }
        
        var index = 0
        var indexJ = index
        while indexJ < nums.count {
            if nums[indexJ] != val {
                let temp = nums[index]
                nums[index] = nums[indexJ]
                nums[indexJ] = temp
                index += 1
            }
            
            indexJ += 1
        }
        
        nums = Array(nums[0..<index])
        return index
    }
}

let solution = Solution()
var testNums = [0,1,2,2,3,0,4,2]
print(solution.removeElement(&testNums, 2))
print(testNums)

var test01 = [Int]()
print(solution.removeElement(&test01, 2))
print(test01)

var test02 = [0]
print(solution.removeElement(&test02, 0))
print(test02)

var test03 = [0, 0, 0]
print(solution.removeElement(&test03, 0))
print(test03)
*/

/*
//implement strStr()
class Solution {
    func strStr(_ haystack: String, _ needle: String) -> Int {
        if needle.isEmpty {
            return 0
        }
        
        var result = -1 //没有找打
        let needles: Array<Character> = Array(needle)
        outter: for (index, _) in haystack.enumerated() {
            if index+needles.count > haystack.count {
                break outter
            }
            
            var temp = 0
            var haystackTemp = index
            var same = true
            inner: while temp < needles.count {
                let needleChar = needles[temp]
                let startIndex = haystack.startIndex;
                let charIndex = haystack.index(startIndex, offsetBy: haystackTemp)
                let haystackChar = haystack[charIndex]
                temp += 1
                haystackTemp += 1
                if needleChar != haystackChar {
                    same = false
                    break inner
                }
            }
            
            if same {
                result = index
                break outter
            }
        }
        return result
    }
}

let solution = Solution()
print(solution.strStr("jioafjaof", ""))
print(solution.strStr("", ""))
print(solution.strStr("", "ajfoa"))
print(solution.strStr("ajfoa", "ajfoa"))
print(solution.strStr("ajfoa", "oa"))
 */


//search insertion position
class Solution {
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        if nums.count == 0 {
            return 0
        }
        
        /*
        var position = 0
        var hasChanged = false
        for (index, value) in nums.enumerated() {
            if value >= target {
                position = index
                hasChanged = true
                break
            }
        }
        return hasChanged ? position : nums.count
         */
        var lower = 0
        var upper = nums.count - 1
        var mid = (lower + upper)/2
        while lower != upper {
            let value = nums[mid]
            //找到了匹配
            if value == target {
                break
            }
            
            if value < target {
                lower = mid
            }
        }
        return mid
    }
}

let solution = Solution()
let test01 = [1,3,5,6]
print(solution.searchInsert(test01, 5))

let test02 = [1,3,5,6]
print(solution.searchInsert(test02, 2))

let test03 = [1,3,5,6]
print(solution.searchInsert(test03, 7))

let test04 = [1,3,5,6]
print(solution.searchInsert(test04, 0))
