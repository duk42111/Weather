//
//  SessionFactory.swift
//  Wipro
//
//  Created by Mladen Despotovic on 12/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation

protocol SessionFactory {

    func createJSONSession(URL:NSURL,
                           paramNetworkingConfiguration:NetworkingConfiguration,
                           paramHTTPMethodString:HTTPMethodName,
                           paramRequestParamaters:Dictionary<String,String>?,
                           paramCompletionClosure:RequestCompletion,
                           paramProgressClosure:RequestProgress?) -> JSONSession
}

class JSONSessionFactory: SessionFactory {
    
    func createJSONSession(URL:NSURL,
                           paramNetworkingConfiguration:NetworkingConfiguration,
                           paramHTTPMethodString:HTTPMethodName,
                           paramRequestParamaters:Dictionary<String,String>?,
                           paramCompletionClosure:RequestCompletion,
                           paramProgressClosure:RequestProgress?) -> JSONSession {
        
        return JSONSession.init(URL: URL,
                                paramNetworkingConfiguration: paramNetworkingConfiguration,
                                paramHTTPMethodString: paramHTTPMethodString,
                                paramRequestParamaters: paramRequestParamaters,
                                paramCompletionClosure: paramCompletionClosure,
                                paramProgressClosure: paramProgressClosure)
    }
}
