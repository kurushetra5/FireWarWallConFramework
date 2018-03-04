//
//  FireWallStateOperation.swift
//  Kuru_Threads-timers-Task
//
//  Created by Kurushetra on 1/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



class FireWallStateOperation: TaskOperation {
    
    var responseData: String?
    private var comandRuner:ComandRuner = ComandRuner()
    
    override init() {
        
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        executing(true)
        
        comandRuner.runComand(comand:NetStat()) { (state) in
            self.responseData = state
            self.executing(false)
            self.finish(true)
        }
        
//        comandRuner.runComand(type:FireWallState()) { (state) in
        
//        }
        
        
    }
    
    
}
