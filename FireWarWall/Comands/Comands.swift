//
//  Comands.swift
//  FireWarWall
//
//  Created by Kurushetra on 12/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




enum ComandType:String {
    case tcpDump,traceRoute,mtRoute,whois,nsLookup,blockIp,netStat,fireWallState,fireWallBadHosts,addFireWallBadHosts,deleteFireWallBadHosts,fireWallStop,fireWallStart,genericComand,dig,history,ports_Services,ping,conectionData
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





struct NetStatConection  {
    
    var ipLocation:IPLocation!
    var sourceIp:String = ""
    var destinationIp:String = ""
    
}


//MARK: -------------------------------- GENERIC--------------------------------
struct genericComand:Comand  {
    var taskPath:String =  ""
    var taskArgs:[String] = []
    
}



//MARK: -------------------------------- CONECTIONS --------------------------------
struct NetStat:Comand  {
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "netstat -an  | grep ESTABLISHED"]
    
}





//MARK: -------------------------------- INFO COMANDS --------------------------------
struct TcpDumpCom:Comand {
    var ip:String = ""
    var taskPath:String =  "/usr/sbin/tcpdump"
    var taskArgs:[String] = ["-i","en4","-n" ," not (src net 192.168.8.1 and dst net 192.168.8.100) and not  (src net 192.168.8.100 and dst net 192.168.8.1) and not (src net 192.168.8.1 and dst net 239.255.255.250)"]
    //    var fileUrl:URL = URL(fileURLWithPath:"/Users/kurushetra/Desktop/traceRoute.txt")
    
    mutating func block(ip:String) {
        let notIpArgs:String = "and not (src net " + ip + " and dst net " + ip + ")"
        self.taskArgs.append(notIpArgs)
    }
}



struct TraceRoute:ComandIp {
    var ip:String = ""
    var taskPath:String =  "/usr/sbin/traceroute"
    var taskArgs:[String] = ["-w 1" , "-m30" ,"www.google.com"]
    //    var fileUrl:URL = URL(fileURLWithPath:"/Users/kurushetra/Desktop/traceRoute.txt")
    
    init(withIp:String) {
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        self.taskArgs[2] = self.ip
    }
}


struct NsLookup:ComandIp {
    var ip:String = ""
    var taskPath:String =  "/usr/bin/nslookup"
    var taskArgs:[String] = []
    //    var fileUrl:URL = URL(fileURLWithPath:"/Users/kurushetra/Desktop/traceRoute.txt")
    
    init(withIp:String) {
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        self.taskArgs = [self.ip]
    }
}


struct Whois:ComandIp {
    var ip:String = ""
    var taskPath:String =  "/usr/sbin/traceroute"
    var taskArgs:[String] = []
    //    var fileUrl:URL = URL(fileURLWithPath:"/Users/kurushetra/Desktop/traceRoute.txt")
    
    init(withIp:String) {
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        self.taskArgs = [self.ip]
    }
}


struct MtRoute:ComandIp {
    
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo8737 | sudo -S  ./mtr -rw -n ??? | awk '{print $2}'"]
    //    var fileUrl:URL = URL(fileURLWithPath:"/Users/kurushetra/Desktop/traceRoute.txt")
    
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




//MARK: -------------------------------- FIREWALL --------------------------------
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
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S pfctl -t badhosts -T show"]
    
}


struct AddFireWallBadHosts:ComandIp  {
    
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S pfctl  -t badhosts -T add ???"]
    
    
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
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S pfctl  -t badhosts -T delete ???"]
    
    
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
