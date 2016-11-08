//
//  EventTableViewCell.swift
//  CrawlerApp
//
//  Created by Vinove on 08/11/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit
import SDWebImage
class EventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var catIcon: UIImageView!
    @IBOutlet weak var channelIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Data Binding
    func setProjectData(model: AnyObject) {
        let event = model as! Event
        self.titleLabel.text=event.title;
        self.startTimeLabel.text=event.startDate;
        self.catIcon.sd_setImage(with: URL(string:event.catUrl), placeholderImage: UIImage(named:"sportIcon"))
        self.channelIcon.sd_setImage(with: URL(string:event.eventIconUrl), placeholderImage: UIImage(named:"channelIcon"))

        
    }

}
