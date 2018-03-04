//
//  ViewController.swift
//  FireWallOperations
//
//  Created by Kurushetra on 2/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Cocoa

class ViewController: NSViewController,ComandRunerDelegate {
    
    

    
     var netStatQueues:NetStatQueues = NetStatQueues()
     private var comandRuner:ComandRuner = ComandRuner()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//          netstat()
         comandRuner.comandRunerDelegate = self
//        queueTest7()
        comandsBgTimer()
 
    }

     
    func netstat() {
        netStatQueues.getFireWallState { (state) in
            print(state)
        }
    }
    
    
    
    
    func comandFinishWith(data: String) {
        
        print(data)
    }
    
    
    
    func runComands() {
        
        let queue1 = DispatchQueue(label: "com.knowstack.queue1", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        let queue2 = DispatchQueue(label: "com.knowstack.queue1", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        queue1.sync {
 
            self.comandRuner.runComand(type:.netStat, ip: nil)
        }
        queue2.sync {
 
            self.comandRuner.runComand(type:.fireWallState, ip: nil)
        }
        
    }
    
    
    
    
    func comandsBgTimer()  {
        
        DispatchQueue.global(qos:.background).async{
            let timer:Foundation.Timer = Foundation.Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.backgroundTimerAction(_:)), userInfo: nil, repeats: true);
//            print("State Timer  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
            let runLoop:RunLoop = RunLoop.current;
            runLoop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
            runLoop.run();
            
        }
    }
    
    
    @objc func backgroundTimerAction(_ timer: Foundation.Timer) -> Void {
//        NSLog("State invocado");
        runComands()
//        print("State Action  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        //        sampleCodeOne()
        
        //        netstatComand.sendConectionsEvery(seconds:1.0)
        
    }
}

