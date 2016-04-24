//
//  DataController.swift
//  Wipro
//
//  Created by Mladen Despotovic on 18/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation
import CoreLocation

class DataController {
    
    private(set) var networkingClient = NetworkingClient.init(configuration: NetworkingConfiguration.init())
    var mutableParameters:Dictionary<String,AnyObject>? = nil
    private(set) var session:CancelableSession? = nil;
    
    init () {}
    
    init(networkingClient: NetworkingClient, mutableParameters:Dictionary<String,AnyObject>?) {
        
        self.networkingClient = networkingClient
        self.mutableParameters = mutableParameters
    }
}


typealias WeatherCompletion = (city:City?, weatherArray:Array<Weather>?, urlResponse:NSURLResponse?, errorHandler:ErrorHandling?, canceled:Bool) -> ()
let weatherMethodPath = "/data/2.5/forecast"

class WeatherDataController: DataController {
    
    func getWeather(latitude:Double, longitude:Double, weatherCompletion:WeatherCompletion) {
        
        let latitude = String(format:"%6f",latitude)
        let longitude = String(format:"%6f",longitude)
        
        self.session = networkingClient .fetch(weatherMethodPath,
                                requestType: RequestType.JSON,
                                HTTPRequestMethod: HTTPMethodName.Get,
                                parameters: ["lat":latitude, "lon":longitude, "appid":"38ccd497ae1301feaf803455d1a30b39"],
                                completion: { (jsonResponseDictionary:Dictionary<String,AnyObject>?, urlResponse:NSURLResponse?, error:NetworkErrorType?, canceled:Bool) in
            
                                    var errorHandler:ErrorHandler? = nil
                                    var weatherArray:Array<Weather>? = nil
                                    var city:City? = nil
                                    
                                    if error != nil {
                                        
                                        errorHandler = ErrorHandler.init(error: error!)
                                    }
                                    else {
                                        
                                        weatherArray = Weather.weatherArray((jsonResponseDictionary!["list"] as? Array<AnyObject>)!)
                                        let cityResponse:Dictionary<String,AnyObject>? = jsonResponseDictionary!["city"] as? Dictionary<String,AnyObject>
                                        city = City.init(jsonResponse: cityResponse)
                                    }
                                    
                                    weatherCompletion(city: city,
                                        weatherArray: weatherArray,
                                        urlResponse: urlResponse,
                                        errorHandler: errorHandler,
                                        canceled: canceled)
                
            }) { (percentage) in
                
        }
    }
    
}
