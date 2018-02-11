//
//  ViewController.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Cocoa

class ViewController: NSViewController , NSTableViewDelegate,NSTableViewDataSource,ProcessDelegate {

    
    
    @IBAction func startOrStopFirewall(_ sender: NSButton) {
        
        if sender.state == .off {
            fireWall.runComand(type: .fireWallStart, ip: nil, delegate:self)
            startStopButton.title = "STOP FIREWALL"
        }else {
            fireWall.runComand(type: .fireWallStop, ip: nil, delegate:self)
            startStopButton.title = "START FIREWALL"
        }
    }
    
    
    @IBAction func blockOrUnblockIp(_ sender: NSButton) {
        fireWall.runComand(type: .addFireWallBadHosts, ip: nil, delegate:self)
    }
    
    
    
    @IBOutlet weak var blockOrUnblockButton: NSButton!
    @IBOutlet weak var blockipText: NSTextField!
    @IBOutlet weak var fireWallTableView: NSTableView!
    @IBOutlet weak var netstatTableView: NSTableView!
    @IBOutlet weak var fireWallStateImage: NSTextField!
    @IBOutlet weak var startStopButton: NSButton!
    
    
    var fireWall:FireWall = FireWall()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         fireWall.runComand(type:ComandType.fireWallState, ip: nil, delegate:self)
         fireWall.runComand(type:.netStat, ip: nil, delegate:self)
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    
    
   
    func procesFinish(processName:String) {
        
        switch processName {
        case ComandType.fireWallStart.rawValue:
             fireWall.runComand(type:ComandType.fireWallState, ip: nil, delegate:self)
            
        case ComandType.fireWallStop.rawValue:
            fireWall.runComand(type:ComandType.fireWallState, ip: nil, delegate:self)
            
//        case ComandType.addFireWallBadHosts.rawValue:
//            blockedNodes = []
//            updateBadHostsTableView()
            
//        case ComandType.deleteFireWallBadHosts.rawValue:
//            blockedNodes = []
//            updateBadHostsTableView()
        default:
            print("Error: procesFinish(processName:String)")
        }    }
    
    
    func newDataFromProcess(data:String , processName:String) {
        
        switch processName {
        case ComandType.fireWallState.rawValue:
            if data.contains("Enabled") {
                fireWallStateImage.backgroundColor = .green
                 startStopButton.title = "STOP FIREWALL"
//
            }else {
                fireWallStateImage.backgroundColor = .red
                startStopButton.title = "START FIREWALL"
//
            }
//            updateBadHostsTableView()
            
//        case ComandType.fireWallBadHosts.rawValue:
            //blockedNodes = []
//            fireWallTableView.reloadData()
        default:
            print("Error: newDataFromProcess(data:String , processName:String)")
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

