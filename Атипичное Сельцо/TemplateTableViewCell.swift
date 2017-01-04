//
//  TemplateTableViewCell.swift
//  Атипичное Сельцо
//
//  Created by Nikolay Kletskin on 11/10/16.
//  Copyright © 2016 Nikolay Kletskin. All rights reserved.
//

import UIKit

class TemplateTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        previewImageView.layer.cornerRadius = previewImageView.bounds.height / 2
        previewImageView.clipsToBounds = true
        
        previewImageView.layer.borderWidth = 1
        previewImageView.layer.masksToBounds = false
        previewImageView.layer.borderColor = UIColor.black.cgColor
        //previewImageView.layer.cornerRadius = previewImageView.frame.height / 2
        previewImageView.layer.cornerRadius = 35
        previewImageView.clipsToBounds = true
    }

}
