//
//  Session.swift
//  Wipro
//
//  Created by Mladen Despotovic on 11/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation

enum HTTPMethodName:String {
    
    case Get = "GET", Post = "POST", Delete = "DELETE", Put = "PUT"
}

typealias RequestCompletion = (jsonResponseDictionary:Dictionary<String,AnyObject>?, urlResponse:NSURLResponse?, error:NetworkError?, canceled:Bool) -> ()
typealias RequestProgress = (percentage:Float) -> ()
typealias RequestError = (error:NetworkErrorType?) -> ()

protocol CancelableSession:AnyObject {
    
    var requestCompletionClosure:RequestCompletion {get set}
    var requestProgressClosure:RequestProgress? {get set}
    
    var sessionRequest:NSURLRequest? {get}
    var networkingConfiguration:NetworkingConfiguration {get}
    var sessionConfiguration:NSURLSessionConfiguration {get}
    var session:NSURLSession? {get}

    init(URL:NSURL,
         paramNetworkingConfiguration:NetworkingConfiguration,
         paramHTTPMethodString:HTTPMethodName,
         paramRequestParamaters:Dictionary<String,String>?,
         paramCompletionClosure:RequestCompletion,
         paramProgressClosure:RequestProgress?)
    
    func setHeaders(headers:Dictionary<String,String>) -> ()
    func cancel() -> ()
    func startSession() -> ()
}


class Session: CancelableSession {
    
    var requestCompletionClosure:RequestCompletion = { (jsonResponseDictionary:Dictionary<String,AnyObject>?, urlResponse:NSURLResponse?, error:NetworkErrorType?, canceled:Bool) in }
    var requestProgressClosure:RequestProgress? = nil
    
    private(set) var sessionRequest:NSURLRequest? = nil
    private(set) var networkingConfiguration = NetworkingConfiguration.init()
    private(set) var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    private(set) var session:NSURLSession? = nil;
    
    var requestParameters:Dictionary<String,String>? = nil;
    var methodName:HTTPMethodName = HTTPMethodName.Get
    var headers:Dictionary<String,String>? = nil
    
    var mutableRequest:NSMutableURLRequest? = nil;
    var methodURL:NSURL? = nil;
    
    let defaultTimeout:NSTimeInterval = 10
    let defaultCachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
    
    init() {}
    
    required init(URL:NSURL,
                  paramNetworkingConfiguration:NetworkingConfiguration,
                  paramHTTPMethodString:HTTPMethodName,
                  paramRequestParamaters:Dictionary<String,String>?,
                  paramCompletionClosure:RequestCompletion,
                  paramProgressClosure:RequestProgress?) {
        
        methodName = paramHTTPMethodString
        requestParameters = paramRequestParamaters
        networkingConfiguration = paramNetworkingConfiguration
        requestCompletionClosure = paramCompletionClosure
        requestProgressClosure = paramProgressClosure
        
        sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPAdditionalHeaders = networkingConfiguration.additionalHeaders
        sessionConfiguration.timeoutIntervalForRequest = networkingConfiguration.timeoutInterval
        
        session = NSURLSession.init(configuration: sessionConfiguration)
        
        // parameter string will be doen only for GET, for this purpose there is no implementation of body paramter serialization for POST
        methodURL = nil;
        mutableRequest = nil;
        sessionRequest = nil;
        
        if paramRequestParamaters != nil && paramHTTPMethodString == HTTPMethodName.Get  {
            
            if let URLString = String.queryString(paramRequestParamaters!) {
                
                methodURL = NSURL.init(string: URLString, relativeToURL: URL)!
                let wholePath = URL.description + URLString
                
                methodURL = NSURL.init(string: wholePath)
                
                print(wholePath)
            }
        }
        
        if methodURL != nil {
            
            mutableRequest = NSMutableURLRequest(URL:methodURL!, cachePolicy:defaultCachePolicy, timeoutInterval:defaultTimeout)
            mutableRequest!.HTTPMethod = paramHTTPMethodString.rawValue;
            sessionRequest = mutableRequest!.copy() as? NSURLRequest
            
            setHeaders(networkingConfiguration.defaultHeaders)
        }
    }
    
    
    func setHeaders(headers:Dictionary<String,String>) -> () {
        
        for (key,value) in headers {
            
            mutableRequest!.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    
    func cancel() -> () {
        
        if session != nil {
            
            session!.invalidateAndCancel()
        }
        requestCompletionClosure(jsonResponseDictionary: nil, urlResponse: nil, error: nil, canceled: true)
    }
    
    func startSession() -> () {
        
        guard session != nil else {
            
            return
        }
        
        let dataTask:NSURLSessionDataTask = session!.dataTaskWithRequest(sessionRequest!, completionHandler: {[weak self] (data:NSData?, response:NSURLResponse?, error:NSError?) in
            
            guard self != nil else {
                return
            }
            
            if error != nil {
        
                let networkError = NetworkError.init(response: response!,
                    paramServerErrorPayload: nil,
                    paramServerErrorCode: nil,
                    paramError: error,
                    paramNetworkErrorCode: NetworkErrorCode.NetworkError)
                self!.requestCompletionClosure(jsonResponseDictionary:nil,urlResponse:response,error:networkError, canceled: false)
            }
            else {
                
                var responseObject:Dictionary<String, AnyObject>?
                var networkError:NetworkError? = nil;
                do {
                    
                    responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>
                }
                catch {
                    
                    networkError = NetworkError.init(response: response!,
                        paramServerErrorPayload: nil,
                        paramServerErrorCode: nil,
                        paramError: nil,
                        paramNetworkErrorCode: NetworkErrorCode.ParsingError)
                }

                self!.requestCompletionClosure(jsonResponseDictionary:responseObject,urlResponse:response,error:networkError, canceled: false)
            }
        })

        dataTask.resume()
    }
}


class JSONSession: Session {
    
    let DefaultHeaderContentTypeKey = "Content-Type"
    let DefaultHeaderContentTypeValue = "application/json"
    
    required init(URL:NSURL,
         paramNetworkingConfiguration:NetworkingConfiguration,
         paramHTTPMethodString:HTTPMethodName,
         paramRequestParamaters:Dictionary<String,String>?,
         paramCompletionClosure:RequestCompletion,
         paramProgressClosure:RequestProgress?) {
        
        super.init(URL: URL,
                   paramNetworkingConfiguration: paramNetworkingConfiguration,
                   paramHTTPMethodString: paramHTTPMethodString,
                   paramRequestParamaters: paramRequestParamaters,
                   paramCompletionClosure: paramCompletionClosure,
                   paramProgressClosure: paramProgressClosure)
        
        let JSONContentType:[String:String] = [DefaultHeaderContentTypeKey:DefaultHeaderContentTypeValue]
        setHeaders(JSONContentType)
    }
}






