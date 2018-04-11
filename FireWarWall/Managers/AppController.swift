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





final class AppController:IPLocatorDelegate ,dataBaseDelegate ,ComandsRunerDelegate ,ComandsContinouslyDelegate {
    
    
    
    
    
    
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
        ComandsRuner.comandsContinouslyDelegate = self
        ComandsRuner.comandsRunerDelegate = self
        ipLocator.locatorDelegate = self
        dataBase.delegate = self
        
    }
    
    
    
    //MARK: -------- ComandsContinouslyDelegate Delegates ---------------
    func newDataFromContinously(comand: String, withResult newData: Any) {
        
      let newData:[Dictionary<String,String>] = newData as! [Dictionary<String,String>]
      var ordered:[Dictionary<String,String>] = [Dictionary<String,String>]()
      
        
        print(newData.count)
       
        
        for ping in newData {
//            var seq = ping["seq"] as! String
            var ttl = ping["ttl"] as! String
            var len = ping["lenght"] as! String
//             print(seq)
            
            if ping["flag"] == "DF" {
//               print(seq)
                print(ttl)
                print(len)
                
            }
            
//            ordered["seq"]
            
//            if ping["seq"] == "0" {
//               print("seq ------- 0")
//            }
        }
        
        
        
        
        // -p pattern
//        You may specify up to 16 ``pad'' bytes to fill out the packet you send.  This is useful for diag-
//        nosing data-dependent problems in a network.  For example, ``-p ff'' will cause the sent packet
//        to be filled with all ones.
//"echo nomeacuerdo87378737 | sudo -S tcpdump -nnv -i en0 icmp -x  >ping7.txt &")
        // -W timpo de espera muy util para filtrar
        //  -n  Numeric output only.  No attempt will be made to lookup symbolic names for host addresses.
        // -o manda uno y sale
//        var maskICMP = ""   // -M mask | time
//        var preLoad = "" //  -l preload
//        var time = "" // -i wait
//        var ttl = "" // -m ttl 1-255
//        var lenght1 = ""
//        var seq = "" // -c count
//        var lenght2 = ""
//        var flags = "" // -D      Set the Don't Fragment bit.
//        var size = "" // -G sweepmaxsize -h sweepincrsize  -g sweepminsize
        
        
//        var line = "01:19:30.138209 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto ICMP (1), length 84, bad cksum 0 (->b48e)!)"
        
        
        
        //        192.168.2.100 > 192.168.2.102: ICMP echo reply, id 4809, seq 1, length 64
        
        
        
        
        print(comand)
        
        
    }
    
    
    
    
    
    func finishWith(error:Error) {
        
    }
    
    
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
    
    
    func runContinously(comand:Comand) {
        
//        ComandsRuner.runForReadingContinously(comand:comand)
         ComandsRuner.runForReadContinously(comand:comand)
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
        ComandsRuner.runForEver(comand:netStat, interval:2.0)
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
        ComandsRuner.runForEver(comand:fireWallState, interval:1.0)
        
        
        
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
