//
//  InfoComandsManager.swift
//  FireWarWall
//
//  Created by Kurushetra on 8/3/18.
//  Copyright © 2018 Kurushetra. All rights reserved.
//

import Foundation


protocol  InfoComandsManagerDelegate {
    func comand(finishWith data:String)
}


class InfoComandsManager  {
    
    
//    private var comandRuner:ComandRuner = ComandRuner()
    var infoComandsManagerDelegate:InfoComandsManagerDelegate!
    
    
    init() {
//        comandRuner.comandRunerDelegate = self
    }

    
    
    //MARK: ------------- Public funcs  ------------
//    public func run(comand:ComandType) {
//
//        comandRuner.runComand(type:comand, ip:"85.23.45.3")
//    }
    
    
    
    
    
    //MARK: ------------- ComandRuner Delegate ------------
    
    func comand(finishWith data:String) {
         infoComandsManagerDelegate?.comand(finishWith:data)
    }
//    func comand(type:ComandType, finishWith data: String) {
//        //        parseComand(result: data)
//        print(type)
//    }
}
