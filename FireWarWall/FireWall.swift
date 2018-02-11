//
//  FireWall.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




class FireWall  {
    
    
    var ipsManager:IpsManager = IpsManager()
    let filesManager:FilesManager = FilesManager.shared
    var comandType:ComandType!
    var arrayResult:[String] = []
    var processDelegate:ProcessDelegate!
    
    var filemgr: FileManager!{
        return FileManager.default
    }
    
    
    func runComand(type:ComandType, ip:String!, delegate:ProcessDelegate) {
        
        comandType = type
        arrayResult = []
        
        if type is ComandIp  {
            if ip == nil {
                print("runComand : Ip Es NILL")
                return
            }
        }
        
        switch type {
            
        case .netStat:
            run(comand:NetStat(), delegate:delegate)
        case .fireWallState:
            run(comand:FireWallState(), delegate:delegate)
        case .addFireWallBadHosts:
            run(comand:AddFireWallBadHosts(withIp:ip), delegate:delegate)
        case .deleteFireWallBadHosts:
            run(comand:DeleteFireWallBadHosts(withIp:ip), delegate:delegate)
        case .fireWallStop:
            run(comand:FireWallStop(), delegate:delegate)
        case .fireWallStart:
            run(comand:FireWallStart(), delegate:delegate)
        case .fireWallBadHosts:
            run(comand:FireWallBadHosts(), delegate:delegate)
        default:
            print("")
        }
        
        //startTimerEvery(seconds:0.5)
    }
    
    
    
    
    
    
    func run(comand:Comand, delegate:ProcessDelegate) {
        
        
//        filesManager.changeToWorkingPath(newPath:"/usr/local/sbin/") //FIXME: cambiarlo segun comando
        
        processDelegate = delegate
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
            print("acabado")
            self.processResults()
        }
        task.launch()
    }
    
    
    
    
    
    func  processResults()  {
        
        OperationQueue.main.addOperation({
            
            switch self.comandType {
             
            case  .fireWallState:
                if self.arrayResult.count >= 1 {
                    self.processDelegate.newDataFromProcess(data:self.arrayResult[0], processName:self.comandType!.rawValue)
                }
            case  .deleteFireWallBadHosts:
                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallStart:
                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallStop:
                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            case  .fireWallBadHosts:
                if self.arrayResult.count >= 1 {
                    let ips = self.ipsManager.findIpsIn(text:self.arrayResult[0])
                    for ip in ips! {
//                        self.dataBase.nodeWith(ip:ip, amountIps:ips!.count)
                    }
                    
                }else if self.arrayResult.count == 0 {
                    self.processDelegate.newDataFromProcess(data:"0", processName:self.comandType!.rawValue)
                }
            case .addFireWallBadHosts:
                self.processDelegate.procesFinish(processName:self.comandType!.rawValue)
            default:
                let ips = self.ipsManager.findNetStatIps(inText:self.arrayResult[0])
                
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
        })
        
    }
    
    
    
    
    @objc func receivedData(notif : NSNotification) {
        
        let fh:FileHandle = notif.object as! FileHandle
        
        let data = fh.availableData
        if data.count > 1 {
            
            
            
            let string =  String(data: data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
            arrayResult.append(string!)
            print(arrayResult)
            
            
            fh.waitForDataInBackgroundAndNotify()
        }
    }
    
    
    
    
//    func changeToWorkingPath(newPath:String) {
//
//        var path:String!
//
//        if FileManager.default.changeCurrentDirectoryPath(newPath) == true {
//            path =  FileManager.default.currentDirectoryPath
//            print(path);
//        } else {
//            print("No changed...");
//
//        }
//    }
//
//
//
//    func currentPath() -> String {
//        var path:String!
//        path =  FileManager.default.currentDirectoryPath
//        print("Current directory is", path);
//        return path
//
//    }
}









enum ComandType:String {
    case tcpDump,traceRoute,mtRoute,whois,nsLookup,blockIp,netStat,fireWallState,fireWallBadHosts,addFireWallBadHosts,deleteFireWallBadHosts,fireWallStop,fireWallStart
}

protocol Comand  {
    var taskPath:String{get set}
    var taskArgs:[String]{get set}
    
}

protocol ComandIp:Comand  {
    var ip:String{get set}
    init(withIp:String)
    mutating func addIp()
}


protocol ProcessDelegate {
    func procesFinish(processName:String)
    func newDataFromProcess(data:String , processName:String)
}


struct NetStatConection :Hashable {
    
    var hashValue: Int {
        return sourceIp.hashValue ^ destinationIp.hashValue &* 16777619
    }
    
    static func == (lhs: NetStatConection, rhs: NetStatConection) -> Bool {
        return lhs.sourceIp == rhs.sourceIp && lhs.destinationIp == rhs.destinationIp
    }
    var sourceIp:String = ""
    var destinationIp:String = ""
    
}



struct NetStat:Comand  {
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "netstat -an  | grep ESTABLISHED"]
    
}


struct FireWallStart:Comand  {
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S pfctl -e -f  /etc/pf.conf"]
    
}

struct FireWallStop:Comand  {
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S  pfctl -d"]
    
}


struct FireWallState:Comand  {
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S pfctl  -s info | grep Status"]
    
}


struct FireWallBadHosts:Comand  {
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo8737 | sudo -S pfctl -t badhosts -T show"]
    
}


struct AddFireWallBadHosts:ComandIp  {
    
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo8737 | sudo -S pfctl  -t badhosts -T add ???"]
    
    
    init(withIp:String) {
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        let comand:String = taskArgs[1]
        let comandWithIp:String = comand.replacingOccurrences(of:"???", with:self.ip)
        self.taskArgs[1] = comandWithIp
        
    }
}


struct DeleteFireWallBadHosts:ComandIp  {
    
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo8737 | sudo -S pfctl  -t badhosts -T delete ???"]
    
    
    init(withIp:String) {
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        let comand:String = taskArgs[1]
        let comandWithIp:String = comand.replacingOccurrences(of:"???", with:self.ip)
        self.taskArgs[1] = comandWithIp
        
    }
}

//extension DispatchQueue { //TODO: Cambiar de sitio
//
//    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
//        DispatchQueue.global(qos: .background).async {
//            background?()
//            if let completion = completion {
//                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
//                    completion()
//                })
//            }
//        }
//    }

//}

