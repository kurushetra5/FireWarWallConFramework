//
//  Comands.swift
//  FireWarWall
//
//  Created by Kurushetra on 12/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




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


//protocol ProcessDelegate {
//    func procesFinish(processName:String)
//    func newDataFromProcess(data:String , processName:String)
//}


struct NetStatConection  {
    
    var ipLocation:IPLocation!
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
