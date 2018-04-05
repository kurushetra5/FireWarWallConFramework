//
//  ViewController.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Cocoa



class ViewController: NSViewController , NSTableViewDelegate,NSTableViewDataSource,AliveConectionsDelegate  {
    
    
    var appController:AppController = AppController.shared
    
    
    //MARK: -------- @@IBOutlet  ---------------
   @IBOutlet weak var netstatTableView: NSTableView!
 
 
    
    
  //MARK: -------- @IBAction  ---------------
    @IBAction func  blockIp(_ sender: NSButton) {
        if selectedIP != nil {
             appController.block(ip:selectedIP)
        }
    }
    
    
    
    //MARK: -------- Class VARS  ---------------
 
    var aliveConections:[ConectionNode] = []
    private var selectedIP:ConectionNode!
    
    
    
    
    
    //MARK: -------- Life Circle  ---------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        
        
    }
    
    override func viewDidAppear() {
         super.viewDidAppear()
        appController.showConections()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
         appController.showConectionsOff()
    }
 
    
      //MARK: -------- Configuration  ---------------
    func setUpDelegates() {
         appController.appAlivedelegate = self
    }
    
    
    
    
    
    
    
    //MARK: --------  AppController Delegate  ---------------
    
    func alive(conections:ConectionNode) {
        
        if !aliveConections.contains(conections) {
            aliveConections.append(conections)
//            print(conections.ip ?? "empty ip")
            netstatTableView.reloadData()
        }
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
                cellIdentifier = "ipNumber"
                text = aliveConections[row].destination!
            }
            if tableColumn == netstatTableView.tableColumns[1] {
                cellIdentifier = "ipCountry"
                text = aliveConections[row].country!
            }
            if tableColumn == netstatTableView.tableColumns[2] {
                cellIdentifier = "ipCity"
                text = aliveConections[row].city!
            }
            if tableColumn == netstatTableView.tableColumns[3] {
                cellIdentifier = "ipOrg"
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
    
    
    
    
    func tableViewSelectionDidChange(_ notification: Notification) { //FIXME: peta al seleccionar nada
        selectedIP = aliveConections[netstatTableView.selectedRow]
         print(selectedIP.city ?? "nada")
    }
    
    
}

