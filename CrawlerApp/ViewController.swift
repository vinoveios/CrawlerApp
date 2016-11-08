//
//  ViewController.swift
//  CrawlerApp
//
//  Created by Vinove on 08/11/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit
import SystemConfiguration
import MBProgressHUD

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    
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
        
        eventTable.tableFooterView=UIView()
    }
    
    func loadEvents(){
        if self.isInternetAvailable(){
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Loading"
            
            eventHelper.loadEvent { (result:Bool) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if result{
                    self.eventTable.reloadData()
                }else{
                    self.showAlert()
                }
            }
        }
        else{
            self.showAlert()
        }
        
    }
    

     // MARK: - Table view data source/delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return CGFloat(self.headerHeight)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        return self.getHeaderForSection(section,width: Double(tableView.frame.size.width))
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
    // Table Header
    func getHeaderForSection(_ section:Int,width:Double) -> UIView {
        let headerView=UIView()
        let headerLabel=UILabel()
        var eventArray=[Event]()
        
        headerView.frame=CGRect(x: 0.0, y: 0.0, width: width, height:self.headerHeight)
        headerView.backgroundColor = UIColor.headerColor()
        headerLabel.frame=headerView.frame
        eventArray = eventHelper.eventArray[section] as! [Event]
        headerLabel.text=eventArray[0].header
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont(name: "Lato-Heavy", size: 14)
        headerView.addSubview(headerLabel)
        return headerView
        
        
    }

    
     // MARK: - Reachiblity
    func showAlert() -> Void {
        let alert = UIAlertController(title: "Warning!", message: "Unable to load data - please check your network connection and try again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            
            self.loadEvents()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

