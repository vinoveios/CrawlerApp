//
//  ViewController.swift
//  CrawlerApp
//
//  Created by Vinove on 08/11/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var eventTable: UITableView!
    let cellReuseIdentifier = "EventCell"
    let eventHelper:EventServiceHelper=EventServiceHelper()
    let headerHeight = 40.0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial setup
        self.initialSetup()
        
        // Load Events
        self.loadEvents()
    }
    
    // MARK: - Custom Methods
    func initialSetup() -> Void {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigationBackground"), for: .default)
        self.title = "Hangi Kanalda?"
    }
    
    func loadEvents(){
        eventHelper.loadEvent { (result:Bool) in
            if result{
                self.eventTable.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source/delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return CGFloat(self.headerHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let headerView=UIView()
        headerView.frame=CGRect(x: 0.0, y: 0.0, width: Double(tableView.frame.size.width), height:self.headerHeight)
        headerView.backgroundColor = UIColor.headerColor()
        
        let headerLabel=UILabel()
        headerLabel.frame=headerView.frame
        
        var eventArray=[Event]()
        eventArray = eventHelper.eventArray[section] as! [Event]
        headerLabel.text=eventArray[0].header
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont(name: "Lato-Heavy", size: 14)
        headerView.addSubview(headerLabel)
        return headerView
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  eventHelper.eventArray.count-1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (eventHelper.eventArray.object(at: section) as AnyObject).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! EventTableViewCell
        
        // Bind data with cell
        var eventArray=[Event]()
        eventArray = eventHelper.eventArray[indexPath.section] as! [Event]
        cell.setProjectData(model:eventArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

