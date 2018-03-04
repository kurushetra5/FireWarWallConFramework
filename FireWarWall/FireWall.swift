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
class FireWall: NetstatDelegate,ComandRunerDelegate {
    
    
    
    
    //MARK: --------  Class  VARS  ---------------
    private var comandRuner:ComandRuner = ComandRuner()
    private var ipsManager:IpsManager = IpsManager()
    private var netstatComand:Netstat = Netstat()
    private var comandType:ComandType!
    private var conectionsResult:[String] = []
    private var stateResult:String = "no set"
    private var isEngineStoped = false
    
    var fireWallDelegate:FireWallDelegate!
    
    
    
    init() {
        comandRuner.comandRunerDelegate = self
    }
    
    
    func comandFinishWith(data: String) {
        print(data)
    }
    
    
    
    //MARK: --------  Public Funcs  ---------------
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
    
    
    
    
    public func state()  {
        
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.runComand(type:ComandType.fireWallState, ip: nil)
        
//            DispatchQueue.main.async {
//               print("acabado state")
//            }
//        }
    
//       backgroundTimer()
//        timerInGCD(repeated: true)
    }
    
    
    func showConections() {
//        runComand(type:.netStat,ip:nil)
//        netstatComand.netstatDelegate = self
//          netstatComand.sendConectionsEvery(seconds:1.0)
//         backgroundTimer2()
          backgroundTimer()
        
//        while isEngineStoped == false {
//            netstatComand.sendConectionsEvery(seconds:1.0)
//            isEngineStoped = true
//        }
        
//        sampleCodeOne()
    }
    
    
    
    func pauseNetStat() {
        netstatComand.stopNetstatTimer()
    }
    
    
    func start() {
        runComand(type: .fireWallStart, ip: nil)
    }
    
    func stop() {
        runComand(type: .fireWallStop, ip: nil)
    }
    
    func block(ip:String) {
        runComand(type: .addFireWallBadHosts, ip: ip)
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
    
    
    
    
    func  established(conections:[NetStatConection]) {
         print("established running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        fireWallDelegate?.fireWallEstablished(ips:conections)
        
//        runComand(type:ComandType.fireWallState, ip: nil)
    }
    
    func backgroundTimer()  {
        
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
//        NSLog("State invocado");
//        runComand(type:ComandType.fireWallState, ip: nil)
//        print("State Action  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        //        sampleCodeOne()
        
//        netstatComand.sendConectionsEvery(seconds:1.0)
        
    }
    
    
    func backgroundTimer2()  {
        
        DispatchQueue.global(qos:.utility).async{
          let timer:Foundation.Timer = Foundation.Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.backgroundTimerAction2(_:)), userInfo: nil, repeats: true);
             print("backgroundTimer2  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
            let runLoop:RunLoop = RunLoop.current;
            runLoop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
            runLoop.run();
            
        }
    }
    
    
    @objc func backgroundTimerAction2(_ timer: Foundation.Timer) -> Void {
        NSLog("NetStat invocado");
              netstatComand.sendConectionsEvery(seconds:1.0)
//        print("backgroundTimerAction2  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
//        sampleCodeOne()
        
        
        
    }
    
    
    func sampleCodeOne() {
        let operationQueue: OperationQueue = OperationQueue.main
        let completionBlockOperation: BlockOperation = BlockOperation.init()
        {
            print("completion Block ")
//            self.netstatComand.sendConectionsEvery(seconds:1.0)
//              self.runComand(type:ComandType.fireWallState, ip: nil)
//            self.backgroundTimer()
        }
        
        
        let workerBlockOperation:BlockOperation = BlockOperation.init()
        {
//            self.runComand(type:ComandType.fireWallState, ip: nil)
            print("worker block")
//            self.netstatComand.sendConectionsEvery(seconds:1.0)
//            self.backgroundTimer2()
            
//            self.sampleCodeOneWorkerMethod()
             }
        
         completionBlockOperation.addDependency(workerBlockOperation)
        operationQueue.addOperation(workerBlockOperation)
         operationQueue.addOperation(completionBlockOperation)
    }
    
    
    func sampleCodeOneWorkerMethod ()
    {
        print("State finish")
         print("printApples is running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
//        runComand(type:ComandType.fireWallState, ip: nil)
//         OperationQueue.main.addOperation({
//        DispatchQueue.global(qos:.userInitiated).async  {
        
        
//          self.netstatComand.sendConectionsEvery(seconds:1.0)
//        }
//        self.fireWallDelegate.fireWall(state:false)
//        })
    }
    
    
    let queue: DispatchQueue? = DispatchQueue(label: "GCDTimerQueue", attributes: DispatchQueue.Attributes.concurrent);
    var timer: DispatchSourceTimer? = nil;
    
    
    func timerInGCD(repeated:Bool) -> Void {
        NSLog("_timerInGCD invoked.");
        if (self.timer != nil) {
            self.timer!.cancel();
        }
        self.timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: queue);
        self.timer?.schedule(deadline: .now(), repeating: .seconds(2) ,leeway:.milliseconds(0));
        
        self.timer!.setEventHandler(handler: { () -> Void in
            NSLog("In GCD Timer, block is invoked ...");
            self.runComand(type:ComandType.fireWallState, ip: nil)
            
            if(!repeated) {
                self.timer!.cancel();
                NSLog("The timer is canceled.");
            }
        });
        
        NSLog("timer will be resumed.");
        self.timer!.resume();
    }
    
    
    
    //MARK: --------  Private Funcs  ---------------
    
    
    private func runComand(type:ComandType, ip:String! ) {
        
//        pauseNetStat()
        comandType = type
        conectionsResult = []
        stateResult = "no set"
        
        if type is ComandIp  {
            if ip == nil {
                print("runComand : Ip Es NILL")
                return
            }
        }
        
        switch type {
         
        case .fireWallState:
            run(comand:FireWallState())
        case .addFireWallBadHosts:
            run(comand:AddFireWallBadHosts(withIp:ip))
        case .deleteFireWallBadHosts:
            run(comand:DeleteFireWallBadHosts(withIp:ip))
        case .fireWallStop:
            run(comand:FireWallStop())
        case .fireWallStart:
            run(comand:FireWallStart())
        case .fireWallBadHosts:
            run(comand:FireWallBadHosts())
        default:
            print("")
        }
        
        //startTimerEvery(seconds:0.5)
    }
    
    
    
    
    
    
    func run(comand:Comand ) {
        
        
        //        ipsLocatorFounded = []
        
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
        
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let fh = pipe.fileHandleForReading
        fh.waitForDataInBackgroundAndNotify()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(receivedData), name: NSNotification.Name.NSFileHandleDataAvailable, object: nil)
        
        task.terminationHandler = {task -> Void in
            //            print("acabado")
//            OperationQueue.main.addOperation({
//             DispatchQueue.main.async {
                  self.processResults()
//            }
//            })
           
        }
       
        task.launch()
//        netstatComand.sendConectionsEvery(seconds:1.0)
    }
    
    
    
    
    
    func  processResults()  {
        
        
//        OperationQueue.main.addOperation({
//          DispatchQueue.main.async {
            //               print("acabado state")
            
            switch self.comandType {
                
            case  .fireWallState:
                if self.stateResult != "no set" {
                    
                    if self.stateResult.contains("Disabled") {
                        self.fireWallDelegate?.fireWall(state:false)
                        
                    }else if self.stateResult.contains("Enabled"){
                        self.fireWallDelegate?.fireWall(state:true)
                    }
//                     self.showConections()
                    //                    self.fireWallDelegate.fireWall(state:true)
                    //                    self.processDelegate.newDataFromProcess(data:self.arrayResult[0], processName:self.comandType!.rawValue)
                   
                }
//                self.netstatComand.sendConectionsEvery(seconds:1.0)
            case  .deleteFireWallBadHosts:
                self.fireWallDelegate.fireWallDidUnblockIp()
            //                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallStart:
                self.fireWallDelegate.fireWallDidStart()
            //                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallStop:
                self.fireWallDelegate.fireWallDidStop()
            //                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallBadHosts:
                if self.conectionsResult.count >= 1 {
                    //                    let ips = self.ipsManager.findIpsIn(text:self.arrayResult[0])
                    //                    for ip in ips! {
                    ////                        self.dataBase.nodeWith(ip:ip, amountIps:ips!.count)
                    //                    }
                    
                }else if self.conectionsResult.count == 0 {
                    //                    self.processDelegate.newDataFromProcess(data:"0", processName:self.comandType!.rawValue)
                }
            case .addFireWallBadHosts:
                self.fireWallDelegate.fireWallDidBlockIp()
                //                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
                
            default:
//                let ips = self.ipsManager.findNetStatIps(inText:self.conectionsResult[0])
//                self.fireWallDelegate.fireWallEstablished(ips:ips)
                               print("default comand ???")
                //                for ip in ips! {
                ////                    self.dataBase.nodeWith(ip:ip, amountIps:ips!.count)
                //                }
                
                //                print(ips)
                //                let nodes:[TraceRouteNode] = self.fileExtractor.extractIpsFromMTRoute(ips:self.arrayResult[0])
                //                for node in nodes {
                //                    node.nodeFilledDelegate = self
                //                    node.fillNodeWithData()
                //
                //                }
            }
//               }
//         })
       
//        self.netstatComand.sendConectionsEvery(seconds:1.0)
       
    }
    
    
    
    
    @objc func receivedData(notif : NSNotification) {
        
        let fh:FileHandle = notif.object as! FileHandle
        
        let data = fh.availableData
        if data.count > 1 {
            let string =  String(data: data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
            
            switch comandType {
//            case .netStat:
//                conectionsResult.append(string!)
            case .fireWallState:
//                  DispatchQueue.main.sync {
                    self.stateResult = string!
//                  }
                
                //            case .addFireWallBadHosts:
                //                run(comand:AddFireWallBadHosts(withIp:ip))
                //            case .deleteFireWallBadHosts:
                //                run(comand:DeleteFireWallBadHosts(withIp:ip))
                //            case .fireWallStop:
                //                run(comand:FireWallStop())
                //            case .fireWallStart:
                //                run(comand:FireWallStart())
                //            case .fireWallBadHosts:
            //                run(comand:FireWallBadHosts())
            default:
                conectionsResult.append(string!)
            }
            
            //            conectionsResult.append(string!)
            //            print(arrayResult)
            fh.waitForDataInBackgroundAndNotify()
        }
    }
    
    
    
    
    
}













