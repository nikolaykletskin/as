import UIKit

class CategoryTableViewCell: CustomTableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews();
        previewImageView.layer.cornerRadius = previewImageView.bounds.height / 2
        previewImageView.clipsToBounds = true
    }
}
