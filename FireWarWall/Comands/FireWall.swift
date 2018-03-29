//
//  FireWall.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation



//MARK: --------  Prorocol Delegate  ---------------
protocol FireWallDelegate {
//    func fireWallEstablished(conections:[ConectionNode])
    func fireWallEstablished(ips:[NetStatConection])
    func fireWallBlocked(ips:[NetStatConection])
    func fireWall(state:Bool)
    func fireWallDidUnblockIp()
    func fireWallDidBlockIp()
    func fireWallDidStart()
    func fireWallDidStop()
}







//MARK: --------  Class  FireWall  ---------------
class FireWall: ComandRunerDelegate ,comandDelegate {
    
    
    
    
    //MARK: --------  Class  VARS  ---------------
    public var comandRuner:ComandRuner = ComandRuner()
    public var comandRuner2:ComandRuner = ComandRuner()
    private var ipsManager:IpsManager = IpsManager()
    private var needUpdateState:Bool = true
    private var needUpdateConections:Bool = true
    private var needUpdateBlockedIps:Bool = false
    private var isTimerRuning:Bool = false
    var fireWallDelegate:FireWallDelegate!
    
   
    
    
    init() {
        comandRuner.comandRunerDelegate = self //FIXME: dosobjetos de lo mismo delegados se mezclan las cosas .....
//      timerStart()
    }
    
    
    
    
    
    
    
    //MARK: --------  Public Funcs  ---------------
    
    public func runInfo(comand:Comand) {
        
        
        let infoComand = AppTaskComand(comand:comand,
                                          praser:GenericPraser(),
                                          delegate: self)
        infoComand.run()
    }
    
    
    
    
    public func showConections() {
        needUpdateConections = true
//        timerStart()
        if !isTimerRuning  {
            netStat2 = AppTaskComand(comand:netStat, praser:netPraser, delegate:self)
            backgroundTimer()
//            timerStart()
        }
        
    }
    public func showConectionsOff()  {
        needUpdateConections = false
    }
    
    
    public func state()  {
        
//    let state = FireWallState()
//    let fireWallStatePraser = StatePraser()
//
//    let fireWallState = AppTaskComand(comand:state, praser:fireWallStatePraser, delegate:self)
//    fireWallState.run()
        
       comandRuner.runComand(type:.fireWallState, ip: nil)
        
        
//        needUpdateState = true
//
//        if !isTimerRuning  {
////            backgroundTimer()
////            timerStart()
//        }
    }
    
    public func stateOff()  {
        needUpdateState = false
    }
    
    
    func start() {
//        comandRuner.runComand(type:.fireWallStart, ip: nil)
        
        let startFireComand = AppTaskComand(comand:FireWallStart(), praser:GenericPraser(), delegate: self)
        startFireComand.run()
    }
    
    func stop() {
//        comandRuner.runComand(type:.fireWallStop, ip: nil)
        let stopFireComand = AppTaskComand(comand:FireWallStop(), praser:GenericPraser(), delegate: self)
        stopFireComand.run()
    }
    
    
    func showBlockedIpsOn() {
        needUpdateBlockedIps = true
        
        if !isTimerRuning  {
//            backgroundTimer()
        }
        
        
    }
    func showBlockedIpsOff() {
        
        needUpdateBlockedIps = false
        
        if !isTimerRuning  {
//            backgroundTimer()
        }
        
    }
    
    
    func block(ip:String) {
        comandRuner.runComand(type:.addFireWallBadHosts, ip:ip)
    }
    
    func unBlock(ip:String) {
        comandRuner.runComand(type:.deleteFireWallBadHosts, ip:ip)
    }
    func showBlockedIps() {
        
    }
    func unblockAllIps() {
        
    }
    func blockAllIps() {
        
    }
    func killConection(ip:String) {
        
    }
    
    
    
    //MARK: --------  ComandDelegate ---------------
    func comand(finish: ComandType, result: Any) { //TODO: devolver comand con data prased o data tuple prased y comad type ??
        
        
//        if finish == .netStat {
//            needUpdateState = true
//            needUpdateConections = false
//        }else  if finish == .fireWallState {
//            needUpdateState = false
//            needUpdateConections = true
//        }
    }
    
    
    
    //MARK: --------  ComandRuner Delegate ---------------
    func comand(finishWith data: String) {
        parseComand(result: data)
    }
    func comand(type:ComandType, finishWith data: String) {
         parseComand(result: data)
        print(type)
    }
    
    
    
    
    
    
    //MARK: --------    Funcs  --------------- //TODO: refractor ....otra clase o struct
    
    func parseComand(result:String)  {
        
        if result.contains("Status") {
            if result.contains("Disabled") {
                fireWallDelegate?.fireWall(state:false)
                
            }else if result.contains("Enabled"){
                fireWallDelegate?.fireWall(state:true)
            }
        }
            
            
        else if result.contains("tcp4") {
            let conections =   ipsManager.findNetStatIps(inText: result)
            fireWallDelegate?.fireWallEstablished(ips:conections)
        }
        else   {
            let badHosts =   ipsManager.findBlockedIps(inText: result)
            //            print(badHosts)
            fireWallDelegate?.fireWallBlocked(ips:badHosts)
        }
        
    }
    
    var timer:Timer!
    
    func timerStart() {
        
         timer  = Timer(timeInterval:3, target: self, selector:#selector(self.backgroundTimerAction(_:)), userInfo:nil, repeats:true)
        
         timer.fire()
        
    }
    
    
    private func backgroundTimer()  {
        isTimerRuning = true
        
        DispatchQueue.global(qos:.background).async{
            let timer:Foundation.Timer = Foundation.Timer.scheduledTimer(timeInterval:3, target: self, selector: #selector(self.backgroundTimerAction(_:)), userInfo: nil, repeats: true);
            //            print("State Timer  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
            let runLoop:RunLoop = RunLoop.current;
            runLoop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
            runLoop.run();
            
        }
    }
    
    
    @objc func backgroundTimerAction(_ timer: Foundation.Timer) -> Void {
        
//        self.runComands()
        comandRuner.runComand(type:.fireWallState, ip: nil)
        
        netStat2.run()
        
        
    }
    
    
    var queue1:DispatchQueue!
    var queue2:DispatchQueue!
//  var queue2 = DispatchQueue(label: "com.knowstack.queue2", qos:.background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
    
    
    let netStat = NetStat()
    let netPraser = netStatPraser()
    
    var  netStat2:AppTaskComand!
    
    public func runComands() {
        
        
//        if needUpdateState {
//             queue1 = DispatchQueue(label: "com.knowstack.queue1", qos:.background, attributes:.concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
//            queue1.sync {
//
 
            
//            let state = FireWallState()
//            let fireWallStatePraser = StatePraser()
            
//                let   fireWallState = AppTaskComand(comand:state, praser:fireWallStatePraser, delegate:self)
//                fireWallState.run()
            
//                fireWallState.run()
                
                
//                self.comandRuner2.runComand(type:.fireWallState, ip: nil)
//                print("State ...")
//            }
//        }
        
        if needUpdateConections {
             queue2 = DispatchQueue(label: "com.knowstack.queue2", qos:.background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
             queue2.sync {
//
            netStat2.run()
                
//            let netStat = NetStat()
//            let netPraser = netStatPraser()
            
//                 netStat2 = AppTaskComand(comand:netStat, praser:netPraser, delegate:self)
//                 netStat2.run()
                
//                self.comandRuner.runComand(type:.netStat, ip: nil)
//                 print("Conections ...")
            }
         }
        
//        if needUpdateBlockedIps {
//            let queue3 = DispatchQueue(label: "com.knowstack.queue3", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
//            queue3.sync {
            
//                let badHosts = AppTaskComand(comand:FireWallBadHosts(), praser:badHostsPraser(), delegate: self)
//                 badHosts.run()
                
//                self.comandRuner.runComand(type:.fireWallBadHosts, ip: nil)
//                 print("Bad hosta ips ...")
//            }
//        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}













