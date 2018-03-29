//
//  Prasers.swift
//  FireWarWall
//
//  Created by Kurushetra on 16/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation




protocol Prasable  {
    func prase(comandResult:String) -> Any
}

struct GenericPraser:Prasable   {
    
    func prase(comandResult:String) -> Any {
        return comandResult
    }
}


class StatePraser:Prasable   {
    
    func prase(comandResult:String) -> Any {
        var state:Bool!
        
        if comandResult.contains("Status") {
            
            if comandResult.contains("Disabled") {
                state = false
            } else if comandResult.contains("Enabled"){
                state = true
            }
        }
        return state
    }
}


class netStatPraser:Prasable   {
    
    func prase(comandResult:String) -> Any {
        var result:String!
        if comandResult.contains("tcp4") {
            result = comandResult
        }
        return result
    }
}


struct badHostsPraser:Prasable   {
    
    func prase(comandResult:String) -> Any {
        return comandResult
    }
}

struct nsLookUpPraser:Prasable   {
    
    func prase(comandResult:String) -> Any {
        var result:String!
        
        if comandResult.contains("Server:") {
            result = comandResult
        }
        return  result
    }
}
