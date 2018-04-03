//
//  FireWallVC.swift
//  FireWarWall
//
//  Created by Kurushetra on 6/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Cocoa



class FireWallVC: NSViewController , NSTableViewDelegate,NSTableViewDataSource , FireWallDelegateState,FireWallDelegateBlocked {
    
    
    
    @IBOutlet weak var background: NSTextField!
    @IBOutlet weak var fireWallTableView: NSTableView!
    @IBOutlet weak var startStopButton: NSButton!
    
    
    
    
    
    
    //MARK: -------- @IBAction  ---------------
    
    @IBAction func startOrStopFirewall(_ sender: NSButton) {
        
        if sender.state == .off {
             appController.startFireWall()
            
        }else {
             appController.stopFireWall()
            
        }
    }
    
    @IBAction func unblockIp(_ sender: NSButton) {
           appController.unblock(ip:selectedIP)
       
    }
    
    
    
    
    
    
    //MARK: -------- Class VARS  ---------------
    var appController:AppController = AppController.shared
    var blockedConections:[ConectionNode] = []
    private var selectedIP:ConectionNode!
    
    
    
    
    //MARK: -------- Life Circle  ---------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        
        
        
    }
    
    override func viewDidAppear() {
         super.viewDidAppear()
        appController.fireWallState()
//        appController.showBlockedIpsOn()
    }
    
    override func viewWillDisappear() {
         super.viewWillDisappear()
          appController.fireWallStateOff()
          appController.showBlockedIpsOff()
    }
    
    
    
    
    //MARK: -------- Configuration  ---------------
    func setUpDelegates() {
          appController.fireWallDelegateState = self
         appController.fireWallDelegateBlocked = self
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: -------- APPFireWall Delegates   ---------------
    
    func blocked(ips:[ConectionNode]!) {
        
        if ips == nil {
           blockedConections =  []
        } else {
          blockedConections = ips
        }
        
        
//         if blockedConections != ips {
//           print("No Equals..")
//            blockedConections = ips
            fireWallTableView.reloadData()
//        }
    }
    
    
    func fireWall(state:Bool) {
        
        if state == true {
            
            background.backgroundColor = .green
            startStopButton.title = "STOP"
            
        }else {
            background.backgroundColor = .red
            startStopButton.title = "START"
          
        }
//        appController.showBlockedIpsOn()
 
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: -------- TABLEVIEW DELEGATE  ---------------
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return blockedConections.count
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellIdentifier: String = ""
        var text: String = "-"
        
        if tableColumn == fireWallTableView.tableColumns[0] {
            cellIdentifier = "ipNumber"
            text = blockedConections[row].destination!
        }
        if tableColumn == fireWallTableView.tableColumns[1] {
            cellIdentifier = "ipCountry"
            text = blockedConections[row].country!
        }
        if tableColumn == fireWallTableView.tableColumns[2] {
            cellIdentifier = "ipCity"
            text = blockedConections[row].city!
        }
        if tableColumn == fireWallTableView.tableColumns[3] {
            cellIdentifier = "ipOrg"
            text = blockedConections[row].adress!
        }
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
        cell?.textField?.stringValue = text
        return cell
        
    }
    
    
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        selectedIP = blockedConections[fireWallTableView.selectedRow] //FIXME: falla al seleccionas nada.
//        print(selectedIP.city ?? "nada")
    }
    
}
