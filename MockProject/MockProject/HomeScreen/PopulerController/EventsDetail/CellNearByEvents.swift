//
//  CellNearByEvents.swift
//  MockProject
//
//  Created by AnhDCT on 9/17/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class CellNearByEvents: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(events: Event){
        guard let url = URL(string: events.photo ?? "") else {return}
        do {
            let data =  try Data(contentsOf: url)
            image.image = UIImage(data: data)
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
            labelDate.text = events.schedule_start_date! + " - \(String(describing: events.going_count!)) người tham gia"
        } else {
            labelDate.text = events.schedule_end_date! + " - \(String(describing: events.going_count!)) người tham gia"
        }
        labelTitle.text = events.name
        labelDescription.text = events.description_html
    }

}
