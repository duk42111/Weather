//
//  NetworkingConfiguration.swift
//  Wipro
//
//  Created by Mladen Despotovic on 11/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation

// Default values as constants for now
let DefaultHeaders = ["Accept-Encoding":"gzip"]
let DefaultHostURL = "http://api.openweathermap.org"
let DefaultTimeout:NSTimeInterval = 20

let AdditionalHeaders = [String: String]()

public class NetworkingConfiguration {

    var defaultHeaders:Dictionary<String,String> = DefaultHeaders
    private(set) var hostURLString:String = DefaultHostURL
    private(set) var sessionFactory:SessionFactory = JSONSessionFactory.init()
    private(set) var timeoutInterval:NSTimeInterval = DefaultTimeout
    private(set) var additionalHeaders:Dictionary<String,String>? = nil
    private(set) var networkingErrorDelegate:NetworkErrorHandling? = nil
    
    init() { }
    
    init(serverHostURLString:String,
         paramSessionFactory:SessionFactory,
         paramTimeoutInterval:NSTimeInterval?,
         paramAdditionalHeaders:Dictionary<String,String>?,
         paramNetworkingErrorDelegate:NetworkErrorHandling?) {
        
        defaultHeaders = DefaultHeaders
        hostURLString = serverHostURLString
        sessionFactory = paramSessionFactory
        if paramTimeoutInterval == nil {
            
            timeoutInterval = DefaultTimeout
        }
        else {
            
            timeoutInterval = paramTimeoutInterval!
        }
        if paramAdditionalHeaders == nil {
            
            additionalHeaders = AdditionalHeaders
        }
        else {
            
            additionalHeaders = paramAdditionalHeaders!
        }
        networkingErrorDelegate = paramNetworkingErrorDelegate
    }
}


