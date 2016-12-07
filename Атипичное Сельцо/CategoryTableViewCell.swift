//
//  CategoryTableViewCell.swift
//  Атипичное Сельцо
//
//  Created by Nikolay Kletskin on 10/24/16.
//  Copyright © 2016 Nikolay Kletskin. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        //previewImageView.layer.cornerRadius = previewImageView.bounds.height / 2
        //previewImageView.clipsToBounds = true
        
        previewImageView.layer.borderWidth = 1
        previewImageView.layer.masksToBounds = false
        previewImageView.layer.borderColor = UIColor.black.cgColor
        //previewImageView.layer.cornerRadius = previewImageView.frame.height / 2
        previewImageView.layer.cornerRadius = 35
        previewImageView.clipsToBounds = true
    }

}
