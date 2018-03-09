//
//  ComandsManager.swift
//  FireWarWall
//
//  Created by Kurushetra on 9/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol ComandsManagerConectionsDelegate {
     func established(conections:[NetStatConection])
}

protocol ComandsManagerFireWallStateDelegate {
    func fireWall(state:Bool)
}

protocol ComandsManagerFireWallBlockedDelegate {
    func fireWall(blocked:[NetStatConection])
}


protocol ComandsManagerDelegate:ComandsManagerConectionsDelegate,ComandsManagerFireWallStateDelegate,ComandsManagerFireWallBlockedDelegate {
    
}



class ComandsManager:ComandRunerDelegate ,PraserManagerDelegate {
    
    
    private var parser:praserManager = praserManager()
    private var comandRuner:ComandRuner = ComandRuner()
    var  fireWall:FireWall = FireWall()
    
    
    /// delegates Objects
    public var comandsManagerDelegate:ComandsManagerDelegate!
    public var conectionsDelegate:ComandsManagerConectionsDelegate!
    public var fireWallStateDelegate:ComandsManagerFireWallStateDelegate!
    public var fireWallBlockedDelegate:ComandsManagerFireWallBlockedDelegate!
    
    
    
    
    init() {
        setUpDelegates()
    }
    
    
    
    
    
    //MARK: -------- Configuration  ---------------
    func setUpDelegates() {
        comandRuner.comandRunerDelegate = self
        fireWall.comandRuner.comandRunerDelegate = self
        parser.praserManagerDelegate = self
    }
    
    
    
    
    
    
    //MARK: -------- Public FIREWALL  func ---------------
    
    /// -------------  Conections -------------
    public func showConections()  {
        fireWall.showConections()
    }
    
    public func showConectionsOff()  {
        fireWall.showConectionsOff()
    }
    
    
    
    /// ---------  FireWall -------------
    public func  fireWallState() {
        fireWall.state()
    }
    public func  fireWallStateOff() {
        fireWall.stateOff()
    }
    
    public func  startFireWall() {
        fireWall.start()
    }
    
    public func  stopFireWall() {
        fireWall.stop()
    }
    
    func showBlockedIpsOn() {
        fireWall.showBlockedIpsOn()
    }
    func showBlockedIpsOff() {
        fireWall.showBlockedIpsOff()
    }
    
    public func block(ip:ConectionNode) {
        fireWall.block(ip: ip.ip!)
    }
    public func unblock(ip:ConectionNode) {
        fireWall.unBlock(ip:ip.ip!)
    }
    
    
    
    
    
    //MARK: ------------- ComandRuner Delegates ------------
    
    func comand(finishWith data:String) {
        parser.parseComand(result: data)
    }
    
    
    
    
    //MARK: -------------  Prasers Delegates ------------
    func prased(data:Any,fromComand:ComandType) {
        
        switch  fromComand {
        case .netStat:
            print("netsat")
            let conections:[NetStatConection] = (data as? [NetStatConection])!
            comandsManagerDelegate?.established(conections:conections)
        case .fireWallState:
            print("fireWallState")
            let state:Bool =  (data as? Bool)!
            comandsManagerDelegate?.fireWall(state:state)
        case .fireWallBadHosts:
            print("fireWallBadHosts")
            let blocked:[NetStatConection] = (data as? [NetStatConection])!
            comandsManagerDelegate?.fireWall(blocked: blocked)
        default:
            print("netsat")
        }
    }
    
    
    
    
    
 
    
    
    
    
    
    
    
    
}

