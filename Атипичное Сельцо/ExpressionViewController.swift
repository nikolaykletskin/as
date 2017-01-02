import UIKit

class ExpressionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var expressionImageView: UIImageView!
    @IBOutlet weak var expressionTextField: CustomTextField!
    @IBOutlet weak var plusImageView: UIImageView!
    var image: UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openTemplates))
        gestureRecognizer.numberOfTapsRequired = 1
        expressionImageView.isUserInteractionEnabled = true
        expressionImageView.addGestureRecognizer(gestureRecognizer)

        // UI
        self.view.backgroundColor = UIColor.nDarkColor()
        expressionImageView.backgroundColor = UIColor.nDarkPeriwinkleColor()
        expressionImageView.layer.cornerRadius = 5
        expressionTextField.attributedPlaceholder = NSAttributedString(string:"Текст", attributes:[NSForegroundColorAttributeName: UIColor.nSlateColor()])
        
        expressionTextField.delegate = self
        
        if (image != nil) {
            plusImageView.isHidden = true
            expressionImageView.image = image
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openTemplates() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "TemplatesTableViewController") as! TemplatesTableViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
