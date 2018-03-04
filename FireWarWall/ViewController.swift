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
//        appController.fireWall.showConections()
        if sender.state == .off {
            appController.fireWall.start()
//            startStopButton.title = "STOP FIREWALL"
        }else {
            appController.fireWall.stop()
//            startStopButton.title = "START FIREWALL"
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

    
    override func viewDidAppear() {
         super.viewDidAppear()
//        appController.fireWall.showConections()
//         appController.fireWall.state()
    }

    
    
    
    
    
     //MARK: --------  AppController Delegate  ---------------
    func alive(conections:ConectionNode) {
//        DispatchQueue.main.sync {
//         print("alive  running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
            self.aliveConections.append(conections)
            print(conections.ip ?? "empty ip")
            self.netstatTableView.reloadData()
//        }
        
        
       
    }
    
    
    func blocked(ips:[ConectionNode]) {
        blockedIps = ips
        fireWallTableView.reloadData()
    }
    
    func fireWall(state:Bool) {
         print("fireWall(state running on = \(Thread.isMainThread ? "Main Thread":"Background Thread")")
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

