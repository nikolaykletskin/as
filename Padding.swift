struct Padding {
    var horizontal: CGFloat
    var vertical: CGFloat
    let ratioToImageWidth: CGFloat = 0.05
    
    init(imageWidth: CGFloat) {
        self.horizontal = imageWidth * ratioToImageWidth
        self.vertical = imageWidth * ratioToImageWidth
    }
}
