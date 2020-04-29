//
//  StringValueTransformer.swift
//  CoreDataDemo
//
//  Created by JiangWang on 2020/4/8.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import UIKit
import CryptoSwift

class StringValueTransformerV2: ValueTransformer {
    
    static let key = try! Rabbit(key: [5, 2, 0, 3, 8, 3, 3, 8, 5, 2, 0, 3, 8, 3, 3, 8], iv: [1, 2, 8, 5, 6, 9, 9, 6])

    override class func transformedValueClass() -> AnyClass {
        return Data.self as! AnyClass
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let contents = value as? String else { return nil }
        guard let encrypted = try? contents.encrypt(cipher: StringValueTransformerV2.key) else { return nil }
        return encrypted.data(using: .utf8)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }
        guard let encrypted = String(data: data, encoding: .utf8) else { return nil }
        let hexData = Array(hex: encrypted)
        guard let decrypted = try? hexData.decrypt(cipher: StringValueTransformerV2.key) else { return nil }
        return String(data: Data(decrypted), encoding: .utf8)
    }

}


