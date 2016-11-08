//
//  Utility.swift
//  CrawlerApp
//
//  Created by Varun Tyagi on 08/11/16.
//  Copyright © 2016 Varun Tyagi. All rights reserved.
//

import UIKit

extension Data {
    var stringValue: String? {
        return String(data: self, encoding: .utf8)
    }
    var base64EncodedString: String? {
        return base64EncodedString(options: .lineLength64Characters)
    }
}
extension String {
    var utf8StringEncodedData: Data? {
        return data(using: .utf8)
    }
    var base64DecodedData: Data? {
        return Data(base64Encoded: self, options: .ignoreUnknownCharacters)
    }
    
}

extension UIColor {
    
    // Event list header color
    class func headerColor() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 214.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    }
    
}

class Utility: NSObject {

}
