//
//  InfoVC.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Cocoa




class InfoVC: NSViewController,InfoComandsDelegate {
    
    
    @IBOutlet var infoTextView: NSTextView!
    
    
    
    
    @IBAction func runComandAction(_ sender: NSButton) {
        
        switch  sender.tag {
        case 0:
            print("Whois")
            appController.runInfo(comand:"whois", args:"5.205.181.4")
        case 1:
            print("NSLookUP")
            appController.runInfo(comand:"nsLookup", args:"5.205.181.4")
        case 2:
            print("Dig")
            appController.runInfo(comand:"dig", args:"5.205.181.4")
        case 3:
            print("TraceRoute")
            appController.runInfo(comand:"traceRoute", args:"5.205.181.4")
        case 4:
            print("Ping")
            appController.runInfo(comand:"generic", args:"5.205.181.4")
        case 5:
            print("Ports/Services")
            appController.runInfo(comand:"ports_Services", args:"5.205.181.4")
        case 6:
            print("ConectionData")
            appController.runInfo(comand:"conectionData", args:"5.205.181.4")
        case 7:
            print("History")
            appController.runInfo(comand:"history", args:"5.205.181.4")
        default:
                print("default")
        }
        
    }
    
    
    
    
    //MARK: -------- Class VARS  ---------------
    var appController:AppController = AppController.shared
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        
    }
    
    
    
    //MARK: -------- Configuration  ---------------
    func setUpDelegates() {
        appController.infoComandsDelegate = self
    }
    
    
    
    
    
    
    //MARK: -------- Comands Delegate  ---------------
    func comandFinishWith(data:String) {
        infoTextView.string = data
    }
}
