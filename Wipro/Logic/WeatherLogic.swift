//
//  WeatherLogic.swift
//  Wipro
//
//  Created by Mladen Despotovic on 23/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation
import CoreLocation

typealias CurrentLocationClosure = (location:CLLocation?) -> ()
typealias InitClosure = (success:Bool) -> Void

class WeatherLogic: NSObject,CLLocationManagerDelegate {
    
    lazy var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    private(set) var locationCompletionClosure:CurrentLocationClosure? = nil;
    private(set) var initCompletionClosure:InitClosure? = nil;
    lazy var dataController = WeatherDataController.init()
    var city:City? = nil
    var weatherArray:Array<Weather>? = nil
    private var callingAPI:Bool = false
    private(set) var numberOfItems:Dictionary<String,Int>? = [:]
    typealias itemsTuple = (date: String, number: Int)
    var itemsPerSections:Array<(String,Int)> = []
    
    override init() {
        
        super.init()
    }
    
    convenience init(completion:InitClosure) {
        
        self.init()
        locationManager.distanceFilter = 500
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        initCompletionClosure = completion
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        let count = locations.count
        let location:CLLocation? = locations[count-1]
        
        if location != nil && callingAPI == false {
            
            callingAPI = true
            self.dataController.getWeather((location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!) { [weak self] (city, weatherArray, urlResponse, errorHandler, canceled) in
                
                self?.callingAPI = false
                self?.city = city
                self?.weatherArray = weatherArray
                
                self?.countElements()
                
                if errorHandler != nil && canceled == false && self?.initCompletionClosure != nil {
                    
                    self?.initCompletionClosure!(success: true)
                }
                else {
                    
                    self?.initCompletionClosure!(success: false)
                }
            }
        }

    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status != CLAuthorizationStatus.Denied {
            
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        
    }
    
    func place(location:CLLocation, completionClosure:(name:String?) -> ()) {

        geocoder .reverseGeocodeLocation(location) { (placemarks:[CLPlacemark]?, error:NSError?) in
            
            if error != nil {
                
                completionClosure(name: nil)
            }
            else {
                
                if placemarks != nil {
                    
                    let count = placemarks!.count
                    if count == 0 {
                        
                        completionClosure(name: nil)
                    }
                    completionClosure(name:placemarks![count-1].locality)
                }
                else {
                    
                    completionClosure(name: nil)
                }
            }
        }
    }
    
    func countElements() {
    
        var numberOfItems:Dictionary<String,Int>? = [:]
        var number:Int = 0
        var shortDate:String = weatherArray![0].dateString!
        for (_,weather) in weatherArray!.enumerate() {
            
            let newShortDate = weather.dateString
            if newShortDate != shortDate {
                
                numberOfItems![shortDate] = number
                shortDate = newShortDate!
                number = 0
            }
            number += 1
        }
        if number > 1 {
            
            numberOfItems![shortDate] = number
        }

        itemsPerSections = numberOfItems!.sort({ $0.0 < $1.0 })

    }
    
    func weather(section:Int) -> Weather? {
        
        var currentSection:Int = 0
        var index:Int = 0
        while currentSection <= section {
            
            let sectionTuple:itemsTuple = itemsPerSections[currentSection]
            index += sectionTuple.number
            currentSection += 1
        }
        
        return weatherArray![index-1]
    }
    
}

