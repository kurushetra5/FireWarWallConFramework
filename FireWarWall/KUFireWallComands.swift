//
//  KUFireWallComands.swift
//  FireWarWall
//
//  Created by Kurushetra on 6/4/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation
import KUTaskFramework





//MARK: -------------------------------- FIREWALL --------------------------------
struct KUFireWallStart:ComandWithID  {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
    //    var type: ComandType = .fireWallStart
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl -e -f  /etc/pf.conf"]
    
    init(withId: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.Id = withId
        addId()
    }
    
}


struct KUFireWallStop:ComandWithID  {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
    //    var type: ComandType = .fireWallStop
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S  pfctl -d"]
    
    init(withId: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.Id = withId
        addId()
    }
    
}



public struct KUFireWallState:ComandWithID  {
    
    public var name: String
    public var praser: Prasable
    public var Id: String = ""
    //    var type: ComandType = .fireWallState
    public var taskPath:String =  "/bin/sh"
    public var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -s info | grep Status"]
    
    public init(withId: String, name:String, praser: Prasable) {
        self.name = name
        //        self.type = .fireWallState
        self.praser = praser
        self.Id = withId
        addId()
    }
    
}



struct KUFireWallBadHosts:ComandWithID  {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
    //    var type: ComandType = .fireWallBadHosts
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl -t badhosts -T show"]
    
    init(withId: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.Id = withId
        addId()
    }
}


struct KUAddFireWallBadHosts:ComandIpId   {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
    //    var type: ComandType = .addFireWallBadHosts
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -t badhosts -T add ???"]
    
    init(withId: String, withIp: String, name:String, praser: Prasable) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        self.Id = withId
        addIPAndID()
    }
}



struct KUDeleteFireWallBadHosts:ComandIpId  {
    
    var name: String
    var praser: Prasable
    var Id: String = ""
    //    var type: ComandType = .deleteFireWallBadHosts
    var ip:String = ""
    var taskPath:String =  "/bin/sh"
    var taskArgs:[String] = ["-c" , "echo ¿¿¿ | sudo -S pfctl  -t badhosts -T delete ???"]
    
    
    init(withId: String, withIp: String, name:String,  praser: Prasable) {
        self.name = name
        self.praser = praser
        self.ip = withIp
        self.Id = withId
        addIPAndID()
    }
    
}
