class Mem {
    let textFont = "Helvetica Bold"
    let textPadding: CGFloat = 20
    
    func getFontSize(text: NSString, img: UIImage?, fontSize: CGFloat, maxTextHeight: CGFloat, fontAttributes: [String : Any]) -> CGFloat {
        let font = UIFont(name: textFont, size: fontSize)!
        
        var newFontAttributes = fontAttributes
        newFontAttributes[NSFontAttributeName] = font
        
        print((img?.size.width)!, (img?.size.width)! - textPadding * 2)
        
        let boundingRect = text.boundingRect(with: CGSize(width: (img?.size.width)! - textPadding * 2, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: newFontAttributes, context: nil)
        
        if (boundingRect.height > maxTextHeight) {
            //recursive execution with bigger fontSize
            let newFontSize = fontSize - 1
            return getFontSize(text: text, img: img, fontSize: newFontSize, maxTextHeight: maxTextHeight, fontAttributes: fontAttributes)
        }
        
        return fontSize
    }
}
