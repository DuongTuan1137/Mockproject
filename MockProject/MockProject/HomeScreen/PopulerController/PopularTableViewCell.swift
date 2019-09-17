//
//  PopularTableViewCell.swift
//  MockProject
//
//  Created by AnhDCT on 9/11/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class PopularTableViewCell: UITableViewCell {
    @IBOutlet weak var popularImage: UIImageView!
    @IBOutlet weak var nameEvents: UILabel!
    @IBOutlet weak var descriptionEvents: UILabel!
    @IBOutlet weak var dateEvents: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setupData(events : EventsStruct){
        guard let url = URL(string: events.photo ?? "") else {return}
        do {
            let data =  try Data(contentsOf: url)
            popularImage.image = UIImage(data: data)
        } catch  {
            print("loi")
        }
        
        guard let start = events.schedule_start_date else {return}
        let currentDate  = Date()
        let dateFormat = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let startDate = dateFormatter.date(from: start) else {return}
        if startDate < currentDate {
            dateEvents.text = events.schedule_start_date! + " - \(String(describing: events.going_count!)) người tham gia"
        } else {
            dateEvents.text = events.schedule_end_date! + " - \(String(describing: events.going_count!)) người tham gia"
        }
        nameEvents.text = events.name
        descriptionEvents.text = events.description_html
    }
    

}
