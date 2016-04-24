//
//  ImageViewNetworkingExtensions.swift
//  Wipro
//
//  Created by Mladen Despotovic on 14/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

var AddedTaskKey = "taskKey"
var ActivityCountKey = "activityCountKey"

extension UIImageView {
    
    func setImage(URLString:String,
                  paramPlaceholderImage:UIImage,
                  paramNetworkingCLient:NetworkingClient,
                  requestErrorClosure:RequestError) {
        
        image = paramPlaceholderImage
        guard let imageURL:NSURL = NSURL.init(string: URLString) else {
            
            return
        }
        guard let URLRequest:NSURLRequest? = NSURLRequest.init(URL: imageURL,
                                                         cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy,
                                                         timeoutInterval: DefaultTimeout) else {
            return
        }
        let cachedResponse:NSCachedURLResponse? = NSURLCache.sharedURLCache().cachedResponseForRequest(URLRequest!)
        
        if addedDataDask != nil {
            
            addedDataDask!.cancel()
        }
        
        let simpleSession:NSURLSession? = NSURLSession.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        if addedDataDask != nil {
            
            objc_removeAssociatedObjects(addedDataDask)
        }
        
        if cachedResponse != nil {
            
            image = UIImage.init(data: cachedResponse!.data)!.scaleToSizeOf(self)
            self.setNeedsLayout()
            requestErrorClosure(error: nil)
        }
        else {
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            activityCount = activityCount! + 1

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
                
                var dataTask:NSURLSessionDataTask? = nil
                dataTask = simpleSession?.dataTaskWithRequest(URLRequest!, completionHandler: { [weak self] (data:NSData?, response:NSURLResponse?, error:NSError?) in
                    
                    guard self != nil else {
                        return
                    }
                    
                    if error == nil {
                        
                        let cachedUrlResponse = NSCachedURLResponse.init(response: response!, data: data!)
                        NSURLCache.sharedURLCache().storeCachedResponse(cachedUrlResponse, forRequest: URLRequest!)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            self!.image = UIImage.init(data: data!)!.scaleToSizeOf(self!)
                            self!.setNeedsLayout()
                            self!.activityCount = self!.activityCount! - 1
                            if self!.activityCount <= 0 {
                             
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            }
                        })
                    }
                    else {
                        
                        let networkError = NetworkError.init(response: nil,
                            paramServerErrorPayload: nil,
                            paramServerErrorCode: nil,
                            paramError: error,
                            paramNetworkErrorCode: NetworkErrorCode.NetworkError)
                        
                        requestErrorClosure(error: networkError)
                    }
                })
                
                self.addedDataDask = dataTask
                dataTask?.resume()
            })
        }
        
        
    }
    
    var addedDataDask: NSURLSessionDataTask? {
        
        get {
            
            return objc_getAssociatedObject(self, &AddedTaskKey) as? NSURLSessionDataTask
        }
        
        set {
            
            if let newValue = newValue {
                
                objc_setAssociatedObject(
                    self,
                    &AddedTaskKey,
                    newValue as NSURLSessionDataTask?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }

    var activityCount: Int? {
        
        get {
            
            return objc_getAssociatedObject(self, &ActivityCountKey) as? Int
        }
        
        set {
            
            if let newValue = newValue {
                
                objc_setAssociatedObject(
                    self,
                    &ActivityCountKey,
                    newValue as Int?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}


extension UIImage {
    
    func scaleToSizeOf(paramView:UIView) -> UIImage? {
        
        guard paramView.bounds.size.height > 0 && paramView.bounds.size.width > 0 else {
            
            return nil
        }
        
        let widthRatio:CGFloat = size.width / paramView.bounds.size.width
        let heightRatio:CGFloat = size.height / paramView.bounds.size.height
        
        if widthRatio > 1 && widthRatio > heightRatio {
            
            let newSize = CGSizeMake(paramView.bounds.size.width, self.size.height / widthRatio)
            return self.scaleToSize(newSize)
        }
        else if heightRatio > 1 && heightRatio > widthRatio {
            
            let newSize = CGSizeMake(self.size.width / heightRatio, paramView.bounds.size.height)
            return self.scaleToSize(newSize)
        }
        else {
            
            return self
        }
    }
    
    func scaleToSize(newSize:CGSize) -> UIImage? {
        
        let scaleSelector:Selector = #selector(NSDecimalNumberBehaviors.scale)
        if UIScreen.mainScreen().respondsToSelector(scaleSelector) {
            
            UIGraphicsBeginImageContextWithOptions(newSize, true, UIScreen.mainScreen().scale)
        }
        else {
            
            UIGraphicsBeginImageContext(size)
        }
        
        drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


