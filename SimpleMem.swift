class SimpleMem: Mem {
    var topText: NSString
    var bottomText: NSString
    var maxTextHeight: CGFloat = CGFloat()
    
    enum textType {
        case top
        case bottom
    }
    
    init(image: UIImage, topText : NSString, bottomText: NSString) {
        self.topText = topText
        self.bottomText = bottomText
        super.init(image: image)
        self.maxTextHeight = (image.size.height - CGFloat(self.textPadding.vertical) * 2) / 4
    }
    
    private func getFontAttributes(text: NSString)-> [String: Any] {
        let fontStyle = NSMutableParagraphStyle()
        fontStyle.alignment = .center
        var fontAttributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSStrokeWidthAttributeName: -2,
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: fontStyle
            ] as [String : Any]

        let fontSize = getFontSize(text: text, img: image, fontSize: maxTextHeight, maxTextHeight: maxTextHeight, fontAttributes: fontAttributes)
        let font = UIFont(name: textFont, size: fontSize)!
        
        fontAttributes[NSFontAttributeName] = font
        return fontAttributes
    }
    
    private func drawText(text : NSString, fontAttributes: [String : Any], type: textType) {
        let boundingRect = text.boundingRect(with: CGSize(width: image.size.width - CGFloat(textPadding.horizontal) * 2, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: fontAttributes, context: nil)
        var originPoint = CGPoint()
        
        switch type {
            case .top:
                originPoint = CGPoint(x: (image.size.width - boundingRect.width) / 2, y: CGFloat(textPadding.vertical))
            case .bottom:
                originPoint = CGPoint(x: (image.size.width - boundingRect.width) / 2, y: image.size.height - boundingRect.height - CGFloat(textPadding.vertical))
        }

        let textRect = CGRect(origin: originPoint, size: CGSize(width: boundingRect.width, height: boundingRect.height))
        text.draw(in: textRect, withAttributes: fontAttributes)
    }
    
    func draw() -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size))

        if (topText != "") {
            let topTextFontAttributes = getFontAttributes(text: topText)
            drawText(text: topText, fontAttributes: topTextFontAttributes, type: .top)
        }
        
        if (bottomText != "") {
            let bottomTextFontAttributes = getFontAttributes(text: bottomText)
            drawText(text: bottomText, fontAttributes: bottomTextFontAttributes, type: .bottom)
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
