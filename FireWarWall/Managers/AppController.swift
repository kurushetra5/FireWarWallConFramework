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
    
    
//    var comandsManager:ComandsManager = ComandsManager()
//    var fireWall:FireWall = FireWall()
    var dataBase:dataBaseManager = dataBaseManager()
    var infoComands:InfoComandsManager = InfoComandsManager()
    var ipLocator:IPLocator = IPLocator()
    
    
    
    init() {
        setUpDelegates()
          ComandsRuner.comandsRunerId = "yameacuerdo8737"
       
    }
    
    
    
    //MARK: -------- Configuration  ---------------
    func setUpDelegates() {
//        comandsManager.comandsManagerDelegate = self
//        fireWall.fireWallDelegate = self
        ComandsRuner.comandsRunerDelegate = self
        ipLocator.locatorDelegate = self
        dataBase.delegate = self
//        infoComands.infoComandsManagerDelegate = self
    }
    
    
    
    
    //MARK: -------- Set Delegates  for ViewControllers---------------
    //    func setConections(delegate:ConectionsDelegate) {
    //         comandsManager.conectionsDelegate = delegate
    //    }
//    func setFireWallState(delegate:FireWallStateDelegate) {
//        comandsManager.fireWallStateDelegate = delegate
//    }
    
    
    
    //MARK: -------- ComandsRunerDelegate Delegates ---------------
    func finish(comand: ComandType, withResult result: [String]) {
        
    }
    
    
    
    //MARK: -------- Info ---------------
    public func runInfo(comand:String, args:String) {
        
        ComandsRuner.run(comand:comand, args:args, forEver: false) { (result) in
            print(result)
            self.infoComandsDelegate?.comandFinishWith(data:result)
        }
    }
    
    
    
    
    
    //MARK: -------- Conections ---------------
    public func showConections()  {
//        comandsManager.showConections()
        
    }
    
    public func showConectionsOff()  {
//        comandsManager.showConectionsOff()
    }
    
    
    
    
    
    //MARK: -------- FIREWALL ---------------
    
    public func  fireWallState() {
        
        ComandsRuner.run(comand:"fireWallState", args:nil, forEver: true) { (result) in
            print(result)
            self.infoComandsDelegate?.comandFinishWith(data:result)
        }
    }
    
    public func  fireWallStateOff() {
//        comandsManager.fireWallStateOff()
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
    
    
    
    
    //MARK: -------- DATABASE ---------------
//    func checkDataBaseFor(conection:NetStatConection) {
//
//        if let node = dataBase.isInDataBase(ip:conection) {
//            DispatchQueue.main.sync {
//                appAlivedelegate?.alive(conections:node)
//            }
//
//
//        }else {
//            ipLocator.fetchIpLocation(conection:conection)
//        }
//
//
//    }
    
    func cleanIpsDataBase() {
        dataBase.cleanDataBase()
    }
    
    
    
    
//    //MARK: -------- InfoComands Delegate ---------------
//    func comand(finishWith data:String) {
//        infoComandsDelegate?.comandFinishWith(data:data)
//    }
//
    
    
    
    
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
