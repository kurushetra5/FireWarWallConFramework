//
//  FireWall.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol FireWallDelegate {
    func established(conections:[ConectionNode])
    func blocked(ips:[ConectionNode])
}





class FireWall  {
    
    
    var ipsManager:IpsManager = IpsManager()
    var fireWallDelegate:FireWallDelegate!
    var comandType:ComandType!
    var arrayResult:[String] = []
    
    var processDelegate:ProcessDelegate!
    
    
    
    func state() -> Bool {
        
        return true
    }
    
    func detectConections() {
        
    }
    
    func startFireWall() {
        
    }
    func stopFireWall() {
        
    }
    func block(ip:String) {
        
    }
    func unBlock(ip:String) {
        
    }
    func showBlockedIps() {
        
    }
    func unblockAllIps() {
        
    }
    func blockAllIps() {
        
    }
    func killConection(ip:String) {
        
    }
    
    
    
    
    
    
    func runComand(type:ComandType, ip:String!, delegate:ProcessDelegate) {
        
        comandType = type
        arrayResult = []
        
        if type is ComandIp  {
            if ip == nil {
                print("runComand : Ip Es NILL")
                return
            }
        }
        
        switch type {
            
        case .netStat:
            run(comand:NetStat(), delegate:delegate)
        case .fireWallState:
            run(comand:FireWallState(), delegate:delegate)
        case .addFireWallBadHosts:
            run(comand:AddFireWallBadHosts(withIp:ip), delegate:delegate)
        case .deleteFireWallBadHosts:
            run(comand:DeleteFireWallBadHosts(withIp:ip), delegate:delegate)
        case .fireWallStop:
            run(comand:FireWallStop(), delegate:delegate)
        case .fireWallStart:
            run(comand:FireWallStart(), delegate:delegate)
        case .fireWallBadHosts:
            run(comand:FireWallBadHosts(), delegate:delegate)
        default:
            print("")
        }
        
        //startTimerEvery(seconds:0.5)
    }
    
    
    
    
    
    
    func run(comand:Comand, delegate:ProcessDelegate) {
        
        processDelegate = delegate
        //        ipsLocatorFounded = []
        
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
            self.processResults()
        }
        task.launch()
    }
    
    
    
    
    
    func  processResults()  {
        
        OperationQueue.main.addOperation({
            
            switch self.comandType {
             
            case  .fireWallState:
                if self.arrayResult.count >= 1 {
                    self.processDelegate.newDataFromProcess(data:self.arrayResult[0], processName:self.comandType!.rawValue)
                }
            case  .deleteFireWallBadHosts:
                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallStart:
                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallStop:
                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallBadHosts:
                if self.arrayResult.count >= 1 {
//                    let ips = self.ipsManager.findIpsIn(text:self.arrayResult[0])
//                    for ip in ips! {
////                        self.dataBase.nodeWith(ip:ip, amountIps:ips!.count)
//                    }
                    
                }else if self.arrayResult.count == 0 {
                    self.processDelegate.newDataFromProcess(data:"0", processName:self.comandType!.rawValue)
                }
            case .addFireWallBadHosts:
                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            default:
                let ips = self.ipsManager.findNetStatIps(inText:self.arrayResult[0])
                
//                for ip in ips! {
////                    self.dataBase.nodeWith(ip:ip, amountIps:ips!.count)
//                }
                
                //                print(ips)
                //                let nodes:[TraceRouteNode] = self.fileExtractor.extractIpsFromMTRoute(ips:self.arrayResult[0])
                //                for node in nodes {
                //                    node.nodeFilledDelegate = self
                //                    node.fillNodeWithData()
                //
                //                }
            }
        })
        
    }
    
    
    
    
    @objc func receivedData(notif : NSNotification) {
        
        let fh:FileHandle = notif.object as! FileHandle
        
        let data = fh.availableData
        if data.count > 1 {
            let string =  String(data: data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
            arrayResult.append(string!)
            print(arrayResult)
            fh.waitForDataInBackgroundAndNotify()
        }
    }
    
    
    
    
 
}









 



