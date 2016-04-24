//
//  NetworkingClient.swift
//  Wipro
//
//  Created by Mladen Despotovic on 13/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation

enum RequestType {
    
    case JSON
    case XML
}

class NetworkingClient:NSObject,NSURLSessionTaskDelegate,NSURLSessionDelegate {

    var networkingConfiguration:NetworkingConfiguration
    var activeSessions = NSMutableArray.init(capacity: 0)
    private(set) var session:Session? = nil;
    
    init(configuration:NetworkingConfiguration) {
        
        networkingConfiguration = configuration
    }
    
    func fetch(URLString:String,
               requestType:RequestType,
               HTTPRequestMethod:HTTPMethodName,
               parameters:Dictionary<String,String>,
               completion:RequestCompletion,
               progress:RequestProgress) -> CancelableSession? {
        
        let sessionURLString:String = networkingConfiguration.hostURLString + URLString
        
        if requestType == RequestType.JSON {
            
            session = networkingConfiguration.sessionFactory.createJSONSession(NSURL.init(string: sessionURLString)!,
                                                                               paramNetworkingConfiguration: networkingConfiguration,
                                                                               paramHTTPMethodString: HTTPRequestMethod,
                                                                               paramRequestParamaters: parameters,
                                                                               paramCompletionClosure: completion,
                                                                               paramProgressClosure: progress)
        }

        self.add(session)
        session?.startSession()
        
        return session;
    }
    
    func add(session:Session?) {
        
        guard session != nil else {
            
            return
        }
        activeSessions.addObjectSynchronously(session!)
    }
    
    func remove(session:Session?) {
        
        guard session != nil else {
            
            return
        }
        activeSessions.removeObjectSynchronously(session!)
    }
    
    func cancelAllSessions() {
        
        activeSessions.enumerateObjectsUsingBlock { (object:AnyObject, index:Int, stop:UnsafeMutablePointer<ObjCBool>) in
            
            if object is CancelableSession {
                
                let session = object as! CancelableSession
                session.cancel()
            }
        }
        
        self.activeSessions.removeAllObjects()
    }
}





