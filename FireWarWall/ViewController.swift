//
//  ViewController.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Cocoa

class ViewController: NSViewController , NSTableViewDelegate,NSTableViewDataSource,AppControllerDelegate  {

    
    @IBOutlet weak var blockOrUnblockButton: NSButton!
    @IBOutlet weak var blockipText: NSTextField!
    @IBOutlet weak var fireWallTableView: NSTableView!
    @IBOutlet weak var netstatTableView: NSTableView!
    @IBOutlet weak var fireWallStateImage: NSTextField!
    @IBOutlet weak var startStopButton: NSButton!
    
    
    
    @IBAction func startOrStopFirewall(_ sender: NSButton) {
        appController.fireWall.showConections()
//        if sender.state == .off {
//            appController.fireWall.start()
//            startStopButton.title = "STOP FIREWALL"
//        }else {
//            appController.fireWall.stop()
//            startStopButton.title = "START FIREWALL"
//        }
    }
    
    
    @IBAction func blockOrUnblockIp(_ sender: NSButton) {
        appController.fireWall.block(ip:"12.23.23.2")
    }
    
    
    
    
    
 
    var appController:AppController = AppController.shared
    var aliveConections:[ConectionNode] = []
    var blockedIps:[ConectionNode] = []
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appController.delegate = self
        appController.fireWall.showConections()
    }

    
 

    
    
    
    
    
    
    func alive(conections:ConectionNode) {
        aliveConections.append(conections)
        print(conections.ip)
        netstatTableView.reloadData()
    }
    
    func blocked(ips:[ConectionNode]) {
        blockedIps = ips
        fireWallTableView.reloadData()
    }
    
    func fireWall(state:Bool) {
        
        if state == true {
            fireWallStateImage.backgroundColor = .green
            startStopButton.title = "STOP FIREWALL"
            //
        }else {
            fireWallStateImage.backgroundColor = .red
            startStopButton.title = "START FIREWALL"
            //
        }
    }
   
    
    
    
    
    
    
    
    
    
    
    
 
    
    
    
    
    
    
    
    
    
    
    
 //MARK:---------------------- TABLE_VIEW Delegate --------------------
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return 1
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellIdentifier: String = ""
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
        
        if tableView.identifier!.rawValue == "fireWall" {
            
            if tableColumn == fireWallTableView.tableColumns[0] {
                cellIdentifier = "IpBlocked"
//                text = ip.number!
            }
            
            return cell
        }
        return cell
    }
    
    
    
    
     func tableViewSelectionDidChange(_ notification: Notification) {
        
    }
}

