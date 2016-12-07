import UIKit
import VK_ios_sdk

class MemTypesViewController: UIViewController {

    @IBOutlet weak var simpleMemButton: UIButton!
    @IBOutlet weak var expressionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.nDarkColor()
        simpleMemButton.backgroundColor = UIColor.nBrightSkyBlueColor()
        simpleMemButton.layer.cornerRadius = 5
        expressionButton.backgroundColor = UIColor.nDarkPeriwinkleColor()
        expressionButton.layer.cornerRadius = 5
        
        VKNetworking.shared.vkLogout()
    }
}
