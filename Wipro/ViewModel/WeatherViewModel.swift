//
//  WeatherViewModel.swift
//  Wipro
//
//  Created by Mladen Despotovic on 23/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import UIKit

class WeatherViewModel {
    
    unowned var viewController:UIViewController
    unowned var weatherLogic:WeatherLogic
    
    init(viewController:UIViewController, logic:WeatherLogic) {
        
        self.viewController = viewController
        weatherLogic = logic
    }
    
    func applyModel(headerLabel:UILabel)  {
        
        if weatherLogic.city != nil {
            
            headerLabel.text = weatherLogic.city!.city! + ", " + weatherLogic.city!.country!
        }
    }
    
    func applyModel(cell:UITableViewCell, indexPath:NSIndexPath) {
        
        let weatherCell = cell as! WeatherTableViewCell
        let index = (indexPath.section + 1) * indexPath.row
        
        guard weatherLogic.weatherArray != nil else {
            return
        }
        let weather = weatherLogic.weatherArray![index]
        weatherCell.date?.text = weather.date?.timeString()
        let relativeTemperature = String(format: "%.1f", weather.temperature! - 273)
        weatherCell.temperature?.text = relativeTemperature
        weatherCell.weatherDescription?.text = weather.weatherDescription
    }
    
    
}
