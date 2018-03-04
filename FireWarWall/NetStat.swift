//
//  NetStat.swift
//  FireWarWall
//
//  Created by Kurushetra on 22/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol  NetstatDelegate {
    func  established(conections:[NetStatConection])
}



class  Netstat:  ComandRunerDelegate  {
    
    public var netstatDelegate:NetstatDelegate!
    private var netstatTimer:Timer!
    private var comandRuner:ComandRuner = ComandRuner()
    private var ipsManager:IpsManager = IpsManager()
    
    
    
    init() {
        comandRuner.comandRunerDelegate = self
    }
    
    
    
    
    
    
    // --------- Netstat Timer ----------------------
    public func sendConectionsEvery(seconds:Double) {
//        startNetstatEvery(seconds:seconds)
//          backgroundTimer()
//         print("sendConectionsEvery  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        comandRuner.runComand(type:.netStat, ip:nil)
    }
    
    public func stopNetstatTimer() {
        
        if (netstatTimer != nil) {
            netstatTimer.invalidate()
        }
    }
    
    
    private func startNetstatEvery(seconds:Double) {
        netstatTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector:#selector(timerNetstatSelector), userInfo: nil, repeats: true)
        
    }
    
    @objc private func timerNetstatSelector() {
        comandRuner.runComand(type:.netStat, ip:nil)
        
    }
    
    
    
    //MARK:--------------------- ComandRunerDelegate --------------
    func comandFinishWith(data:String) {
//        OperationQueue.main.addOperation({
//         print("comandFinishWith  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        let ips = self.ipsManager.findNetStatIps(inText:data)
        self.netstatDelegate?.established(conections:ips)
//        })
    }
    
    
    
    
    
//    func backgroundTimer()  {
//
//        DispatchQueue.global(qos:.userInitiated).async{
//            NSLog("NSTimer will be scheduled...");
//
//
//            let timer:Foundation.Timer = Foundation.Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.backgroundTimerAction(_:)), userInfo: nil, repeats: true);
//
//            let runLoop:RunLoop = RunLoop.current;
//            runLoop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
//            runLoop.run();
//            print("timer invocado")
//        }
//
//    }
//
//
//    @objc func backgroundTimerAction(_ timer: Foundation.Timer) -> Void {
//        NSLog("The timer is fired.");
//        comandRuner.runComand(type:.netStat, ip:nil)
//    }
    
}
