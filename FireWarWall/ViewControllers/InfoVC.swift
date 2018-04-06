//
//  InfoVC.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Cocoa
import KUTaskFramework



class InfoVC: NSViewController,InfoComandsDelegate {
    
    
    @IBOutlet var infoTextView: NSTextView!
    
    
    
    
    @IBAction func runComandAction(_ sender: NSButton) {
        
        switch  sender.tag {
        case 0:
            print("Whois")
            
            let genericPraser:KUGenericPraser = KUGenericPraser()
            let comand:Comand = GenericComand(name:"generic", praser:genericPraser ,taskPath:"/bin/ls", taskArgs: ["-a"])
//            appController.runInfo(comand:comand)
            
            
            let WhoisPraser:KUGenericPraser = KUGenericPraser()
            let whois:KUWhois = KUWhois(withIp:"8.8.8.8", name:"whois", praser:WhoisPraser)
            appController.runInfo(comand:whois)
            
            
        case 1:
            print("NSLookUP")
 
            
            
        case 2:
            print("Dig falta")
            
        case 3:
            print("TraceRoute")
 
        case 4:
            print("Ping falta")
            
        case 5:
            print("nmap falta")
            
        case 6:
            print("tcpDump falta") //TODO: Se debe hacer un comando que pase los datos uno ha uno.
            
        case 7:
            print("History")
 
            
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
    
    
    //MARK: -------- Update View ---------------
    
    func updateViewWith(data:[String]) {
        infoTextView.insert(array:data)
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


extension NSTextView {
    
    func insert(array:[String]) {
      let result:String = array.joined(separator:"\n")
      self.string = result
        
    }
    
}




