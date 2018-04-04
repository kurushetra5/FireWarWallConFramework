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
    func finish(comand: String, withResult result: [String]) {
        print("-------------------")
        print(comand)
        print(result)
    }
    
    
    
    
    //MARK: -------- Info ---------------
    public func runInfo(comand:String, args:String) {
        
        
        let genericPraser:PraserType =  .generic
        let comand:Comand = GenericComand(name:"generic", praser:genericPraser.praserToUse(),taskPath:"/bin/ls", taskArgs: ["-a"])
        
        ComandsRuner.run(comand:comand) { (comandResult) in
            var result:PraserResult!
            result = comandResult as PraserResult
            
            print(comandResult)
            print(result.dataType)
            print(result.dataArray)
            print(result.dataString)
            
        }
    }
    
    
    
    
    
    //MARK: -------- Conections ---------------
    public func showConections()  {
        
        
        let genericPraser:PraserType =  .generic
        let netStat:Comand = NetStat(praser:genericPraser.praserToUse() , name:"netstat")
        
        ComandsRuner.runForEver(comand:netStat) { (result) in
            print(result)
//         self.infoComandsDelegate?.comandFinishWith(data:result)
        }
        
        
    }
    
    public func showConectionsOff()  {
        //        comandsManager.showConectionsOff()
    }
    
    
    
    
    
    
    //MARK: -------- FIREWALL ---------------
    
    public func  fireWallState() {
        
        let genericPraser:PraserType =  .generic
//        let state:Comand = FireWallState(withId:"yameacuerdo8737", name:"fireWallState", praser: genericPraser.praserToUse())
        
        
        let state:Comand = IdComand(id:"yameacuerdo8737",
                                    name:"fireWallState" ,
                                    praser: genericPraser.praserToUse(),
                                    taskPath: "",
                                    taskArgs: [""])
        
        ComandsRuner.runForEver(comand:state) { (result) in
            print(result)
            //         self.infoComandsDelegate?.comandFinishWith(data:result)
        }
        
        
        
        //        let fireWallState:FireWallComands = .fireWallState(id:"yameacuerdo8737")
        
        //        ComandsRuner.run(comand: fireWallState.comand()) { (result) in
        //            print(result)
        //        }
        
        //        ComandsRuner.runForEver(comand:fireWallState.comand()) { (result) in
        //            print(result)
        //            self.infoComandsDelegate?.comandFinishWith(data:result)
        //        }
        
        
    }
    
    public func  fireWallStateOff() {
        
        ComandsRuner.stopForEver(comand:"fireWallState")
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
