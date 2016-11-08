//
//  Event.swift
//  CrawlerApp
//
//  Created by Varun Tyagi on 07/11/16.
//  Copyright © 2016 Varun Tyagi. All rights reserved.
//

import UIKit

class Event: NSObject {

    
    var title: String = ""
    var address : String = ""
    var fullDate :String = ""
    var url : String = ""
    var startDate :String = ""
    var  EventIconUrl: String = ""
    var header : String = ""
    var sportUrl : String = ""
    
}

typealias CompletionHandler = (_ success:Bool) -> Void

class EventServiceHelper {
    var eventArray = [Event]()
    

    var  arrToday = [Event]()
    var  arrTomorrow = [Event]()
    var  arrDayAfterTomro = [Event]()
    
    func loadEvent(completion: @escaping CompletionHandler)
    {
        
        let sporekrniRL = URL(string: "http://www.sporekrani.com/home")
        
        let htmlData = NSData(contentsOf: sporekrniRL!)
        
        let asumedUrl =  NSString(data: htmlData! as Data, encoding: String.Encoding.utf8.rawValue)
        
        let liTagArray
            = asumedUrl?.components(separatedBy: "<div class=\"match-item last-item style1\">")
        
        let liTagMutableArray:NSMutableArray=NSMutableArray()
        liTagMutableArray.addObjects(from:  liTagArray!)
        
        liTagMutableArray.removeObject(at: 0)
        
        let litagHtmlArray:NSMutableArray=NSMutableArray()
        
        for i in 0 ..< liTagMutableArray.count  {
            litagHtmlArray.add("<!DOCTYPE html><body> <div class=\"match-item last-item style1\">\(liTagMutableArray[i])</body></html>")
        }
        
        
        
        for j in  0..<litagHtmlArray.count
        {
            
            // li tag data
            let htmlData = (litagHtmlArray[j] as! String).utf8StringEncodedData
            
            // TFHupple object
            let Parser = TFHpple(htmlData: htmlData as Data!)
           
            // html tag string to parse
            let headerHtmlString = "//header";
            let sportsImageHtmlString = "//div[@class='col-md-2 col-sm-2 col-xs-2']";
            
            let titleHtmlString = "//span[@class='notes_label']"
            let startDateHtmlString = "//span[@itemprop='startDate']"
            let addressHtmlString = "//div[@itemprop='broadcastOfEvent']"
            let channelimageString = "//div[@class='col-md-2 col-sm-2 col-xs-4 channel_icon']"
            
            
            // array after parsing tags
            let headerArray = Parser?.search(withXPathQuery: headerHtmlString)
            let sportIconArray = Parser?.search(withXPathQuery: sportsImageHtmlString)
            let titleArray = Parser?.search(withXPathQuery:titleHtmlString)
            let startDateArray = Parser?.search(withXPathQuery:startDateHtmlString)
            let addressArray = Parser?.search(withXPathQuery:addressHtmlString)
            let eventIconUrlArray = Parser?.search(withXPathQuery:channelimageString)
           

            
             for i  in 0..<titleArray!.count{
                
               
                let event: Event = Event()
                
                // header
                event.header = ((headerArray?[0] as! TFHppleElement).children[1] as! TFHppleElement).firstChild.content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                // sport url
                if (sportIconArray?.count)!>0 {
                    let element:TFHppleElement = (sportIconArray?[i] as! TFHppleElement).children[1] as! TFHppleElement
                    event.sportUrl = (element.children[5]  as! TFHppleElement).attributes["src"] as! String
                }else{
                    event.sportUrl = ""
                }
                
                
                // title of event
                if (titleArray?.count)!>0{
                    event.title  =  ((titleArray?[i] as! TFHppleElement).firstChild.content as String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }else{
                    event.title = ""
                }
                
                //time of event
                if (startDateArray?.count)!>0{
                    event.startDate=( (startDateArray?[i] as! TFHppleElement).firstChild.content as String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }else{
                    event.startDate = ""
                }
                // only date of event
                if  (startDateArray?.count)!>0 {
                    event.fullDate=((startDateArray?[i] as! TFHppleElement).attributes["content"] as! String).components(separatedBy:"T").first!
                    
                }else{
                    event.fullDate = ""
                }
                
                // address or broadcast of event
                if  (addressArray?.count)!>0 {
                    
                    
                    event.address=String(describing:  ((addressArray?[i] as! TFHppleElement).children[4] as! TFHppleElement).content ).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }else{
                    event.address = ""
                }
                
                // channel icon
                if  (eventIconUrlArray?.count)!>0 {
                    
                    
                    event.EventIconUrl = ((eventIconUrlArray?[i] as! TFHppleElement).children[1] as! TFHppleElement).attributes["src"] as! String
                }else{
                    event.EventIconUrl = ""
                }
                
                eventArray.append(event)
            }
            
        }
        
        if eventArray.count==0 {
             completion(false)
        }else{
             completion(true)
        }
        
        
        for event in eventArray {
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd";
            
            if event.fullDate == format.string(from: Date()) {
                arrToday.append(event)
            }
            
            
            let tomorrow = NSCalendar.current.date(byAdding: .day, value: 1, to: Date())
            
            if event.fullDate == format.string(from: tomorrow!) {
                arrTomorrow.append(event)
            }
            
            
            let dayAftertomorrow = NSCalendar.current.date(byAdding: .day, value: 2, to: Date())
            
            
            if event.fullDate == format.string(from: dayAftertomorrow!) {
                arrDayAfterTomro.append(event)
            }
            
            }
        
     }
    
    
}


