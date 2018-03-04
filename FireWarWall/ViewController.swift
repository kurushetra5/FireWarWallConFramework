//
//  ViewController.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Cocoa

class ViewController: NSViewController , NSTableViewDelegate,NSTableViewDataSource,AppControllerDelegate  {
    
    //MARK: -------- @@IBOutlet  ---------------
    @IBOutlet weak var blockOrUnblockButton: NSButton!
    @IBOutlet weak var blockipText: NSTextField!
    @IBOutlet weak var fireWallTableView: NSTableView!
    @IBOutlet weak var netstatTableView: NSTableView!
    @IBOutlet weak var fireWallStateImage: NSTextField!
    @IBOutlet weak var startStopButton: NSButton!
    
    
    //MARK: -------- @IBAction  ---------------
    
    @IBAction func startOrStopFirewall(_ sender: NSButton) {
        
        if sender.state == .off {
            appController.fireWall.start()
            
        }else {
            appController.fireWall.stop()
            
        }
    }
    
    
    @IBAction func blockOrUnblockIp(_ sender: NSButton) {
        appController.fireWall.block(ip:"12.23.23.2")
    }
    
    
    
    
    
    //MARK: -------- Class VARS  ---------------
    var appController:AppController = AppController()
    var aliveConections:[ConectionNode] = []
    var blockedIps:[ConectionNode] = []
    
    
    
    
    //MARK: -------- Life Circle  ---------------
    override func viewDidLoad() {
        super.viewDidLoad()
        appController.delegate = self
        appController.fireWall.showConections()
        
    }
    
    
//    override func viewDidAppear() {
//        super.viewDidAppear()
//
//    }
    
    
    
    
    
    
    //MARK: --------  AppController Delegate  ---------------
    func alive(conections:ConectionNode) {
        
        if !aliveConections.contains(conections) {
            aliveConections.append(conections)
//            print(conections.ip ?? "empty ip")
            netstatTableView.reloadData()
        }
    }
    
    
    
    
    func blocked(ips:[ConectionNode]) {
        blockedIps = ips
        fireWallTableView.reloadData()
    }
    
    func fireWall(state:Bool) {
//        print("fireWall(state running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
        if state == true {
            fireWallStateImage.backgroundColor = .green
            startStopButton.title = "STOP FIREWALL"
            //
        }else {
            fireWallStateImage.backgroundColor = .red
            startStopButton.title = "START FIREWALL"
            //
        }
        //         appController.fireWall.showConections()
    }
    
    
    
    
    
    
    //MARK:---------------------- TABLE_VIEW Delegate --------------------
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return aliveConections.count
    }
    
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var cellIdentifier: String = ""
        var text: String = "-"
        
        
        if tableView.identifier!.rawValue == "netstat" {
            
            if tableColumn == netstatTableView.tableColumns[0] {
                cellIdentifier = "conectionIp"
                text = aliveConections[row].destination!
            }
            if tableColumn == netstatTableView.tableColumns[1] {
                cellIdentifier = "ipLocation"
                text = aliveConections[row].adress!
            }
            
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
            cell?.textField?.stringValue = text
            return cell
        }
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView
        cell?.textField?.stringValue = text
        return cell
    }
    
    
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
    }
}

