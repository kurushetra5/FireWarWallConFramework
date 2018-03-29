//
//  praserManager.swift
//  FireWarWall
//
//  Created by Kurushetra on 8/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol  PraserManagerDelegate  {
    func prased(data:Any,fromComand:ComandType)
}



class  praserManager {
    
    
    private var ipsManager:IpsManager = IpsManager()
    public var praserManagerDelegate:PraserManagerDelegate!
    
    
    
    
    
    func parseComand(result:String)  {
        
//        print(result)
        
//        if result.contains("Status") {
//            if result.contains("Disabled") {
////                fireWallDelegate?.fireWall(state:false)
//                praserManagerDelegate?.prased(data:false, fromComand:.fireWallState)
//
//            }else if result.contains("Enabled"){
////                fireWallDelegate?.fireWall(state:true)
//               praserManagerDelegate?.prased(data:true, fromComand:.fireWallState)
//            }
////            return
//        }
//        else
        if result.contains("tcp4") {
            let conections =   ipsManager.findNetStatIps(inText: result)
            praserManagerDelegate?.prased(data:conections, fromComand:.netStat)
//            fireWallDelegate?.fireWallEstablished(ips:conections)
//           return
        }
//        else if result.contains("Server:") {
//            praserManagerDelegate?.prased(data:result, fromComand:.nsLookup)
////            return
//        }
//        else   { //FIXME: no esta acabado todavia ????
//
////            let badHosts =   ipsManager.findBlockedIps(inText: result)
////            praserManagerDelegate?.prased(data:badHosts, fromComand:.fireWallBadHosts)
////            return
////                       print("nanda")
//            //            fireWallDelegate?.fireWallBlocked(ips:badHosts) //TODO: crear varios delegates
//        }
     }
    
    
    
    
}
