//
//  NSArrayCompare.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/13/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import Foundation

class NSArrayCompare {
    //static method for comparing two NSArrays recieved from JSON
    class func arraysAreEqual(array1: NSArray, array2: NSArray) ->Bool{
        if (array1.count == array2.count){
            var sameCount = 0
            for (var i = 0; i < array1.count; i++){
                let dict1 = array1[i] as! NSDictionary
                let dict2 = array2[i] as! NSDictionary
                let keys = dict1.allKeys
                var sameCount2 = 0
                for (var j=0; j < keys.count; j++){
                    let value1 = dict1.objectForKey(keys[j]) as! String
                    let value2 = dict2.objectForKey(keys[j]) as! String
                    if (value1 == value2) {
                        sameCount2++
                    }
                }
                if (sameCount2 == keys.count){
                    sameCount++
                } else {
                    return false
                }
            }
            if (sameCount == array1.count){
                return true
            } else {
                return false
            }
        } else{
            return false
        }
    }

}