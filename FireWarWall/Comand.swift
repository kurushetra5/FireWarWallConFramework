//
//  Comand.swift
//  FireWarWall
//
//  Created by Kurushetra on 22/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol  ComandRunerDelegate {
    func comandFinishWith(data:String)
}



class  ComandRuner  {
    
    public var comandRunerDelegate:ComandRunerDelegate!
    private var stateResult:String = "no set"
    
    
    
    public func runComand(comand:Comand,  onCompleted: ((String?)  ->  ())?) {
        
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let fh = pipe.fileHandleForReading
        fh.waitForDataInBackgroundAndNotify()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(receivedData), name: NSNotification.Name.NSFileHandleDataAvailable, object: nil)
        
        task.terminationHandler = {task -> Void in
            
            onCompleted?(self.stateResult)
//            self.processResults()
        }
        task.launch()
        
        
    }
    
    
    
    public func runComand(type:ComandType, ip:String!) {
        
 
        stateResult = "no set"
        
        if type is ComandIp  {
            if ip == nil {
                print("runComand : Ip Es NILL")
                return
            }
        }
        
        switch type {
        case .netStat:
            run(comand:NetStat())
        case .fireWallState:
            run(comand:FireWallState())
        case .addFireWallBadHosts:
            run(comand:AddFireWallBadHosts(withIp:ip))
        case .deleteFireWallBadHosts:
            run(comand:DeleteFireWallBadHosts(withIp:ip))
        case .fireWallStop:
            run(comand:FireWallStop())
        case .fireWallStart:
            run(comand:FireWallStart())
        case .fireWallBadHosts:
            run(comand:FireWallBadHosts())
        default:
            print("")
        }
        
    
    }
    
    
    
    
    
    
  private  func run(comand:Comand ) {
//         print("run  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let fh = pipe.fileHandleForReading
        fh.waitForDataInBackgroundAndNotify()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(receivedData), name: NSNotification.Name.NSFileHandleDataAvailable, object: nil)
        
        task.terminationHandler = {task -> Void in
                       print("acabado")
//            OperationQueue.main.addOperation({
//            self.processResults()
//             print("self.processResults()  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
//                  })
        }
        task.launch()
    }
    
    
    
    
    
   private func  processResults()  {
//         print(" processResults()  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
//        OperationQueue.main.addOperation({
      DispatchQueue.main.sync {
             self.comandRunerDelegate?.comandFinishWith(data:self.stateResult)
//         print("self.comandRunerDelegate?  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
            }
    
    }
    
    
    
    
     @objc private func receivedData(notif : NSNotification) {
        
        let fh:FileHandle = notif.object as! FileHandle
        
        let data = fh.availableData
        if data.count > 1 {
            let string =  String(data: data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
//             OperationQueue.main.addOperation({
            self.stateResult = string!
//              DispatchQueue.main.sync {
                self.comandRunerDelegate?.comandFinishWith(data:self.stateResult)
                //         print("self.comandRunerDelegate?  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
//              }
            
//             })
            
            fh.waitForDataInBackgroundAndNotify()
        }
    }
    
    
}


