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
    
    let appDelegate = NSApplication.shared.delegate  as! AppDelegate
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
        managedContext = self.appDelegate.persistentContainer.viewContext
 
    }
    
    
    
 
    func nodeIpReady(node:ConectionNode) {
        
    }
    
    
    
    func ipLocationReady(ipNode:NetStatConection) {
        
         let newNode:ConectionNode = newIpEntity()
         newNode.adress = ipNode.ipLocation.city
         newNode.destination = ipNode.destinationIp
         newNode.ip = ipNode.destinationIp
         newNode.source = ipNode.sourceIp
         delegate?.filled(node:newNode)
        
//         print(newNode.adress)
//         print(newNode)
        
        do {
            try self.managedContext.save()
            
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
        
 
    }
    
    
    
    
 
    
//    func nodeFromDataBase(ip:String) {
//        if isInDataBase(ip:ip) {
//            print("Node is Founded in DataBase")
////            nodeFilledDelegate?.filled(node:foundedNode)
//        } else {
//            let newIp:ConectionNode = newIpEntity()
////            newIp.number = ip
//            do {
//                try self.managedContext.save()
//
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
////            nodeFilledDelegate?.filled(node:newIp)
//        }
//    }
    
    
    
//    func nodeFrom(ip:String) {
//        
//        if isInDataBase(ip:ip) {
//            print("Node is Founded in DataBase")
////            nodeFilledDelegate?.filled(node:foundedNode)
//            
//        } else {
//            print("Node is Filling from Internet")
//            ipLocator.fetchIpLocation(ip:ip)
//        }
//    }
//    
    
    
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
            print ("num of results = \(searchResults.count)")
            
            for ip in searchResults as [ConectionNode] {
                nodes.append(ip)
                //                print("\(String(describing: ip.value(forKey: "number")))")
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        return nodes
    }
    
    
    
 
    
    
    func isInDataBase(ip:NetStatConection) -> ConectionNode! {
        
        //assert o que
        
        
        if let keepedConection = fetchInfoFor(ip:ip) {
            return keepedConection
        }else {
            return nil
        }
        
//        if fetchInfoFor(ip:ip)  != nil  {
//            //            let ipNode:String = node.ip
//            //            print(ipNode)
//
//            return true
//        }else {
//            return false
//        }
        
        //TODO: mirar si esta si esta rellenar si no false y lo localiza
        
    }
    
    
    
    
//    func isFilledThis(node:TraceRouteNode) -> Bool {
//
//        if fetchInfoFor(node:node).found == true {
//            //            let ipNode:String = node.ip
//            //            print(ipNode)
//            return true
//        }else {
//            return false
//        }
//
//        //TODO: mirar si esta si esta rellenar si no false y lo localiza
//
//    }
    
    func fetchInfoFor(ip:NetStatConection) ->  ConectionNode! { //FIXME: Sobra ip
        
//        var founded:Bool = false
        var foundNode:ConectionNode!
        
        let fetchRequest: NSFetchRequest<ConectionNode> = ConectionNode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "destination == %@",ip.destinationIp)
        
        do {
            let searchResults = try managedContext.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")
            
            if searchResults.count >= 2 {
                print("Duplicate Ip found")
//                founded = true
                foundNode = searchResults[0]//FIXME: Sobra
                foundedNode = searchResults[0]
            }
            if searchResults.count == 1 {
//                founded = true
                foundNode = searchResults[0]//FIXME: Sobra
                foundedNode = searchResults[0]
            }
            
        } catch {
            print("Error with request: \(error)")
        }
        return  foundNode
    }
    
    
    
//    func fetchInfoFor(node:TraceRouteNode) -> (found:Bool,ip:Node) { //FIXME: Sobra ip
//
//        var founded:Bool = false
//        var foundNode:Node = Node()
//
//        let fetchRequest: NSFetchRequest<Node> = Node.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "number == %@",node.ip)
//
//        do {
//            let searchResults = try managedContext.fetch(fetchRequest)
//            print ("num of results = \(searchResults.count)")
//
//            if searchResults.count >= 2 {
//                print("Duplicate Ip found")
//                founded = true
//                foundNode = searchResults[0]//FIXME: Sobra
//                foundedNode = searchResults[0]
//            }
//            if searchResults.count == 1 {
//                founded = true
//                foundNode = searchResults[0]//FIXME: Sobra
//                foundedNode = searchResults[0]
//            }
//
//        } catch {
//            print("Error with request: \(error)")
//        }
//        return (founded,foundNode)
//    }
//
//
    
    
    
    
    
    
//    func fetchInfoFor(node:TraceRouteNode) -> Bool {
//        print(node.ip)
//        var founded:Bool = false
//
//        let fetchRequest: NSFetchRequest<Node> = Node.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "number == %@",node.ip)
//
//        do {
//            let searchResults = try managedContext.fetch(fetchRequest)
//            print ("num of results = \(searchResults.count)")
//            if searchResults.count >= 2 {
//                print("Duplicate Ip found")
//                founded = true
//            }
//            if searchResults.count == 1 {
//                founded = true
//                foundedNode = searchResults[0]
//                //                    var newNode:Node = newIpEntity()
//                //                    newNode.aso =
//
//                //                    let ipResult:Node = searchResults[0]
//                //                    node.lat = ipResult.latitud
//                //                    node.lon =  ipResult.longitude
//                //                    node.aso = ipResult.aso
//                //                    node.city = ipResult.city
//            }
//
//            //                for ip in searchResults as [Node] {
//            //                    newConection.comIpLatitud = String(ip.value(forKey: "latitud") as! Double )
//            //                    newConection.comIpLongitude = ip.value(forKey: "longitude") as! String
//            //                }
//        } catch {
//            print("Error with request: \(error)")
//        }
//        return founded
//
//        //            }
//        //
//        //        if direction == Direction.going {
//        //
//        //            let fetchRequest: NSFetchRequest<Node> = Node.fetchRequest()
//        //            fetchRequest.predicate = NSPredicate(format: "number == %@", conection.goIp)
//        //
//        //            do {
//        //                let searchResults = try managedContext.fetch(fetchRequest)
//        //                print ("num of results = \(searchResults.count)")
//        //
//        //                for ip in searchResults as [Node] {
//        //                    newConection.goIpLatitud = String(ip.value(forKey: "latitud") as! Double )
//        //                    newConection.goIpLongitude = ip.value(forKey: "longitude") as! String
//        //
//        //
//        //                    //                    print("\(String(describing: ip.value(forKey: "number")))")
//        //                }
//        //            } catch {
//        //                print("Error with request: \(error)")
//        //            }
//        //        }
//        //
//        //
//        //        if self.newConection.isFilled() {
//        ////            self.newConectionReadyToShow()
//        //        }
//        //
//    }
    
    
    
    //    func fetchCoreDataInfoForNew(conection:Conection , direction:Direction) {
    //
    //        if direction == Direction.coming {
    //
    //            let fetchRequest: NSFetchRequest<Node> = Node.fetchRequest()
    //            fetchRequest.predicate = NSPredicate(format: "number == %@",conection.comIp)
    //
    //            do {
    //                let searchResults = try managedContext.fetch(fetchRequest)
    //                print ("num of results = \(searchResults.count)")
    //
    //                for ip in searchResults as [Node] {
    //                    newConection.comIpLatitud = String(ip.value(forKey: "latitud") as! Double )
    //                    newConection.comIpLongitude = ip.value(forKey: "longitude") as! String
    //                }
    //            } catch {
    //                print("Error with request: \(error)")
    //            }
    //        }
    //
    //        if direction == Direction.going {
    //
    //            let fetchRequest: NSFetchRequest<Node> = Node.fetchRequest()
    //            fetchRequest.predicate = NSPredicate(format: "number == %@", conection.goIp)
    //
    //            do {
    //                let searchResults = try managedContext.fetch(fetchRequest)
    //                print ("num of results = \(searchResults.count)")
    //
    //                for ip in searchResults as [Node] {
    //                    newConection.goIpLatitud = String(ip.value(forKey: "latitud") as! Double )
    //                    newConection.goIpLongitude = ip.value(forKey: "longitude") as! String
    //
    //
    //                    //                    print("\(String(describing: ip.value(forKey: "number")))")
    //                }
    //            } catch {
    //                print("Error with request: \(error)")
    //            }
    //        }
    //        
    //        
    //        if self.newConection.isFilled() {
    ////            self.newConectionReadyToShow()
    //        }
    //        
    //    }
    //    
    
    
}
