class Expression: Mem {
    var text: NSString
    var maxTextHeight: CGFloat
    
    init(image: UIImage, text: NSString) {
        self.text = text
        self.maxTextHeight = image.size.height / 3
        super.init(image: image)
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
    
    private func drawText(text : NSString, fontAttributes: [String : Any]) {
        let boundingRect = text.boundingRect(with: CGSize(width: image.size.width - textPadding * 2, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: fontAttributes, context: nil)
        let originPoint = CGPoint(x: (image.size.width - boundingRect.width) / 2, y: textPadding)
        
        let textRect = CGRect(origin: originPoint, size: CGSize(width: boundingRect.width, height: boundingRect.height))
        text.draw(in: textRect, withAttributes: fontAttributes)
    }
    
    func draw() -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size))
        
        if (text != "") {
            let textFontAttributes = getFontAttributes(text: text)
            drawText(text: text, fontAttributes: textFontAttributes)
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
