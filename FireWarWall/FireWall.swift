//
//  FireWall.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol FireWallDelegate {
    func fireWallEstablished(conections:[ConectionNode])
    func fireWallEstablished(ips:[NetStatConection])
    func fireWallBlocked(ips:[ConectionNode])
    func fireWall(state:Bool)
    func fireWallDidUnblockIp()
    func fireWallDidBlockIp()
    func fireWallDidStart()
    func fireWallDidStop()
}





class FireWall  {
    
    
    var ipsManager:IpsManager = IpsManager()
    var fireWallDelegate:FireWallDelegate!
    var comandType:ComandType!
    var arrayResult:[String] = []
    
   
    
    
    
    func state()  {
        
        runComand(type:ComandType.fireWallState, ip: nil)
        
    }
    
    
    func showConections() {
        runComand(type:.netStat,ip:nil)
    }
    
    func start() {
        
        runComand(type: .fireWallStart, ip: nil)
//        fireWallDelegate?.fireWall(state:state()) //TODO: Cambiar ...solo state()
    }
    
    func stop() {
        runComand(type: .fireWallStop, ip: nil)
//        fireWallDelegate?.fireWall(state:state())
    }
    
    func block(ip:String) {
        runComand(type: .addFireWallBadHosts, ip: ip)
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
    
    
    
    
    
    
    func runComand(type:ComandType, ip:String! ) {
        
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
        
        //startTimerEvery(seconds:0.5)
    }
    
    
    
    
    
    
    func run(comand:Comand ) {
        
        
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
//            print("acabado")
            self.processResults()
        }
        task.launch()
    }
    
    
    
    
    
    func  processResults()  {
        
        OperationQueue.main.addOperation({
            
            switch self.comandType {
             
            case  .fireWallState:
                if self.arrayResult.count >= 1 {
                    self.fireWallDelegate.fireWall(state:true)
//                    self.processDelegate.newDataFromProcess(data:self.arrayResult[0], processName:self.comandType!.rawValue)
                    
                }
            case  .deleteFireWallBadHosts:
                  self.fireWallDelegate.fireWallDidUnblockIp()
//                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallStart:
                  self.fireWallDelegate.fireWallDidStart()
//                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallStop:
                self.fireWallDelegate.fireWallDidStop()
//                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallBadHosts:
                if self.arrayResult.count >= 1 {
//                    let ips = self.ipsManager.findIpsIn(text:self.arrayResult[0])
//                    for ip in ips! {
////                        self.dataBase.nodeWith(ip:ip, amountIps:ips!.count)
//                    }
                    
                }else if self.arrayResult.count == 0 {
//                    self.processDelegate.newDataFromProcess(data:"0", processName:self.comandType!.rawValue)
                }
            case .addFireWallBadHosts:
                self.fireWallDelegate.fireWallDidBlockIp()
//                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            
            default:
                let ips = self.ipsManager.findNetStatIps(inText:self.arrayResult[0])
                self.fireWallDelegate.fireWallEstablished(ips:ips)
//                print(ips)
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
//            print(arrayResult)
            fh.waitForDataInBackgroundAndNotify()
        }
    }
    
    
    
    
 
}









 



