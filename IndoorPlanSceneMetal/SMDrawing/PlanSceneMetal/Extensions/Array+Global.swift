/*
 * Created by Ujin Velichko.
 * Copyright (c) UranCompany. All rights reserved.
 */

/*
 * Parallel maping
 */

import UIKit

let cLockLabel = "serial-queue"

extension Array {
  @discardableResult public func pmap<T>(transform: @escaping ((Element, Int) -> T)) -> [T] {
    guard !self.isEmpty else { return [] }
    
    var result: [(Int, [T])] = []
    let group                = DispatchGroup()
    let lock                 = DispatchQueue(label: cLockLabel)
    
    let step: Int = Swift.max(1, self.count / ProcessInfo.processInfo.activeProcessorCount) // step can never be 0
    var stepIndex = 0
    
    while stepIndex * step < self.count {
      let capturedStepIndex = stepIndex
      var stepResult: [T]   = []
      
      DispatchQueue
        .global(qos: .default)
        .async(group: group) {
          for i in (capturedStepIndex * step)..<((capturedStepIndex + 1) * step) {
            if i < self.count {
              let mappedElement = transform(self[i], i)
              stepResult        += [mappedElement]
            }
          }
          
          lock.async(group: group) {
            result += [(capturedStepIndex, stepResult)]
          }
      }
      
      stepIndex += 1
    }
    
    if group.wait(timeout: .distantFuture) == .success {
      return result.sorted { $0.0 < $1.0 }.flatMap { $0.1 }
    }
    
    return []
  }
  //-----------------------------------------------------------------------------------
}

