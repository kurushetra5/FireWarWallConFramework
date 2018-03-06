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
    func fireWallBlocked(ips:[ConectionNode])
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
    private var isTimerRuning:Bool = false
    var fireWallDelegate:FireWallDelegate!
    
    
    
    init() {
        comandRuner.comandRunerDelegate = self
        
    }
    
    
    
    
    //MARK: --------  Public Funcs  ---------------
    
    public func showConections() {
        needUpdateConections = true
        
        if isTimerRuning == false {
            backgroundTimer()
        }
        
    }
    public func showConectionsOff()  {
        needUpdateConections = false
    }
    
    public func state()  {
        needUpdateState = true
        
        if isTimerRuning == false {
            backgroundTimer()
        }
    }
    
    public func stateOff()  {
        needUpdateState = false
    }
    
    
    func start() {
 
    }
    
    func stop() {
 
    }
    
    func block(ip:String) {
 
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
    
    
    
    
    //MARK: --------  ComandRuner Delegate ---------------
    func comand(finishWith data: String) {
        parseComand(result: data)
    }
    
    
   
    
    
    
    
    
  //MARK: --------    Funcs  ---------------
    
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
            let queue2 = DispatchQueue(label: "com.knowstack.queue1", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
            queue2.sync {
                
                self.comandRuner.runComand(type:.netStat, ip: nil)
                print("Conections ...")
            }
        }
    }
    
    
    
    
    func parseComand(result:String)  {
        
        if result.contains("Status") {
            if result.contains("Disabled") {
                 fireWallDelegate?.fireWall(state:false)
                
            }else if result.contains("Enabled"){
                fireWallDelegate?.fireWall(state:true)
            }
        }else {
            let conections =   ipsManager.findNetStatIps(inText: result)
            fireWallDelegate?.fireWallEstablished(ips:conections)
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}













