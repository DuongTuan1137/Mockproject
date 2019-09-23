//
//  BrowseTableViewCell.swift
//  MockProject
//
//  Created by AnhDCT on 9/23/19.
//  Copyright © 2019 AnhDCT. All rights reserved.
//

import UIKit

class BrowseTableViewCell: UITableViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell(category: CategoryStruct) {
        genreLabel.text = category.name
    }

    

}
