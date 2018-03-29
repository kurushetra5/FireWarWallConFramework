//
//  ShellComand.swift
//  FireWarWall
//
//  Created by Kurushetra on 10/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol ShellComandDelegate {
    func finish(shellComand:ShellComand)
}

extension ShellComandDelegate where Self :AppTaskComand {
    
     func finish(shellComand:ShellComand) {
        print(shellComand.comandType)
        print(shellComand.comandResult)
        let resultFromComand =  praser.prase(comandResult: shellComand.comandResult)
        delegate?.comand(finish:shellComand.comandType, result: resultFromComand)
    }
}



class  ShellComand  {
    
    var comandType:ComandType!
    var comandResult:String!
    
    var shellComandDelegate:ShellComandDelegate!
    
    
    public  func run(comand:Comand) {
        
        let task = Process()
        task.launchPath = comand.taskPath
        task.arguments = comand.taskArgs
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let fh = pipe.fileHandleForReading
        fh.waitForDataInBackgroundAndNotify()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(receivedData), name: NSNotification.Name.NSFileHandleDataAvailable, object: nil)
        
//         task.terminationHandler = {task -> Void in
//            print(self.comandResult)
//            print(self.comandType)
//         }
        task.launch()
    }
    
    
    
    
     @objc private func receivedData(notif : NSNotification) {
        
        let fh:FileHandle = notif.object as! FileHandle
        
        let data = fh.availableData
         if data.count > 1 { //TODO: buscar solucion
            let string =  String(data: data, encoding: String.Encoding(rawValue: String.Encoding.ascii.rawValue))
             comandResult = string!
            
            
//            DispatchQueue.main.sync {
                self.shellComandDelegate?.finish(shellComand:self)
//             }
//            shellComandDelegate?.finish(shellComand:self)
        
            
         }else {
//             print("Error: receivedData  salida de ShellComand sin Datos ")
         }
//         fh.waitForDataInBackgroundAndNotify()
    }
    
    
}
