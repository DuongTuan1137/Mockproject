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
    func setData(news : NewsStruct) {
        titleNews.text = news.title
        descriptionNews.text = news.publish_date + " by " + news.author + " on " + news.feed
        let url = URL(string: news.thumb_img)
        do {
            let data =  try Data(contentsOf: url!)
            imageNews.image = UIImage(data: data)
        } catch  {
            print("loi")
        }
    }
    
}
