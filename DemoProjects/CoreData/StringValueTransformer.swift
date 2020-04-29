//
//  StringValueTransformer.swift
//  CoreDataDemo
//
//  Created by JiangWang on 2020/4/8.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit

class StringValueTransformer: ValueTransformer {
    

    override class func transformedValueClass() -> AnyClass {
        return Data.self as! AnyClass
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let contents = value as? String else { return nil }
        return contents.data(using: .utf32)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf32)
    }

}


