//
//  TimerBackground.swift
//  FireWarWall
//
//  Created by Kurushetra on 25/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




class  TimerBackground  {
    
    
    
    func backgroundTimer()  {
   
        DispatchQueue.global(qos:.userInitiated).async{
            NSLog("NSTimer will be scheduled...");
            
           
            let timer:Foundation.Timer = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.backgroundTimerAction(_:)), userInfo: nil, repeats: true);
           
            let runLoop:RunLoop = RunLoop.current;
            runLoop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
            runLoop.run();
            print("timer invocado")
        }
        
    }
    
    
    @objc func backgroundTimerAction(_ timer: Foundation.Timer) -> Void {
        NSLog("The timer is fired.");
    }
    
    
    
    
    
    
    
    
    
}
