class Mem {
    let textFont = "Helvetica Bold"
    var textPadding: Padding
    let textPaddingToImageWidthRatio: CGFloat = 0.05
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
        self.textPadding = Padding(imageWidth: image.size.width)
    }
    
    // Recursive getting appropriate font size
    func getFontSize(text: NSString, img: UIImage?, fontSize: CGFloat, maxTextHeight: CGFloat, fontAttributes: [String : Any]) -> CGFloat {
        let font = UIFont(name: textFont, size: fontSize)!
        
        var newFontAttributes = fontAttributes
        newFontAttributes[NSFontAttributeName] = font
        
        let boundingRect = text.boundingRect(with: CGSize(width: (img?.size.width)!, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: newFontAttributes, context: nil)
        
        //recursive execution with bigger fontSize
        if (boundingRect.height > maxTextHeight) {
            let newFontSize = fontSize - 1
            return getFontSize(text: text, img: img, fontSize: newFontSize, maxTextHeight: maxTextHeight, fontAttributes: fontAttributes)
        }
        
        return fontSize
    }
}
