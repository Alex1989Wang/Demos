//
//  CaptureSessionQueue.swift
//  Metal
//
//  Created by JiangWang on 2019/8/14.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import Foundation

class SessionSerialQueue {
    
    /// 用于标记queue的身份
    private struct QueueIdentity {
        let label: String!
    }
    
    /// 初始值
    private static var counter: Int = 0
    
    /// 内部使用的dispatch queue
    let queue: DispatchQueue!
    
    /// 内部使用的queue标识
    private let queueSpecificsKey = DispatchSpecificKey<QueueIdentity>()

    /// queue名称
    private let label: String!

    init() {
        //生成label
        let queueLabel = "com.jiangwang.sessionQueue" + "\(SessionSerialQueue.counter)"
        SessionSerialQueue.counter += 1
        label = queueLabel

        let queueId = QueueIdentity.init(label: queueLabel)
        queue = DispatchQueue.init(label: queueLabel)
        queue.setSpecific(key: queueSpecificsKey, value: queueId)
    }
    
    /// 当前执行上下文中queue的标识
    ///
    /// - Returns: 当前queue的标识
    private func currentQueueIdentity() -> QueueIdentity? {
        return DispatchQueue.getSpecific(key: queueSpecificsKey)
    }
}

// MARK: - Public
extension SessionSerialQueue {
    func async(execute work: @escaping () -> Void) {
        //在当前queue中
        if let id = currentQueueIdentity(), id.label == label {
            work()
            return
        }
        
        queue.async {
            work()
        }
    }
}
