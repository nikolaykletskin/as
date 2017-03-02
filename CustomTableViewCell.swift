import UIKit

class CustomTableViewCell: UITableViewCell {
    // MARK: Contants
    static let height : CGFloat = 90
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.nDarkThreeColor()
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2)
        border.backgroundColor = UIColor.nDarkTwoColor().cgColor
        self.layer.addSublayer(border)
        
        previewImageView.layer.borderWidth = 1
        previewImageView.layer.borderColor = UIColor.black.cgColor
        nameLabel.textColor = UIColor.nCoolGreyColor()
        // TODO: change font
        //nameLabel.font = UIFont(name: (nameLabel.font?.fontName)!, size: 20)
    }
}
