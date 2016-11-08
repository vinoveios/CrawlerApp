//
//  ViewController.swift
//  CrawlerApp
//
//  Created by Varun Tyagi on 04/11/16.
//  Copyright © 2016 Varun Tyagi. All rights reserved.
//

import UIKit




class ViewController: UIViewController {

    @IBOutlet weak var eventTable: UITableView!
    let cellReuseIdentifier = "EventCell"
    let   eventHelper:EventServiceHelper=EventServiceHelper()
    let headerHeight = 40.0
    
    let _objects:NSMutableArray = []
    
    let  arrToday:NSMutableArray = []
    let  arrTomorrow:NSMutableArray = []
    let  arrDayAfterTomro:NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // initial setup
        self.initialSetup()
        self.loadEvents()
    }
    
    func initialSetup() -> Void {
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

     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
     let headerView=UIView()
        headerView.frame=CGRect(x: 0.0, y: 0.0, width: Double(tableView.frame.size.height), height:self.headerHeight)
        headerView.backgroundColor = UIColor.headerColor()
        return headerView
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventHelper.eventArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath) as! EventTableViewCell
        
        // bind data with cell
        cell.setProjectData(model:eventHelper.eventArray[indexPath.row])

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
   
    func ReturnNameInTurkish(dateString:String) -> String {
       
        if dateString == "Sunday" {
            return  "Pazar"
        }else if dateString == "Monday"{
            return "Pazartesi"
        }else if dateString=="Tuesday"{
            return "Salı"
        }else if dateString=="Wednesday"{
            return "Çarşamba"
        }else if dateString=="Thursday"{
            return "Perşembe"
        }else if dateString=="Friday"{
            return "Cuma"
        }else {
            return "Cumartesi"
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

