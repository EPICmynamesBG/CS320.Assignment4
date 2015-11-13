//
//  WatchDataManager.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/12/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchDataManager {
    var data: NSArray!
    static var filePath: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("data.json")
    
    func saveJSON(data: NSArray) {
        self.data = data
        self.data.writeToFile(WatchDataManager.filePath, atomically: true)
        WatchDataManager.notifyWatchAppOfChanges()
    }
    
    class func notifyWatchAppOfChanges() {
        let session = WCSession.defaultSession()
        //cancels all previous file transfers
        for transfer in session.outstandingFileTransfers {
            transfer.cancel()
        }
        //setting up new file transfers
        let fileURL = NSURL(fileURLWithPath: WatchDataManager.filePath)
        session.transferFile(fileURL, metadata: nil)
    }
    
    class func getJSON() -> NSArray? {
        let array = NSArray(contentsOfFile: filePath)
        return array
    }
    
    init(){
        self.data = NSArray()
    }
    
}