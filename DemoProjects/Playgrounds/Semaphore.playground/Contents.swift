import UIKit

let semaphore = DispatchSemaphore(value: 1)
let global = DispatchQueue.global(qos: .background)

for index in 1...10 {
    print("semaphore will wait \(index)")
    let ret = semaphore.wait(timeout: DispatchTime.now())
    guard ret == DispatchTimeoutResult.success else {
        print("\(ret)")
        break
    }
    global.async {
        sleep(1)
        print("global asyn excuted \(index)")
        semaphore.signal()
    }
    print("main queue work \(index)")

}
