//
//  NetStatQueues.swift
//  Kuru_Threads-timers-Task
//
//  Created by Kurushetra on 2/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



class NetStatQueues  {

 
    private let operationQueue: OperationQueue = OperationQueue()

    public init() {
 
    }

    
    
    
    func getFireWallState(onCompleted: ((String) -> ())?) {
 
        let fireWallStateOperation = FireWallStateOperation()
        let parseFireWallStateOperation =  ParseFireWallStateOperation()
        
        fireWallStateOperation.completionBlock = {
//           print("fireWallStateOperation acabado")
           parseFireWallStateOperation.responseData = fireWallStateOperation.responseData
            print(parseFireWallStateOperation.responseData ?? "no response state")
        }

        parseFireWallStateOperation.completionBlock = {
            onCompleted?(parseFireWallStateOperation.resultData ?? "nada parse")
//            print(parseFireWallStateOperation.resultData ?? "nada")
        }
        
        parseFireWallStateOperation.addDependency(fireWallStateOperation)
        operationQueue.addOperations([parseFireWallStateOperation, fireWallStateOperation], waitUntilFinished: false)
    }

    
    
}
