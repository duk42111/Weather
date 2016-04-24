//
//  Restaurant.swift
//  Wipro
//
//  Created by Mladen Despotovic on 18/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation

class City {
    
    private(set) var city:String? = nil;
    private(set) var country:String? = nil
    
    init(jsonResponse:Dictionary<String,AnyObject>?) {
        
        city = jsonResponse!["name"] as? String
        country = jsonResponse!["country"] as? String
    }
}
