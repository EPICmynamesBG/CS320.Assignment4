//
//  WatchNotifier.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/11/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchNotifier {
    
    init(){
        
    }
    
    
    #if os(iOS)
    
    func sendWatchData(data: NSArray){
        if (!data.isEqual(nil)){
            let session = WCSession.defaultSession()
            if (session.paired && session.watchAppInstalled){
                for transfer in session.outstandingFileTransfers{
                    transfer.cancel()
                }
                let modData = NSKeyedArchiver.archivedDataWithRootObject(data)
                session.sendMessageData(modData, replyHandler: { (data: NSData) -> Void in
                    print("Watch replied with data \(data.debugDescription)")
                    }, errorHandler: { (error:NSError) -> Void in
                        print("Error transferring data to watch")
                })
            } else {
                print("Watch is either not connected or watch app is not installed")
            }
        }
    }
    
    func sendWatchData(data: NSData){
        if (!data.isEqual(nil)){
            let session = WCSession.defaultSession()
            if (session.paired && session.watchAppInstalled){
                for transfer in session.outstandingFileTransfers{
                    transfer.cancel()
                }
                session.sendMessageData(data, replyHandler: { (data: NSData) -> Void in
                    print("Watch replied with data \(data.debugDescription)")
                    }, errorHandler: { (error:NSError) -> Void in
                        print("Error transferring data to watch")
                })
            } else {
                print("Watch is either not connected or watch app is not installed")
            }
        }
    }
    #endif
}
