//
//  SaveDataManager.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/12/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import Foundation

class SaveDataManager {
    static var data: NSArray = NSArray()
    static var filePath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("data.json")
    
    class func saveJSON(data: NSArray) {
        self.data = data
        self.data.writeToFile(self.filePath, atomically: true)
    }
    
    class func getJSON() -> NSArray? {
        let array = NSArray(contentsOfFile: filePath)
        return array
    }
}