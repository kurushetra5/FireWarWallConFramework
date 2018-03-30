//
//  dataBaseManager.swift
//  AppController-scan
//
//  Created by Kurushetra on 31/8/17.
//  Copyright © 2017 Kurushetra. All rights reserved.
//

import Foundation
import CoreData
import Cocoa



protocol dataBaseDelegate {
    
    func filled(node:ConectionNode, amountIps:Int)
    func filled(node:ConectionNode)
    
}



class dataBaseManager  {
    
    var applicationDelegate = NSApplication.shared.delegate  as? AppDelegate
    let managedContext:NSManagedObjectContext!
 
    var ipLocator:IPLocator = IPLocator()
    var foundedNode:ConectionNode!
    var withAmountTarget:Bool = false
    var amountIpsToCheck:Int!
    var delegate:dataBaseDelegate!
    
    var dataBase:[ConectionNode] {
        return nodesDataBase()
    }
    
    
    init() {
        managedContext =  applicationDelegate?.persistentContainer.viewContext
        resetAllConections()
    }
    
    
    public  func cleanDataBase() {
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName:"ConectionNode")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try managedContext.execute(request)
            
        } catch {
            // Error Handling
        }
        
    }
 
    func resetAllConections() {
        
        for node in dataBase {
            node.conected = false
        }
    }
    
    
    
    
    func nodeIpReady(node:ConectionNode) {
        
    }
    
    
    
//    func ipLocationReady(ipNode:NetStatConection) {
//
//         let newNode:ConectionNode = newIpEntity()
//         newNode.adress = ipNode.ipLocation.org
//         newNode.city = ipNode.ipLocation.city
//         newNode.country = ipNode.ipLocation.country
//         newNode.destination = ipNode.destinationIp
//         newNode.ip = ipNode.destinationIp
//         newNode.source = ipNode.sourceIp
//         delegate?.filled(node:newNode)
//
////         print(newNode.adress)
////         print(newNode)
//
//        do {
//            try self.managedContext.save()
//
//        } catch let error as NSError {
//          print("Could not save. \(error), \(error.userInfo)")
//        }
//
//
//    }
    
    
    
    
 
 
    
    func  newIpEntity() -> ConectionNode {
        let entity = NSEntityDescription.entity(forEntityName: "ConectionNode", in: self.managedContext)!
        let newConection = NSManagedObject(entity: entity,insertInto: self.managedContext) as! ConectionNode
        return newConection
    }
    
    
    private  func nodesDataBase() -> [ConectionNode] {
        
        var nodes:[ConectionNode] = []
        
        let fetchRequest: NSFetchRequest<ConectionNode> = ConectionNode.fetchRequest()
        
        do {
            let searchResults = try managedContext.fetch(fetchRequest)
//            print ("num of results = \(searchResults.count)")
            
            for ip in searchResults as [ConectionNode] {
                nodes.append(ip)
                //                print("\(String(describing: ip.value(forKey: "number")))")
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        return nodes
    }
    
    
    
 
    
    
//    func isInDataBase(ip:NetStatConection) -> ConectionNode! {
//
//        //assert o que
//
//
//        if let keepedConection = fetchInfoFor(ip:ip) {
//            keepedConection.conected = true
//            return keepedConection
//        }else {
//            return nil
//        }
//
//
//
//    }
    
    
    
    
 
    
//    func fetchInfoFor(ip:NetStatConection) ->  ConectionNode! { //FIXME: Sobra ip
//
//
//        var foundNode:ConectionNode!
//
//        let fetchRequest: NSFetchRequest<ConectionNode> = ConectionNode.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "destination == %@",ip.destinationIp)
//
//        do {
//            let searchResults = try managedContext.fetch(fetchRequest)
////            print ("num of results = \(searchResults.count)")
//
//            if searchResults.count >= 2 {
//                print("Duplicate Ip found")
//
//                foundNode = searchResults[0]//FIXME: Sobra
//                foundedNode = searchResults[0]
//            }
//            if searchResults.count == 1 {
//
//                foundNode = searchResults[0]//FIXME: Sobra
//                foundedNode = searchResults[0]
//            }
//
//        } catch {
//            print("Error with request: \(error)")
//        }
//        return  foundNode
//    }
    
    
 
    
    
}
