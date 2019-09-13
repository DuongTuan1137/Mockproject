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
        nameEvents.text = events.name
        descriptionEvents.text = events.description_html
        dateEvents.text = events.schedule_start_date

    }
    

}
