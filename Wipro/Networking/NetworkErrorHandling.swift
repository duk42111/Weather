//
//  ErrorHandling.swift
//  Wipro
//
//  Created by Mladen Despotovic on 11/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation

enum NetworkErrorCode:Int {
    
    case UnknownError = 0
    case NetworkError
    case ParsingError
    case UnexpectedResponseCode
    case UnexpectedResponseFormat
}

protocol NetworkErrorType {
    
    var response:NSURLResponse? {get}
    var error:NSError? {get}
    var serverErrorPayload:Dictionary<String,AnyObject>? {get}
    var serverErrorCode:Int? {get}
    var HTTPResponseErrorCode:Int? {get}
    var networkErrorCode:NetworkErrorCode? {get}
    
    init(response:NSURLResponse?,
         paramServerErrorPayload:Dictionary<String,AnyObject>?,
         paramServerErrorCode:Int?,
         paramError:NSError?,
         paramNetworkErrorCode:NetworkErrorCode)
}

class NetworkError: NetworkErrorType {
    
    private(set) var response:NSURLResponse? = nil
    private(set) var error:NSError? = nil
    private(set) var serverErrorPayload:Dictionary<String,AnyObject>? = nil
    private(set) var serverErrorCode:Int? = nil
    var HTTPResponseErrorCode:Int? {
        
        return error?.code
    }
    private(set) var networkErrorCode:NetworkErrorCode? = nil
    
    required init(response:NSURLResponse?,
         paramServerErrorPayload:Dictionary<String,AnyObject>?,
         paramServerErrorCode:Int?,
         paramError:NSError?,
         paramNetworkErrorCode:NetworkErrorCode) {
        
        self.response = response
        error = paramError
        serverErrorPayload = paramServerErrorPayload
        serverErrorCode = paramServerErrorCode
    }
}

protocol NetworkErrorHandling {
    
    
}

