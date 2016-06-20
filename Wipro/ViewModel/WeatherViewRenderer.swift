//
//  WeatherViewRenderer.swift
//  Wipro
//
//  Created by Mladen Despotovic on 23/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import UIKit

class WeatherViewRenderer {
    
    unowned var viewController:UIViewController
    unowned var weatherViewModel:WeatherViewModel
    
    init(viewController:UIViewController, logic:WeatherViewModel) {
        
        self.viewController = viewController
        weatherViewModel = logic
    }
    
    func applyModel(headerLabel:UILabel)  {
        
        if weatherViewModel.city != nil {
            
            headerLabel.text = weatherViewModel.city!.city! + ", " + weatherViewModel.city!.country!
        }
    }
    
    func applyModel(cell:UITableViewCell, indexPath:NSIndexPath) {
        
        let weatherCell = cell as! WeatherTableViewCell
        let index = (indexPath.section + 1) * indexPath.row
        
        guard weatherViewModel.weatherArray != nil else {
            return
        }
        let weather = weatherViewModel.weatherArray![index]
        weatherCell.date?.text = weatherViewModel.dateString(index)
        weatherCell.temperature?.text = weatherViewModel.relativeTemperatureString(index)
        weatherCell.weatherDescription?.text = weather.weatherDescription
    }
    
    
}
