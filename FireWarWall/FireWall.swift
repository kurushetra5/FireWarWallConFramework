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
    var fireWallDelegate:FireWallDelegate!
    
    
    
    init() {
        comandRuner.comandRunerDelegate = self
    }
    
    
    //MARK: --------  ComandRuner Delegate ---------------
    
    
    func comand(finishWith data: String) {
        
        print(data)
        parseComand(result: data)
    }
    
    
    
    
    //MARK: --------  Public Funcs  ---------------
   public func runComands() {
        
        let queue1 = DispatchQueue(label: "com.knowstack.queue1", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        let queue2 = DispatchQueue(label: "com.knowstack.queue1", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        queue1.sync {
            
            self.comandRuner.runComand(type:.fireWallState, ip: nil)
        }
        queue2.sync {
            
            self.comandRuner.runComand(type:.netStat, ip: nil)
        }
        
    }
    
    
    
    
    public func state()  {
        
 
    }
    
    
    func showConections() {
 
          backgroundTimer()
        
 
    }
    
    
    
    func pauseNetStat() {
 
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
    
    
    
    
  //MARK: --------  Private Funcs  ---------------
    
   private func backgroundTimer()  {
        
        DispatchQueue.global(qos:.background).async{
            let timer:Foundation.Timer = Foundation.Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.backgroundTimerAction(_:)), userInfo: nil, repeats: true);
            print("State Timer  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
            let runLoop:RunLoop = RunLoop.current;
            runLoop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
            runLoop.run();
            
        }
    }
    
    
    @objc func backgroundTimerAction(_ timer: Foundation.Timer) -> Void {
        runComands()
 
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













