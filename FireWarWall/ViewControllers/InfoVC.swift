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
 
//            ComandsRuner.run(comand:KUPingListener()) { (result) in
//                print(result)
//            }
//            run(comand:KUPingListener())
            
        case 2:
            print("Dig falta")
            
            appController.runContinously(comand:KUPingListener())
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
    
    
    
    
//    //_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
//    struct PingListenerPraser:Prasable {
//        func prase(comandResult: [String]) -> Any {
//            return comandResult
//        }
//    }
//
//    struct  KUPingListener:Comand    {
//
//        var praser: Prasable = PingListenerPraser()
//
//        var taskPath: String = "/bin/sh"
//        var taskArgs: [String] =  ["-c" , "echo yameacuerdo8737 | sudo -S tcpdump -i en4"]
//        var name: String = "chatListenerTcpDump"
//    }
//
//    //_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
//
//     var fileH:FileHandle!
//     var fileR:FileHandle!
//     var arrayLines:[String]!
//
//    private  func run(comand:Comand ) {
//
//        fileH  = FileHandle(forWritingAtPath:"/Users/kurushetra/Desktop/tcpd_3.txt")!
//        fileR  = FileHandle(forReadingAtPath:"/Users/kurushetra/Desktop/tcpd_3.txt")!
//        arrayLines = []
//
//
//        let task = Process()
//        task.launchPath = comand.taskPath
//        task.arguments = comand.taskArgs
//
//        let pipe = Pipe()
//        task.standardOutput = pipe
//        let fh = pipe.fileHandleForReading
//        fh.waitForDataInBackgroundAndNotify()
//
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(receivedData), name: NSNotification.Name.NSFileHandleDataAvailable, object: nil)
//
//
//        task.launch()
//    }
//
//
//
//    @objc private func receivedData(notif : NSNotification) {
//
//        let fh:FileHandle = notif.object as! FileHandle
//
//        let data = fh.availableData
//        if data.count > 1 {
//            let string =  String(data: data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
////            self.stateResult = string!
////            print(string ?? "" )
////            arrayLines.append(string!)
//
//
//             fileH.write(string!.data(using:.utf8)!)
//            readDataFile()
//
////            self.comandRunerDelegate?.comand(finishWith: self.stateResult)
//            fh.waitForDataInBackgroundAndNotify()
//        }
//    }
//
//
//
//    func readDataFile() {
//
//
//
//         let data:Data =  fileR.readDataToEndOfFile()
//
//         let stringD:String = String(data:data, encoding:.utf8) as String!
//         let lines = stringD.components(separatedBy:"\n")
//         arrayLines.append(contentsOf:lines)
//
////        print("_//_-_-_-_-_-_-_-_-_-_-_-_-_-Lines in file_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_")
////        print(lines.count)
//        print("_//_-_-_-_-_-_-_-_-_-Lines in Array_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_")
//        print(arrayLines.count)
//
//    }
//
//    //_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
//
    
    
    
    
    
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




