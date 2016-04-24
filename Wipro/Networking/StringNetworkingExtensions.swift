//
//  StringNetworkingExtensions.swift
//  Wipro
//
//  Created by Mladen Despotovic on 11/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation


extension String {
    
    private static func queryString(parameterKey:String, value:AnyObject) -> String? {

        if value is String || value is NSNumber || value is NSString || value is Int || value is Double || value is Float  {
            
            return "\(parameterKey)=\(value)"
        }
        else {
            
            return nil
        }
    }
    
    public static func queryString(parameters:Dictionary<String,String>) -> String? {
        
        var queryStrings:Array<String> = [String]()
        
        for (key, value) in parameters {
            
            if let escapedString = value.stringByRemovingPercentEncoding {
                
                if let parameter = self.queryString(key, value: escapedString) {
                    
                    queryStrings.append(parameter)
                }
            }
            
        }
        
        let reducedString = queryStrings.joinWithSeparator("&")
        return  "?\(reducedString)"
    }
}


let syncQueue:dispatch_queue_t = dispatch_queue_create(UnsafeMutablePointer(("com.mladen.pointerarray" as NSString).UTF8String), DISPATCH_QUEUE_SERIAL)

extension NSPointerArray {
    
    func addObjectSynchronously(objectToAdd :AnyObject) {
        
        dispatch_sync(syncQueue) {
            
            self.addPointer(UnsafeMutablePointer(unsafeAddressOf(objectToAdd)))
        }
    }
}

extension NSMutableArray {
    
    func addObjectSynchronously(objectToAdd :AnyObject) {
        
        dispatch_sync(syncQueue) {
            
            self.addObject(objectToAdd)
        }
    }
    
    func removeObjectSynchronously(objectToRemove :AnyObject) {
        
        dispatch_sync(syncQueue) {
            
            self.removeObject(objectToRemove)
        }
    }

}

