//
//  Weather.swift
//  Wipro
//
//  Created by Mladen Despotovic on 20/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation

class Weather {
    
    private(set) var temperature:Float? = nil
    private(set) var weatherDescription:String? = nil
    private(set) var date:NSDate? = nil
    
    init(jsonResponse:Dictionary<String,AnyObject>?) {
        
        let main:Dictionary<String,AnyObject>? = jsonResponse!["main"] as? Dictionary<String,AnyObject>
        temperature = main!["temp"] as? Float
        let weatherArray:Array<AnyObject>? = jsonResponse!["weather"] as? Array<AnyObject>
        let weather:Dictionary<String,AnyObject>? = weatherArray![0] as? Dictionary<String,AnyObject>
        weatherDescription = weather!["description"] as? String
        let dateString:String? = jsonResponse!["dt_txt"] as? String
        date = NSDate.dateFrom(dateString!)
    }
    
    var dateString:String? {
        
        get {
        
            return date?.shortDateString()
        }
    }
    
    var timeString:String? {
        
        get {
            
            return date?.timeString()
        }
    }
    
}

extension Weather {
    
    class func weatherArray(jsonResponse:Array<AnyObject>) -> Array<Weather>? {
        
        var arrayOfWeather:Array<Weather>? = []
        for (_,weatherResponseDictionary) in jsonResponse.enumerate() {
            
            arrayOfWeather?.append(Weather.init(jsonResponse: weatherResponseDictionary as? Dictionary<String,AnyObject>))
        }
        
        return arrayOfWeather
    }
    
}