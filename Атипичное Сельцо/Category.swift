//
//  Category.swift
//  Атипичное Сельцо
//
//  Created by Nikolay Kletskin on 10/24/16.
//  Copyright © 2016 Nikolay Kletskin. All rights reserved.
//

import UIKit

class Category {
    
    // MARK: Properties
    var name: String
    var previewImage: UIImage?
    
    init(name: String, previewImage: UIImage?) {
        self.name = name
        self.previewImage = previewImage
    }
}
