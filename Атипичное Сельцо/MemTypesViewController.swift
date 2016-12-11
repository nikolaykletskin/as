import UIKit
import VK_ios_sdk

class MemTypesViewController: UIViewController {

    @IBOutlet weak var simpleMemButton: UIButton!
    @IBOutlet weak var expressionButton: UIButton!
    @IBOutlet weak var simpleMemLabel: UILabel!
    @IBOutlet weak var expressionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.nDarkColor()
        simpleMemButton.backgroundColor = UIColor.nBrightSkyBlueColor()
        simpleMemButton.layer.cornerRadius = 5
        expressionButton.backgroundColor = UIColor.nDarkPeriwinkleColor()
        expressionButton.layer.cornerRadius = 5
        simpleMemLabel.font = simpleMemLabel.font.withSize(23)
        simpleMemLabel.textColor = UIColor.white
        expressionLabel.font = expressionLabel.font.withSize(23)
        expressionLabel.textColor = UIColor.white
    }
}
