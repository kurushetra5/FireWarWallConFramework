//
//  praserManager.swift
//  FireWarWall
//
//  Created by Kurushetra on 8/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


class  praserManager {
    
    
    private var ipsManager:IpsManager = IpsManager()
    
    
    
    
    
    func parseComand(result:String ,completion:(ComandType,Any) -> Void)  {
        
        if result.contains("Status") {
            if result.contains("Disabled") {
//                fireWallDelegate?.fireWall(state:false)
                completion(.fireWallState,false)
            }else if result.contains("Enabled"){
//                fireWallDelegate?.fireWall(state:true)
                completion(.fireWallState,true)
            }
        }
        else if result.contains("tcp4") {
            let conections =   ipsManager.findNetStatIps(inText: result)
//            fireWallDelegate?.fireWallEstablished(ips:conections)
            completion(.netStat,conections)
        }
        else   {
            let badHosts =   ipsManager.findBlockedIps(inText: result)
            completion(.fireWallBadHosts,badHosts)
            //            print(badHosts)
            //            fireWallDelegate?.fireWallBlocked(ips:badHosts) //TODO: crear varios delegates
        }
        
    }
    
    
    
    
}
