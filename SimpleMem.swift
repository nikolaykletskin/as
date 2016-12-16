class SimpleMem: Mem {
    var image: UIImage
    var topText: NSString
    var bottomText: NSString
    var maxTextHeight: CGFloat
    
    let textPadding: CGFloat = 10
    
    init(image: UIImage, topText : NSString, bottomText: NSString) {
        self.image = image
        self.topText = topText
        self.bottomText = bottomText
        self.maxTextHeight = image.size.height / 4
    }
    
    func getFontAttributes(text: NSString)-> [String: Any] {
        let fontStyle = NSMutableParagraphStyle()
        fontStyle.alignment = .center
        var fontAttributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSStrokeWidthAttributeName: -2,
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: fontStyle
            ] as [String : Any]

        let fontSize = getFontSize(text: text, img: image, fontSize: maxTextHeight, maxTextHeight: maxTextHeight, fontAttributes: fontAttributes)
        let font = UIFont(name: "Helvetica Bold", size: fontSize)!
        
        fontAttributes[NSFontAttributeName] = font
        return fontAttributes
    }
    
    func drawText(text : NSString, fontAttributes: [String : Any]) {
        let boundingRect = text.boundingRect(with: CGSize(width: image.size.width, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: fontAttributes, context: nil)
        let originPoint = CGPoint(x: (image.size.width - boundingRect.width) / 2, y: textPadding)
        //let bottomTextOriginPoint = CGPoint(x: (imageSize.width - bottomTextBoundingRect.width) / 2, y: image.size.height - boundingRect.height - textPadding)
        let textRect = CGRect(origin: originPoint, size: CGSize(width: boundingRect.width, height: boundingRect.height))
        text.draw(in: textRect, withAttributes: fontAttributes)

    }
    
    func draw() -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size))
        
        let topTextFontAttributes = getFontAttributes(text: topText)
        let bottomTextFontAttributes = getFontAttributes(text: bottomText)

        drawText(text: topText, fontAttributes: topTextFontAttributes)
        //drawText(text: bottomText, fontAttributes: bottomTextFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
