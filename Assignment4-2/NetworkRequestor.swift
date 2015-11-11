//
//  NetworkRequestor.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/10/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import Foundation
import SystemConfiguration

@objc protocol NetworkRequestorDelegate {
    optional func retrievedAllStudents(array: NSArray)
    optional func rowUpdateSuccessful(boolean: Bool)
    optional func rowDeletionSuccessful(boolean: Bool)
    optional func rowInsertSuccessful(boolean: Bool)
    func noNetworkConnection()
}

class NetworkRequestor {
    
    var delegate:NetworkRequestorDelegate?
    
    init(){
        
    }
    
    func getAllStudents(){
        let baseURL = "http://csmadison.dhcp.bsu.edu/~vjtanksale/cs320/selectstudents.php"
        let url = NSURL(string: baseURL)
        let session = NSURLSession.sharedSession()
        let datatask = session.dataTaskWithURL(url!) { (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            if let HTTPResponse = response as? NSHTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                if (statusCode == 200 && error == nil){
                    let array = self.parseJSON(data)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.retrievedAllStudents!(array)
                    })
                }
            }
        }
        if (self.connectedToNetwork()){
            datatask.resume()
        }
    }
    
    func updateStudent(studentId: Int, withData params: String){
        let baseURL = "http://csmadison.dhcp.bsu.edu/~vjtanksale/cs320/updatestudents.php"
        let url = NSURL(string: baseURL)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        let datatask = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let HTTPResponse = response as? NSHTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                if (statusCode == 200 && error == nil){
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.rowUpdateSuccessful!(true)
                    })
                }
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.delegate?.rowUpdateSuccessful!(false)
            })
        }
        datatask.resume()
    }
    
    func deleteStudent(studentId: Int){
        print("Delete the student!")
        self.delegate?.rowDeletionSuccessful!(false)
    }
    
    func parseJSON(data: NSData?) -> NSArray{
        var parsedData:NSArray!
        do {
            parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        } catch {
            print("Error parsing JSON")
        }
        return parsedData
    }
    
    private func connectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        let status = isReachable && !needsConnection
        if (status == false){
            self.delegate?.noNetworkConnection()
        }
        
        return status
    }
}
