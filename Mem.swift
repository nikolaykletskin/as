class Mem {
    let textFont = "Helvetica Bold"
    var textPadding: CGFloat
    let textPaddingPercent: CGFloat = 10
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        self.textPadding = image.size.width / 100 * textPaddingPercent
    }
    
    // Recursive getting appropriate font size
    func getFontSize(text: NSString, img: UIImage?, fontSize: CGFloat, maxTextHeight: CGFloat, fontAttributes: [String : Any]) -> CGFloat {
        
        let font = UIFont(name: textFont, size: fontSize)!
        
        var newFontAttributes = fontAttributes
        newFontAttributes[NSFontAttributeName] = font
        
        let boundingRect = text.boundingRect(with: CGSize(width: (img?.size.width)!, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: newFontAttributes, context: nil)
        
        if (boundingRect.height > maxTextHeight) {
            //recursive execution with bigger fontSize
            let newFontSize = fontSize - 1
            return getFontSize(text: text, img: img, fontSize: newFontSize, maxTextHeight: maxTextHeight, fontAttributes: fontAttributes)
        }
        
        print("img size \((img?.size.width)!) x \((img?.size.height)!)")
        print("text padding \(textPadding * 2)")
        print("rect size \(boundingRect.width) x \(boundingRect.height)")
        
        return fontSize
    }
}
