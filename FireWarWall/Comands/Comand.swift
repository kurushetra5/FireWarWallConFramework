//
//  Comand.swift
//  FireWarWall
//
//  Created by Kurushetra on 22/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol  ComandRunerDelegate {
    func comand(finishWith data:String)
//    func comand(type:ComandType, finishWith data:String)
}

//protocol  ComandRunerInfoDelegate {
//    func comand(finishWith data:String)
//}



class  ComandRuner  {
    
    public var comandRunerDelegate:ComandRunerDelegate!
//    public var comandRunerInfoDelegate:ComandRunerInfoDelegate!
    private var stateResult:String = "no set"
    private var comandType:ComandType!
    
    
    
    public func runComand(type:ComandType, ip:String!) {
        stateResult = "no set"
        comandType = type
        
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
        case .nsLookup:
            run(comand:NsLookup(withIp:ip))
        default:
            print("")
        }
        
    
    }
    
    
    
    
    
    
  private  func run(comand:Comand ) {
 
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let fh = pipe.fileHandleForReading
        fh.waitForDataInBackgroundAndNotify()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(receivedData), name: NSNotification.Name.NSFileHandleDataAvailable, object: nil)
        
//        task.terminationHandler = {task -> Void in
//        print("acabado")
//
//        }
        task.launch()
    }
    
    
    
    
    @objc private func receivedData(notif : NSNotification) {
        
        let fh:FileHandle = notif.object as! FileHandle
        
        let data = fh.availableData
        if data.count > 1 {
            let string =  String(data: data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
            self.stateResult = string!
            self.comandRunerDelegate?.comand(finishWith: self.stateResult)
//             self.comandRunerDelegate?.comand(type:comandType, finishWith: self.stateResult)
            fh.waitForDataInBackgroundAndNotify()
        }
    }
    
    
    
    
    
}


