//
//  JWAutoIncrementCounter.swift
//  BeginnerCook
//
//  Created by JiangWang on 20/12/2017.
//  Copyright © 2017 awesomejiang.com. All rights reserved.
//

import UIKit

//MARK: Global Counter
var counter: UInt64 = 0

class JWAutoIncrementCounter: NSObject {
    static func currentCounter() -> UInt64 {
        let tempCounter = counter
        counter = (counter + 1)
        return tempCounter
    }
}
