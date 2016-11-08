//
//  Event.swift
//  CrawlerApp
//
//  Created by Vinove on 08/11/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit
class Event: NSObject {
    
    
    var title: String = ""
    var startDate :String = ""
    var eventIconUrl: String = ""
    var header : String = ""
    var catUrl : String = ""
    
}

typealias CompletionHandler = (_ success:Bool) -> Void

class EventServiceHelper {
    
    var eventArray:NSMutableArray = NSMutableArray()
    
    
    
    func loadEvent(completion: @escaping CompletionHandler)
    {
        
        let sporekrniRL = URL(string: "http://www.sporekrani.com/home")
        
        let htmlData = NSData(contentsOf: sporekrniRL!)
        
        if (htmlData == nil) {
           
            completion(false)
            return
        }
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
            
            // Html tags
            let headerHtmlString = "//header";
            let sportsImageHtmlString = "//div[@class='col-md-2 col-sm-2 col-xs-2']";
            let titleHtmlString = "//span[@class='notes_label']"
            let startDateHtmlString = "//span[@itemprop='startDate']"
            let channelimageString = "//div[@class='col-md-2 col-sm-2 col-xs-4 channel_icon']"
            
            
            // Array with in a header
            let headerArray = Parser?.search(withXPathQuery: headerHtmlString)
            let sportIconArray = Parser?.search(withXPathQuery: sportsImageHtmlString)
            let titleArray = Parser?.search(withXPathQuery:titleHtmlString)
            let startDateArray = Parser?.search(withXPathQuery:startDateHtmlString)
            let eventIconUrlArray = Parser?.search(withXPathQuery:channelimageString)
            
            
            var internalEventArray=[Event]()
            
            for i  in 0..<titleArray!.count{
                
                
                let event: Event = Event()
                
                // Header
                event.header = ((headerArray?[0] as! TFHppleElement).children[1] as! TFHppleElement).firstChild.content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                // Cat icon url
                if (sportIconArray?.count)!>0 {
                    let element:TFHppleElement = (sportIconArray?[i] as! TFHppleElement).children[1] as! TFHppleElement
                    event.catUrl = (element.children[5]  as! TFHppleElement).attributes["src"] as! String
                }
                
                
                // Title
                if (titleArray?.count)!>0{
                    event.title  =  ((titleArray?[i] as! TFHppleElement).firstChild.content as String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }
                //Time
                if (startDateArray?.count)!>0{
                    event.startDate=( (startDateArray?[i] as! TFHppleElement).firstChild.content as String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }
                // Channel icon
                if  (eventIconUrlArray?.count)!>0 {
                    
                    
                    event.eventIconUrl = ((eventIconUrlArray?[i] as! TFHppleElement).children[1] as! TFHppleElement).attributes["src"] as! String
                }
                internalEventArray.append(event)
            }
            
            eventArray.add(internalEventArray)
        }
        
        if eventArray.count==0 {
            completion(false)
        }else{
            completion(true)
        }
        
        
        
    }
    
    
}


