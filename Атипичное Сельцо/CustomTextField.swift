//
//  CustomTextField.swift
//  Атипичное Сельцо
//
//  Created by Nikolay Kletskin on 10/18/16.
//  Copyright © 2016 Nikolay Kletskin. All rights reserved.
//

import UIKit
class CustomTextField: UITextField {
    let cornerRadius : CGFloat = 5
    let borderWidth : CGFloat = 3
    let fontSize: CGFloat = 20
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.textColor = UIColor.nCoolGreyColor()
        self.backgroundColor = UIColor.nDarkColor()
        self.layer.borderColor = UIColor.nSlateColor().cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.font = UIFont(name: (self.font?.fontName)!, size: fontSize)
    }
}
