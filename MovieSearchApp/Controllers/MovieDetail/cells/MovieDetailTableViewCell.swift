//
//  MovieDetailTableViewCell.swift
//  MovieSearchApp
//
//  Created by MAC on 10/14/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    var cellContent : movieDetail!
    {
        didSet
        {
            if let type = cellContent.type
            {
                typeLabel.text = type
            }
            if let value = cellContent.value
            {
                valueLabel.text = value
            }
        }
    }
    
}

