//
//  AppController.swift
//  FireWarWall
//
//  Created by Kurushetra on 14/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol AppAliveConectionsDelegate {
    func alive(conections:ConectionNode)
    
    
}

protocol AppFireWallDelegate {
    func blocked(ips:[ConectionNode])
    func fireWall(state:Bool)
    
}


protocol AppInfoComandsDelegate {
    func comandFinishWith(data:String)
    
    
}


final class AppController:FireWallDelegate,IPLocatorDelegate ,dataBaseDelegate ,InfoComandsManagerDelegate{
    
    
    
    
    static let shared = AppController()
    
    var appAlivedelegate:AppAliveConectionsDelegate!
    var appFireWallDelegate:AppFireWallDelegate!
    var appInfoComandsDelegate:AppInfoComandsDelegate!
    
    var fireWall:FireWall = FireWall()
    var dataBase:dataBaseManager = dataBaseManager()
    var infoComands:InfoComandsManager = InfoComandsManager()
    var ipLocator:IPLocator = IPLocator()
    
    
    
    init() {
        setDelegates()
    }
    
    func setDelegates() {
        fireWall.fireWallDelegate = self
        ipLocator.locatorDelegate = self
        dataBase.delegate = self
        infoComands.infoComandsManagerDelegate = self
    }
    
    
    
    
   //MARK: -------- Info ---------------
    public func runInfo(comand:ComandType) {
        infoComands.run(comand:comand)
    }
    
    
    
    
    
   //MARK: -------- Conections ---------------
    public func showConections()  {
        fireWall.showConections()
    }
    
    public func showConectionsOff()  {
        fireWall.showConectionsOff()
    }
    
    
    
    
    //MARK: -------- FIREWALL ---------------
    
    public func  fireWallState() {
        fireWall.state()
    }
    public func  fireWallStateOff() {
        fireWall.stateOff()
    }
    
   public func  startFireWall() {
        fireWall.start()
    }
    
   public func  stopFireWall() {
        fireWall.stop()
    }
    
    func showBlockedIpsOn() {
        fireWall.showBlockedIpsOn()
    }
    func showBlockedIpsOff() {
        fireWall.showBlockedIpsOff()
    }
    
    public func block(ip:ConectionNode) {
        fireWall.block(ip: ip.ip!)
    }
    public func unblock(ip:ConectionNode) {
        fireWall.unBlock(ip:ip.ip!)
    }
    
    
    
    
    //MARK: -------- DATABASE ---------------
    func checkDataBaseFor(conection:NetStatConection) {
        
        if let node = dataBase.isInDataBase(ip:conection) {
            DispatchQueue.main.sync {
                appAlivedelegate?.alive(conections:node)
            }
            
            
        }else {
            ipLocator.fetchIpLocation(conection:conection)
        }
        
        
    }
    
    func cleanIpsDataBase() {
        dataBase.cleanDataBase()
    }
    
 
    
    
    //MARK: -------- InfoComands Delegate ---------------
    func comand(finishWith data:String) {
        appInfoComandsDelegate?.comandFinishWith(data:data)
    }
    
    
    
    
    
    
    //MARK: -------- FireWallDelegates ---------------
    
    func fireWallEstablished(conections:[ConectionNode]) {
        
    }
    
 
    
    func fireWallEstablished(ips:[NetStatConection]) {
        
        for conection in ips {
            checkDataBaseFor(conection:conection) //TODO: Cambiar pasarle un ConectionNode
        }
        
    }
    
    
    
    func fireWallBlocked(ips:[NetStatConection]) {
 
        var blockedConections:[ConectionNode] = []
        for blocked in ips {
            let node = dataBase.isInDataBase(ip:blocked)
            blockedConections.append(node!)
        }
        DispatchQueue.main.sync {
         appFireWallDelegate?.blocked(ips:blockedConections)
        }
    }
    
    
    
    
    func fireWall(state:Bool) {
        //         print("fireWall running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        DispatchQueue.main.sync {
            appFireWallDelegate?.fireWall(state:state)
        }
    }
    
    
    
    
    
    //TODO: para extension de protocolo ---------------------------
    func fireWallDidUnblockIp() {
        fireWall.showBlockedIps()
    }
    func fireWallDidBlockIp() {
        fireWall.showBlockedIps()
    }
    func fireWallDidStart() {
        fireWall.state()
    }
    func fireWallDidStop() {
        fireWall.state()
    }
    
    
    
    
    
    
    //MARK: --------  ipLocationDelegate ---------------
    func ipLocationReady(ipLocation:NetStatConection) {
        
        dataBase.ipLocationReady(ipNode:ipLocation)
    }
    
    
    
    
    
    //MARK: --------  dataBaseDelegate ---------------
    func filled(node:ConectionNode, amountIps:Int) {
        
    }
    func filled(node:ConectionNode) {
        
        if node.conected == true {
           self.appAlivedelegate?.alive(conections:node)
        }
        
        
    }
    
    
}
