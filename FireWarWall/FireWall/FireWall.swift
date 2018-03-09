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
    func fireWallEstablished(conections:[ConectionNode])
    func fireWallEstablished(ips:[NetStatConection])
    func fireWallBlocked(ips:[NetStatConection])
    func fireWall(state:Bool)
    func fireWallDidUnblockIp()
    func fireWallDidBlockIp()
    func fireWallDidStart()
    func fireWallDidStop()
}







//MARK: --------  Class  FireWall  ---------------
class FireWall: ComandRunerDelegate {
    
    
    //MARK: --------  Class  VARS  ---------------
    private var comandRuner:ComandRuner = ComandRuner()
    private var ipsManager:IpsManager = IpsManager()
    private var needUpdateState:Bool = false
    private var needUpdateConections:Bool = false
    private var needUpdateBlockedIps:Bool = false
    private var isTimerRuning:Bool = false
    var fireWallDelegate:FireWallDelegate!
    
    
    
    
    init() {
        comandRuner.comandRunerDelegate = self //FIXME: dosobjetos de lo mismo delegados se mezclan las cosas .....
        
    }
    
    
    
    
    //MARK: --------  Public Funcs  ---------------
    
    public func showConections() {
        needUpdateConections = true
        
        if !isTimerRuning  {
            backgroundTimer()
        }
        
    }
    public func showConectionsOff()  {
        needUpdateConections = false
    }
    
    public func state()  {
        needUpdateState = true
        
        if !isTimerRuning  {
            backgroundTimer()
        }
    }
    
    public func stateOff()  {
        needUpdateState = false
    }
    
    
    func start() {
        comandRuner.runComand(type:.fireWallStart, ip: nil)
    }
    
    func stop() {
        comandRuner.runComand(type:.fireWallStop, ip: nil)
    }
    
    
    func showBlockedIpsOn() {
        needUpdateBlockedIps = true
        
        if !isTimerRuning  {
            backgroundTimer()
        }
        
        
    }
    func showBlockedIpsOff() {
        
        needUpdateBlockedIps = false
        
        if !isTimerRuning  {
            backgroundTimer()
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
    
    
    
    
    
    private func backgroundTimer()  {
        isTimerRuning = true
        
        DispatchQueue.global(qos:.background).async{
            let timer:Foundation.Timer = Foundation.Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.backgroundTimerAction(_:)), userInfo: nil, repeats: true);
            //            print("State Timer  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
            let runLoop:RunLoop = RunLoop.current;
            runLoop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
            runLoop.run();
            
        }
    }
    
    
    @objc func backgroundTimerAction(_ timer: Foundation.Timer) -> Void {
        runComands()
        
    }
    
    
    
    
    public func runComands() {
        
        
        if needUpdateState {
            let queue1 = DispatchQueue(label: "com.knowstack.queue1", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
            queue1.sync {
                
                self.comandRuner.runComand(type:.fireWallState, ip: nil)
                print("State ...")
            }
        }
        
        if needUpdateConections {
            let queue2 = DispatchQueue(label: "com.knowstack.queue2", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
            queue2.sync {
                
                self.comandRuner.runComand(type:.netStat, ip: nil)
                print("Conections ...")
            }
        }
        
        if needUpdateBlockedIps {
            let queue3 = DispatchQueue(label: "com.knowstack.queue3", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
            queue3.sync {
                
                self.comandRuner.runComand(type:.fireWallBadHosts, ip: nil)
                print("Blocked ips ...")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}













