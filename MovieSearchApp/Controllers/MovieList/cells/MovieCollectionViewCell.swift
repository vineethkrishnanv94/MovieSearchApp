//
//  MovieCollectionViewCell.swift
//  MovieSearchApp
//
//  Created by MAC on 10/14/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var titleAndTypeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
    var cellContent : Movie!
    {
        didSet
        {
            var titleAndType = ""
            if let title = cellContent.title
            {
                titleAndType = title
            }
            if let type = cellContent.type
            {
                titleAndType = titleAndType + " ( " + type + " ) "
            }
            titleAndTypeLabel.text = titleAndType
            if let date = cellContent.year
            {
                releaseDateLabel.text = date
            }
            if let poster = cellContent.poster
            {
                posterImageView.sd_setImage(with: URL(string: poster))

            }
        }
    }
}

