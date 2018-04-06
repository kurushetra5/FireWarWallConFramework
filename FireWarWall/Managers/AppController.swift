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
    func finish(comand: String, withResult result:Any) {
        
        
        switch comand {
        case "netstat":
            if let netStatResults:[NetStatConection] = result as?  [NetStatConection] {
                
                print("-------------------")
                print(comand)
                print(netStatResults)
                
                for conection in netStatResults {
                    checkDataBaseFor(conection:conection)
                }
                
                
                // enviarlas al bataBase si esta la recoge
                // si no esta la guarda y la envia ha ipLocation envia
            }
            
         case "fireWallState":
            print(result)
            
        case "generic":
            print(result)
            
        case "whois":
            print(result)
        default:
            print("falta")
        }
        
    }
    
    
    
    
    //MARK: -------- DATABASE ---------------
    func checkDataBaseFor(conection:NetStatConection) {
        
         print(dataBase.dataBase.count)
        
        if let node = dataBase.isInDataBase(ip:conection) {
            //            DispatchQueue.main.sync {
            appAlivedelegate?.alive(conections:node) //guardar datos
            //            }
            
            
        } else {
            //            ipLocator.fetchIpLocation(conection:conection)
            
            print("No in DataBase falta guardar la.. conexion")
        }
        
        
    }
    
    
    
    
    //MARK: -------- Info ---------------
    public func runInfo(comand:Comand) {
        
        
//        ComandsRuner.runForEver(comand:comand)
        
        
        ComandsRuner.run(comand:comand) { (result) in
//            var result:PraserResult!
//            result = comandResult as PraserResult

            if let comandResult:[String] = result as? [String]  {
                print(comandResult)
            }
        
            
            
        }
    }
    
    
    
    
    
    //MARK: -------- Conections ---------------
    public func showConections()  {
        
        let netStatPraser:NetStatPraser = NetStatPraser()
        let netStat:Comand = KUNetStat(praser:netStatPraser , name: "netstat")
        ComandsRuner.runForEver(comand:netStat)
    }
    
    
    
    public func showConectionsOff()  {
       ComandsRuner.stopForEver(comand:"netstat")
    }
    
    
    
    
    
    
    //MARK: -------- FIREWALL ---------------
    
    public func  fireWallState() {
        
//        let genericPraser:PraserType =  .generic
//        let state:Comand = FireWallState(withId:"yameacuerdo8737", name:"fireWallState", praser: genericPraser.praserToUse())
        
        
//        let state:Comand = IdComand(id:"yameacuerdo8737",
//                                    name:"fireWallState" ,
//                                    praser: genericPraser.praserToUse(),
//                                    taskPath: "",
//                                    taskArgs: [""])
        
        
        let  fireWallStatePraser:FireWallStatePraser = FireWallStatePraser()
        let fireWallState:Comand = KUFireWallState(withId:"yameacuerdo8737", name: "fireWallState", praser:fireWallStatePraser)
        ComandsRuner.runForEver(comand:fireWallState)
        
        
        
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
