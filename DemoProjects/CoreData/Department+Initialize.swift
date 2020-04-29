//
//  Department+Initialize.swift
//  CoreDataDemo
//
//  Created by JiangWang on 2020/4/8.
//  Copyright © 2020 JiangWang. All rights reserved.
//

import Foundation

extension Department {
    
    static let initializeOnce: () = {
        let stringTransformer = StringValueTransformer()
        ValueTransformer.setValueTransformer(stringTransformer, forName: NSValueTransformerName.init("StringValueTransformer"))
        let rabitTransformer = StringValueTransformerV2()
        ValueTransformer.setValueTransformer(rabitTransformer, forName: NSValueTransformerName.init("StringValueTransformerV2"))
    }()
}

