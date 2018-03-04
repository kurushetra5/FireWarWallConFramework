//
//  AppController.swift
//  FireWarWall
//
//  Created by Kurushetra on 14/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol  AppControllerDelegate {
    func alive(conections:ConectionNode)
    func blocked(ips:[ConectionNode])
    func fireWall(state:Bool)
    
}



class AppController:FireWallDelegate,IPLocatorDelegate ,dataBaseDelegate {
    
    init() {
        configureFireWall()
    }
    //    static let shared = AppController()
    var delegate:AppControllerDelegate!
    
    var fireWall:FireWall = FireWall()
    var dataBase:dataBaseManager = dataBaseManager()
    var ipLocator:IPLocator = IPLocator()
    
    
    
    func configureFireWall() {
        fireWall.fireWallDelegate = self
        ipLocator.locatorDelegate = self
        dataBase.delegate = self
    }
    
    
    
    
    
    
    
    
    func checkDataBaseFor(conection:NetStatConection) {
        
        if let node = dataBase.isInDataBase(ip:conection) {
            DispatchQueue.main.sync {
                delegate?.alive(conections:node)
            }
            
            
        }else {
            ipLocator.fetchIpLocation(conection:conection)
        }
        
        
    }
    
    
    func locationFor(ip:String) {
        
    }
    
    
    
    
    
    //MARK: -------- FireWallDelegates ---------------
    
    func fireWallEstablished(conections:[ConectionNode]) {
        
    }
    
    
    func fireWallEstablished(ips:[NetStatConection]) {
        //         print("fireWallEstablished running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        //        checkDataBaseFor(ip:ips[0].destinationIp)
        for conection in ips {
            checkDataBaseFor(conection:conection) //TODO: Cambiar pasarle un ConectionNode
        }
        
    }
    
    
    
    func fireWallBlocked(ips:[ConectionNode]) {
        delegate?.blocked(ips:ips)
    }
    
    
    
    
    func fireWall(state:Bool) {
        //         print("fireWall running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        DispatchQueue.main.sync {
            delegate?.fireWall(state:state)
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
        
        self.delegate?.alive(conections:node)
        
    }
    
    
}
