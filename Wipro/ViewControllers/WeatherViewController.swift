//
//  MainViewController.swift
//  Wipro
//
//  Created by Mladen Despotovic on 23/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UITableViewDataSource {

    private(set) var weatherViewRenderer:WeatherViewRenderer? = nil
    private(set) var weatherViewModel:WeatherViewModel? = nil
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var titleLabel:UILabel!
    
    override func viewDidLoad() {
        
        self.tableView.registerNib(UINib.init(nibName:"WeatherCell", bundle:nil), forCellReuseIdentifier: "WeatherCell")
        self.tableView.registerClass(NSClassFromString("UITableViewHeaderFooterView"), forHeaderFooterViewReuseIdentifier: "SectionView")
        self.tableView.estimatedRowHeight = 70
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.sectionHeaderHeight = 50
        weatherViewModel = WeatherViewModel.init(completion: { [weak self] (success) in
            
            guard self != nil else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self!.weatherViewRenderer?.applyModel(self!.titleLabel)
                self!.tableView.dataSource = self!
                self!.tableView.reloadData()
            })
            
            if self != nil {
                
                self!.tableView.reloadData()
            }
        })
        weatherViewRenderer = WeatherViewRenderer.init(viewController:self, logic:weatherViewModel!)
    }

    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let item:(section:String,number:Int) = (weatherViewModel?.itemsPerSections[section])!
        return item.number
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return (weatherViewModel?.itemsPerSections.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell")
        weatherViewRenderer?.applyModel(cell!, indexPath: indexPath)
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let weather = weatherViewModel?.weather(section)
        return "Date: " + (weather?.dateString)!
    }
}
