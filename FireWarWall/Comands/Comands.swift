//
//  Comands.swift
//  FireWarWall
//
//  Created by Kurushetra on 12/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




enum ComandType:String {
    case tcpDump,traceRoute,mtRoute,whois,nsLookup,blockIp,netStat,fireWallState,fireWallBadHosts,addFireWallBadHosts,deleteFireWallBadHosts,fireWallStop,fireWallStart,genericComand,dig,history,ports_Services,ping,conectionData,generic
}

protocol Comand  {
    var taskPath:String{get set}
    var taskArgs:[String]{get set}
    var type:ComandType{get set}
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



//MARK: -------------------------------- AppTaskComand --------------------------------
protocol comandDelegate   {
    func  comand(finish:ComandType,result:Any)
}



class  AppTaskComand:ShellComandDelegate  {
    
    var delegate: comandDelegate!
    private var comand:Comand!
    private var shellComand:ShellComand!
    var praser:Prasable!
    
    
    init(comand:Comand, praser:Prasable, delegate:comandDelegate) {
        shellComand = ShellComand()
        self.comand = comand
        self.shellComand.shellComandDelegate = self
        self.shellComand.comandType = comand.type
        self.praser = praser
        self.delegate = delegate
    }
    
    public func run() {
//         self.shellComand = ShellComand()
//         self.shellComand.shellComandDelegate = self
//         self.shellComand.comandType = comand.type
        
        shellComand.run(comand:comand)
    }
    
    
}





//MARK: -------------------------------- GENERIC--------------------------------
struct genericComand:Comand  {
    var type: ComandType = .generic
    var taskPath:String =  ""
    var taskArgs:[String] = []
    
}



//MARK: -------------------------------- CONECTIONS --------------------------------
struct NetStat:Comand  {
    var type: ComandType = .netStat
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "netstat -an  | grep ESTABLISHED"]
    
}





//MARK: -------------------------------- INFO COMANDS --------------------------------
struct TcpDumpCom:Comand {
    var type: ComandType = .tcpDump
    
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
    var type: ComandType = .traceRoute
    
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
    var type: ComandType = .nsLookup
    
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
    var type: ComandType = .whois
    
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
    var type: ComandType = .mtRoute
    
    
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
    var type: ComandType = .fireWallStart
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S pfctl -e -f  /etc/pf.conf"]
    
}

struct FireWallStop:Comand  {
    var type: ComandType = .fireWallStop
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S  pfctl -d"]
    
}


class FireWallState:Comand  {
    var type: ComandType = .fireWallState
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S pfctl  -s info | grep Status"]
    
}


struct FireWallBadHosts:Comand  {
    var type: ComandType = .fireWallBadHosts
    
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo nomeacuerdo87378737 | sudo -S pfctl -t badhosts -T show"]
    
}


struct AddFireWallBadHosts:ComandIp  {
    var type: ComandType = .addFireWallBadHosts
    
    
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
    var type: ComandType = .deleteFireWallBadHosts
    
    
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
