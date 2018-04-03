//
//  AppController.swift
//  FireWarWall
//
//  Created by Kurushetra on 14/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation
import KUTaskFramework


protocol AliveConectionsDelegate {
    func alive(conections:ConectionNode)
}

protocol FireWallDelegateState {
    func fireWall(state:Bool)
    
}

protocol FireWallDelegateBlocked {
    func blocked(ips:[ConectionNode]!)
}


protocol InfoComandsDelegate {
    func comandFinishWith(data:String)
    
    
}





final class AppController:IPLocatorDelegate ,dataBaseDelegate ,ComandsRunerDelegate  {
    
    
    
    
    static let shared = AppController()
    
    var appAlivedelegate:AliveConectionsDelegate!
    var fireWallDelegateState:FireWallDelegateState!
    var infoComandsDelegate:InfoComandsDelegate!
    var fireWallDelegateBlocked:FireWallDelegateBlocked!
    
    
 
    var dataBase:dataBaseManager = dataBaseManager()
    var infoComands:InfoComandsManager = InfoComandsManager()
    var ipLocator:IPLocator = IPLocator()
    
    
    
    init() {
        setUpDelegates()
 
       
    }
    
    
    
    //MARK: -------- Configuration  ---------------
    func setUpDelegates() {
 
        ComandsRuner.comandsRunerDelegate = self
        ipLocator.locatorDelegate = self
        dataBase.delegate = self
 
    }
    
    
    
    
   
    
    //MARK: -------- ComandsRunerDelegate Delegates ---------------
    func finish(comand: ComandType, withResult result: [String]) {
        
    }
    
    
    
    
    //MARK: -------- Info ---------------
    public func runInfo(comand:String, args:String) {
        
        
        let genericPraser:PraserType =  .generic
        let ls:CustomComand = .custom(praser:genericPraser.praserToUse(), taskPath:"/bin/ls", taskArgs: ["-a"])
        
        
        
        //        let nsLookup:NetInfoComands = .nsLookup(ip: "8.8.8.8")
        
        ComandsRuner.run(comand:ls.comand()) { (comandResult) in
            var result:PraserResult!
            result = comandResult as PraserResult
            
            print(comandResult)
            print(result.dataType)
            print(result.dataArray)
            print(result.dataString)
            
        }
        
        
        
        //        ComandsRuner.runGeneric(comand:"/usr/bin/nslookup", args: ["8.8.8.8"]) { (result) in
        //            print(result)
        //        }
        
        //        ComandsRuner.run(comand:"/usr/bin/nslookup", args: "8.8.8.8", forEver: false) { (result) in
        //            print(result)
        //        }
        
        //        ComandsRuner.run(comand:.nsLookup, withIp:"8.8.8.8") { (result) in
        //            print(result)
        //        }
        
        //        ComandsRuner.run(comand:comand, args:args, forEver: false) { (result) in
        //            print(result)
        //            self.infoComandsDelegate?.comandFinishWith(data:result)
        //        }
    }
    
    
    
    
    
    //MARK: -------- Conections ---------------
    public func showConections()  {
        
        let fireWallState:FireWallComands = .fireWallState(id:"yameacuerdo8737")

        ComandsRuner.runForEver(comand:fireWallState.comand()) { (result) in
            print(result)
//            self.infoComandsDelegate?.comandFinishWith(data:result)
        }
        
        
    }
    
    public func showConectionsOff()  {
//        comandsManager.showConectionsOff()
    }
    
    
    
    
    
    //MARK: -------- FIREWALL ---------------
    
    public func  fireWallState() {
        
        let fireWallState:FireWallComands = .fireWallState(id:"yameacuerdo8737")
        
        ComandsRuner.run(comand: fireWallState.comand()) { (result) in
            print(result)
        }
        
//        ComandsRuner.runForEver(comand:fireWallState.comand()) { (result) in
//            print(result)
//            self.infoComandsDelegate?.comandFinishWith(data:result)
//        }
        
 
    }
    
    public func  fireWallStateOff() {
         ComandsRuner.stopForEver(comand:nil)
    }
    
    public func  startFireWall() {
//        comandsManager.startFireWall()
    }
    
    public func  stopFireWall() {
//        comandsManager.stopFireWall()
    }
    
    func showBlockedIpsOn() {
//        comandsManager.showBlockedIpsOn()
    }
    func showBlockedIpsOff() {
//        comandsManager.showBlockedIpsOff()
    }
    
    public func block(ip:ConectionNode) {
//        comandsManager.block(ip: ip)
    }
    public func unblock(ip:ConectionNode) {
//        comandsManager.unblock(ip:ip)
    }
    
    
    
    
 
    func cleanIpsDataBase() {
        dataBase.cleanDataBase()
    }
    
    
    
    
 
    
    
    
    
    //MARK: -------- ComandsManager Delegates ---------------
//    func fireWall(blocked: [NetStatConection]) {
//
//        var blockedConections:[ConectionNode]!
//
//        for blockedIp in blocked {
//            let node = dataBase.isInDataBase(ip:blockedIp)
//            blockedConections.append(node!)
//        }
//        DispatchQueue.main.sync {
//            if blockedConections  == nil {
//               fireWallDelegateBlocked?.blocked(ips:nil)
//            }else {
//              fireWallDelegateBlocked?.blocked(ips:blockedConections)
//            }
//
//        }
//    }
    
//    func established(conections: [NetStatConection]) {
//
//        for conection in conections {
//            checkDataBaseFor(conection:conection) //TODO: Cambiar pasarle un ConectionNode
//        }
//    }
    func fireWall(state:Bool) {
        //         print("fireWall running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        DispatchQueue.main.sync {
            fireWallDelegateState?.fireWall(state:state)
        }
    }
    
    func infoComandFinishWith(data:String) {
        infoComandsDelegate?.comandFinishWith(data:data)
    }
    
    
    
    
    
    //MARK: -------- FireWallDelegates ---------------
//    func fireWallEstablished(ips:[NetStatConection]) {
//
//        for conection in ips {
//            checkDataBaseFor(conection:conection) //TODO: Cambiar pasarle un ConectionNode
//        }
//
//    }
    
    
    
    
    
//    func fireWallBlocked(ips:[NetStatConection]) {
//
//        var blockedConections:[ConectionNode] = []
//        for blocked in ips {
//            let node = dataBase.isInDataBase(ip:blocked)
//            blockedConections.append(node!)
//        }
//        DispatchQueue.main.sync {
//            fireWallDelegateBlocked?.blocked(ips:blockedConections)
//        }
//    }
    
    
    
    
//    func fireWall(state:Bool) {
//        //         print("fireWall running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
//        DispatchQueue.main.sync {
//            fireWallDelegateState?.fireWall(state:state)
//        }
//    }
    
    
    
    
    
    //TODO: para extension de protocolo ---------------------------
    func fireWallDidUnblockIp() {
//        fireWall.showBlockedIps()
    }
    func fireWallDidBlockIp() {
//        fireWall.showBlockedIps()
    }
    func fireWallDidStart() {
//        fireWall.state()
    }
    func fireWallDidStop() {
//        fireWall.state()
    }
    
    
    
    
    
    
    
    
    
    //MARK: --------  ipLocationDelegate ---------------
//    func ipLocationReady(ipLocation:NetStatConection) {
//
//        dataBase.ipLocationReady(ipNode:ipLocation)
//    }
    
    
    
    
    
    //MARK: --------  dataBaseDelegate ---------------
    func filled(node:ConectionNode, amountIps:Int) {
        
    }
    func filled(node:ConectionNode) {
        
        if node.conected == true {
            self.appAlivedelegate?.alive(conections:node)
        }
        
        
    }
    
    
}
