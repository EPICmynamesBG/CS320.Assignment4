//
//  NetworkRequestor.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/10/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import Foundation
#if os(iOS)
import SystemConfiguration
#endif
import WatchConnectivity

@objc protocol NetworkRequestorDelegate {
    optional func retrievedAllStudents(array: NSArray)
    optional func rowUpdateSuccessful(boolean: Bool)
    optional func rowDeletionSuccessful(boolean: Bool)
    optional func rowInsertSuccessful(boolean: Bool)
    #if os(iOS)
    func noNetworkConnection()
    #else
    func noPhoneConnected()
    #endif
}

class NetworkRequestor: NSObject, WCSessionDelegate {
    
    var delegate:NetworkRequestorDelegate?
    var session: WCSession?
    var configuration: NSURLSessionConfiguration!
    
    override init(){
        self.configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.configuration.timeoutIntervalForRequest = NSTimeInterval(15)
    }
    
    func getAllStudents(){
        let baseURL = "http://csmadison.dhcp.bsu.edu/~vjtanksale/cs320/selectstudents.php"
        let url = NSURL(string: baseURL)
        let session = NSURLSession(configuration: self.configuration)
        let datatask = session.dataTaskWithURL(url!) { (data:NSData?, response:NSURLResponse?, error: NSError?) -> Void in
            if (error == nil){
                if let HTTPResponse = response as? NSHTTPURLResponse {
                    let statusCode = HTTPResponse.statusCode
                    if (statusCode == 200 && error == nil){
                        let array = self.parseJSON(data)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.delegate?.retrievedAllStudents!(array)
                        })
                    }
                }
            } else {
                #if os(iOS)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.delegate?.noNetworkConnection()
                })
                #else
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.delegate?.noPhoneConnected()
                })
                #endif
            }
        }
        #if os(iOS)
            if (self.connectedToNetwork()){
                datatask.resume()
            }
        #else
            if (self.connectedToPhone()){
                datatask.resume()
            }
        #endif
    }
    
    func getAllStudentsInFetch() -> NSArray?{
        let baseURL = "http://csmadison.dhcp.bsu.edu/~vjtanksale/cs320/selectstudents.php"
        let url = NSURL(string: baseURL)
        do {
            let data = try NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            return self.parseJSON(data)
        } catch {
            return nil
        }
    }
    
    func updateStudent(studentId: Int, withData params: String){
        let baseURL = "http://csmadison.dhcp.bsu.edu/~vjtanksale/cs320/updatestudents.php"
        var cleanedParams = "StudentId=\(studentId)&\(params)"
        cleanedParams = cleanedParams.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let url = NSURL(string: baseURL)
        let session =  NSURLSession(configuration: self.configuration)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = cleanedParams.dataUsingEncoding(NSUTF8StringEncoding)
        let datatask = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil){
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
            } else {
                #if os(iOS)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.noNetworkConnection()
                    })
                #else
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.noPhoneConnected()
                    })
                #endif
            }
            
        }
        #if os(iOS)
            if (self.connectedToNetwork()){
                datatask.resume()
            }
        #else
            if (self.connectedToPhone()){
                datatask.resume()
            }
        #endif
    }
    
    func deleteStudent(studentId: Int){
        let baseURL = "http://csmadison.dhcp.bsu.edu/~vjtanksale/cs320/deletestudents.php"
        let param = "StudentId=\(studentId)"
        let url = NSURL(string: baseURL)
        let session =  NSURLSession(configuration: self.configuration)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        let datatask = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil){
                if let HTTPResponse = response as? NSHTTPURLResponse {
                    let statusCode = HTTPResponse.statusCode
                    if (statusCode == 200 && error == nil){
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.delegate?.rowDeletionSuccessful!(true)
                        })
                    }
                } else {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.rowDeletionSuccessful!(false)
                    })
                }
            } else {
                #if os(iOS)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.noNetworkConnection()
                    })
                #else
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.noPhoneConnected()
                    })
                #endif
            }
        }
        #if os(iOS)
            if (self.connectedToNetwork()){
                datatask.resume()
            }
        #else
            if (self.connectedToPhone()){
                datatask.resume()
            }
        #endif
    }
    
    func createStudent(params: String){
        let cleanedParams = params.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let baseURL = "http://csmadison.dhcp.bsu.edu/~vjtanksale/cs320/insertstudents.php"
        let url = NSURL(string: baseURL)
        let session =  NSURLSession(configuration: self.configuration)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = cleanedParams.dataUsingEncoding(NSUTF8StringEncoding)
        let datatask = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil){
                if let HTTPResponse = response as? NSHTTPURLResponse {
                    let statusCode = HTTPResponse.statusCode
                    if (statusCode == 200 && error == nil){
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.delegate?.rowInsertSuccessful!(true)
                        })
                    }
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.delegate?.rowInsertSuccessful!(false)
                })
            } else {
                #if os(iOS)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.noNetworkConnection()
                    })
                #else
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.delegate?.noPhoneConnected()
                    })
                #endif
            }
            
        }
        #if os(iOS)
            if (self.connectedToNetwork()){
                datatask.resume()
            }
        #else
            if (self.connectedToPhone()){
                datatask.resume()
            }
        #endif
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
    
    #if os(iOS)
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
    #else
    private func connectedToPhone() -> Bool{
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            print(session.reachable)
            if session.reachable {
                return true
            } else {
                self.delegate?.noPhoneConnected()
                return false
                
            }
        } else {
            self.delegate?.noPhoneConnected()
        }
        return false
    }
    #endif
}
