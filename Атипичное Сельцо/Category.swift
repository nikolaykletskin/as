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
