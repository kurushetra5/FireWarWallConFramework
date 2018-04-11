//
//  KUNetComands.swift
//  FireWarWall
//
//  Created by Kurushetra on 5/4/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation
import KUTaskFramework




//MARK: -------------------------------- NETCOMANDS --------------------------------
public struct KUNetStat:Comand   {
    public var praser: Prasable
    
    
    public var name: String
//    public var prasers: Prasables
    //   public var type: ComandType = .netStat
    public var taskPath:String =  "/bin/sh"
    public var taskArgs:[String] = ["-c" , "netstat -an  | grep ESTABLISHED"]
    
    public init(praser: Prasable, name:String) {
        self.name = name
        self.praser = praser
    }
}



struct KUPingListenerPraser:Prasable   {
    
    
    
    
    public func prase(comandResult:[String]) -> Any {
        
        let newData:[String] = comandResult
        var nsMutableDict:NSMutableDictionary!
        var dict:Dictionary<String,String> = [:]
        var finalDictsList:[Dictionary<String,String>] = []
        
 
//        //var line = "01:19:30.138209 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto ICMP (1), length 84, bad cksum 0 (->b48e)!)"
//        // 192.168.2.100 > 192.168.2.102: ICMP echo reply, id 4809, seq 1, length 64
// 18:29:43.109510 IP (tos 0x0, ttl 64, id 37599, offset 0, flags [none], proto ICMP (1), length 84)
        
        for line in newData {
            nsMutableDict  = NSMutableDictionary()
            
            if !line.contains("cksum") && !line.contains("reply") {
                
             var array = line.components(separatedBy:" ")
//             print(array.count)
            
            
                if array.count ==  17 { //FIXME: poner datos en un solo no con dos lineas
//                print(line)
                //la linea es la 1
                array[5].removeLast()
                array[11].removeFirst()
                array[11].removeLast(2)
                array[16].removeLast()
                
                
                nsMutableDict.setValue("firstLinePing", forKey:"lineType")
                nsMutableDict.setValue(array[5],  forKey:"ttl")
                nsMutableDict.setValue(array[11], forKey:"flag")
                nsMutableDict.setValue(array[16], forKey:"lenght")
                dict = nsMutableDict as! Dictionary<String, String>
                finalDictsList.append(dict)

            } else if array.count == 16 {
                //la linea es la 1
                array[11].removeLast()
                array[13].removeLast()
                
                nsMutableDict.setValue("secondLinePing", forKey:"lineType")
                nsMutableDict.setValue(array[11], forKey:"id")
                nsMutableDict.setValue(array[13], forKey:"seq")
                nsMutableDict.setValue(array[15], forKey:"lenght2")
                dict = nsMutableDict as! Dictionary<String, String>
                finalDictsList.append(dict)
            } else {
//                print("//_-_-_-_-_-_-_ LINEA PERDIDA _-_-_-_-_-_-_-_-_-_-_")
//                print(line)
//                print(array.count)
            }
             
           
         }
        }
        
        return finalDictsList
    }
    
}


struct  KUPingListener:Comand    {
    
    var praser: Prasable = KUPingListenerPraser()
    var taskPath: String = "/bin/sh"
//    ("echo nomeacuerdo87378737 | sudo -S tcpdump -nnv -i en0 icmp  > ping7.txt &") /Users/kurushetra/Desktop/
    var taskArgs: [String] =  ["-c" , "echo yameacuerdo8737 | sudo -S tcpdump  -i en4  > /Users/kurushetra/Desktop/ping.txt"]  //TODO: puede que el comando se pueda correr sin sudo..
    var name: String = "fromFileContinously"
}






struct KUTcpDumpCom:ComandWithIP {
    
    
    var praser: Prasable
    
    
    var name: String
    //    var type: ComandType = .tcpDump
    var taskPath:String =  "/usr/sbin/tcpdump"
    var taskArgs:[String] = ["-i","en4","-n" ," not (src net 192.168.8.1 and dst net 192.168.8.100) and not  (src net 192.168.8.100 and dst net 192.168.8.1) and not (src net 192.168.8.1 and dst net 239.255.255.250)"]
    var ip:String = ""
//    var prasers: Prasables
    
    init(withIp: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        
    }
    
    mutating func block(ip:String) {
        let notIpArgs:String = "and not (src net " + ip + " and dst net " + ip + ")"
        self.taskArgs.append(notIpArgs)
    }
}






struct KUTraceRoute:ComandWithIP {
    var praser: Prasable
    
    
    var name: String
//    var prasers: Prasables
    //    var type: ComandType = .traceRoute
    var ip:String = ""
    var taskPath:String =  "/usr/sbin/traceroute"
    var taskArgs:[String] = ["-w 1" , "-m30", "???"]
    
    
    init(withIp: String, name:String, praser: Prasable ) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    
    mutating func addIp() {
        self.taskArgs[2] = self.ip
    }
}




public struct KUNsLookup:ComandWithIP {
    public var praser: Prasable
    
    
    public var name: String
//    public var prasers: Prasables
    //    public var type: ComandType = .nsLookup
    public  var ip:String = ""
    public var taskPath:String =  "/usr/bin/nslookup"
    public var taskArgs:[String] = []
    
    
    public init(withIp: String, name:String,  praser: Prasable) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    mutating public func addIp() {
        self.taskArgs = [self.ip]
    }
}



struct KUWhois:ComandWithIP {
    
    var name: String
    var praser: Prasable
    //    var type: ComandType = .whois
    var ip:String = ""
    var taskPath:String =  "/usr/bin/whois"
    var taskArgs:[String] = []
    
    
    init(withIp: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        addIp()
    }
    mutating func addIp() {
        self.taskArgs = [self.ip]
    }
}



struct KUMtRoute:ComandIpId {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
    //    var type: ComandType = .mtRoute
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S  ./mtr -rw -n ??? | awk '{print $2}'"] //FIXME: ruta de mtr no es esta
    
    init(withId: String, withIp: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        self.Id = withId
        addIPAndID()
    }
    
    
    
}
