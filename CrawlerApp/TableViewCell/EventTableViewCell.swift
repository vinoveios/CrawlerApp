//
//  EventTableViewCell.swift
//  CrawlerApp
//
//  Created by Varun Tyagi on 07/11/16.
//  Copyright © 2016 Varun Tyagi. All rights reserved.
//

import UIKit
import SDWebImage
class EventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var sportIcon: UIImageView!
    @IBOutlet weak var contentIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProjectData(model: AnyObject) {
        let event = model as! Event
        self.titleLabel.text=event.title;
        self.startTimeLabel.text=event.startDate;
        self.sportIcon.sd_setImage(with: URL(string:event.sportUrl), placeholderImage: UIImage(named:"sportIcon"))
        self.contentIcon.sd_setImage(with: URL(string:event.EventIconUrl), placeholderImage: UIImage(named:"channelIcon"))

        
    }

}
