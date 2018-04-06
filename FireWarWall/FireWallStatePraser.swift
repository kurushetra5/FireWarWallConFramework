//
//  FireWallStatePraser.swift
//  FireWarWall
//
//  Created by Kurushetra on 6/4/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation
import KUTaskFramework


struct FireWallStatePraser:Prasable   {
    
    func prase(comandResult:[String]) -> Any { //FIXME: Si puede ser devolver String
        var state:String!
        
        if comandResult[0].contains("Status:") { //FIXME: Arreglar
            
            if comandResult[0].contains("Disabled") {
                state = "Disabled"
            } else if comandResult[0].contains("Enabled"){
                state = "Enabled"
            }
        }
         return state
    }
}
