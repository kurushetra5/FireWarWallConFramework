//
//  ParseFireWallStateOperation.swift
//  Kuru_Threads-timers-Task
//
//  Created by Kurushetra on 1/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



class ParseFireWallStateOperation: TaskOperation {
    
    var responseData: String?
    var resultData: String?
    
    override init() {
        
    }
    
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        executing(true)
        //        provider.restCall(urlString: urlString) { (data) in
        //            self.responseData = data
        resultData = "Parse"
                   self.executing(false)
                   self.finish(true)
        //        }
    }
}
