//
//  IpsManager.swift
//  FireWarWall
//
//  Created by Kurushetra on 7/2/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


class IpsManager  {
    
    
    func findIpsIn(text:String) -> [String]! {
        
        let ips = findIP(inText:text)
        
        if ips.count >= 1 {
            return ips
        }else {
            return nil
        }
    }
    
    
    
    func findNetStatIps(inText:String) -> [NetStatConection] {
        
        var arrayConections:[NetStatConection] = []
        var conectionsFinal:[NetStatConection] = []
        let lines = inText.components(separatedBy:"\n")
        
        for line in lines {
            arrayConections.append(parseLine(line:line))
        }
        for conection in arrayConections {
            if conection.destinationIp.count > 5 && conection.sourceIp.count > 5 {
                if isValid(ip:conection.destinationIp) {
                    if !isLocal(ip:conection.destinationIp) {
                        conectionsFinal.append(conection)
                    }
                    
                }
            }
        }
      return conectionsFinal
    }
    
    
    
    func isLocal(ip:String) -> Bool {
        
        if ip == "127.0.0.1" {
            return true
        } else  if ip == "192.168.8.1" {
            return true
        }else  if ip == "192.168.8.100" {
            return true
        } else {
            return false
        }
    }
    
    
    
    func parseLine(line:String)  -> NetStatConection {
        
        var aIP:[String] = []
        let arrayOfLine = line.components(separatedBy:" ")
        
        for word in arrayOfLine {
            if word.count >= 2 {
                let separated = word.components(separatedBy:".")
                if separated.count >= 5 {
                    let sep  = separated.dropLast()
                    let joinet = sep.joined(separator:".")
                    aIP.append(joinet)
                }
            }
        }
        
        var conection:NetStatConection = NetStatConection()
        if aIP.count > 1 {
            if aIP[0] != aIP[1] {
                conection.sourceIp = aIP[0]
                conection.destinationIp = aIP[1]
            }
        }
        return conection
    }
    
    
    
    
    
    
    func findIP(inText:String) -> [String] {
        let text2 = inText.replacingOccurrences(of:" ", with:"")
        var arrayNumbers:[String] = []
        var text3:String = ""
        for cha in text2 {
            
            let number = Int(cha.description)
            
            if number != nil {
                
                text3.append(cha)
            }else  if cha == "." {
                text3.append(cha)
            }else   {
                text3.append("-")
            }
        }
        arrayNumbers = text3.components(separatedBy:"-")
        var arrayN:[String] = []
        
        for  num in  arrayNumbers.indices {
            if arrayNumbers[num].count >= 7 {
                if isValid(ip:arrayNumbers[num]) {
                    arrayN.append(arrayNumbers[num])
                }
            }
        }
        return arrayN
    }
    
    
    
    
    func isValid(ip: String) -> Bool {
        let parts = ip.components(separatedBy:".")
        let numbers = parts.flatMap { Int($0) }
        return parts.count == 4 && numbers.count == 4 && !numbers.contains {$0 < 0 || $0 > 255}
    }
    
}
