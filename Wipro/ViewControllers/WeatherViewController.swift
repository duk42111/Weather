//
//  MainViewController.swift
//  Wipro
//
//  Created by Mladen Despotovic on 23/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UITableViewDataSource {

    private(set) var weatherViewModel:WeatherViewModel? = nil
    private(set) var weatherLogic:WeatherLogic? = nil
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var titleLabel:UILabel!
    
    override func viewDidLoad() {
        
        self.tableView.registerNib(UINib.init(nibName:"WeatherCell", bundle:nil), forCellReuseIdentifier: "WeatherCell")
        self.tableView.registerClass(NSClassFromString("UITableViewHeaderFooterView"), forHeaderFooterViewReuseIdentifier: "SectionView")
        self.tableView.estimatedRowHeight = 70
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.sectionHeaderHeight = 50
        weatherLogic = WeatherLogic.init(completion: { [weak self] (success) in
            
            guard self != nil else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self!.weatherViewModel?.applyModel(self!.titleLabel)
                self!.tableView.dataSource = self!
                self!.tableView.reloadData()
            })
            
            if self != nil {
                
                self!.tableView.reloadData()
            }
        })
        weatherViewModel = WeatherViewModel.init(viewController:self, logic:weatherLogic!)
    }

    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let item:(section:String,number:Int) = (weatherLogic?.itemsPerSections[section])!
        return item.number
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return (weatherLogic?.itemsPerSections.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell")
        weatherViewModel?.applyModel(cell!, indexPath: indexPath)
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let weather = weatherLogic?.weather(section)
        return "Date: " + (weather?.dateString)!
    }
}
