//
//  NewsTableViewCell.swift
//  MockProject
//
//  Created by AnhDCT on 9/11/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var descriptionNews: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func setDescriptionNews(_ news: NewsStruct) {
        let start = news.publish_date
        let currentDate  = Date()
        let dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let startDate = dateFormatter.date(from: start)
        let units = Set<Calendar.Component>([.year,.month,.day,.weekOfYear])
        let components = Calendar.current.dateComponents(units, from: startDate!, to: currentDate)
        switch news.author {
        case "":
            if components.year! > 0 {
                descriptionNews.text = "\(components.year! * 365 + components.month! * 30 + components.weekOfYear! * 7 + components.day!)" + " days ago on " + news.feed
            } else if components.month! > 0 {
                descriptionNews.text = "\(components.month! * 30 + components.weekOfYear! * 7 + components.day!)" + " days ago on " + news.feed
            } else if components.weekOfYear! > 0 {
                descriptionNews.text = "\(components.weekOfYear! * 7 + components.day!)" + " days ago on " + news.feed
            } else if components.day! > 0 {
                descriptionNews.text = "\(components.day!)" + " days ago on " + news.feed
            }
        default:
            if components.year! > 0 {
                descriptionNews.text = "\(components.year! * 365 + components.month! * 30 + components.weekOfYear! * 7 + components.day!)" + " days ago by " + news.author + " on " + news.feed
            } else if components.month! > 0 {
                descriptionNews.text = "\(components.month! * 30 + components.weekOfYear! * 7 + components.day!)" + " days ago by " + news.author + " on " + news.feed
            } else if components.weekOfYear! > 0 {
                descriptionNews.text = "\(components.weekOfYear! * 7 + components.day!)" + " days ago by " + news.author + " on " + news.feed
            } else if components.day! > 0 {
                descriptionNews.text = "\(components.day!)" + " days ago by " + news.author + " on " + news.feed
            }
        }
    }
    
    func setData(news : NewsStruct) {
        
        setDescriptionNews(news)

        titleNews.text = news.title
        
        guard let url = URL(string: news.thumb_img) else {return}
        do {
            let data =  try Data(contentsOf: url)
            imageNews.image = UIImage(data: data)
        } catch  {
            print("loi")
        }
    }
    
}
