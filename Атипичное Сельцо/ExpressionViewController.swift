import UIKit

class ExpressionViewController: MemViewController {

    @IBOutlet weak var expressionImageView: UIImageView!
    @IBOutlet weak var expressionTextField: CustomTextField!
    @IBOutlet weak var plusImageView: UIImageView!
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
        
        AppState.shared.memType = .expression
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openTemplates() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "TemplatesTableViewController") as! TemplatesTableViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    override func textFieldDidChange(_ textField: UITextField) {
        if (expressionImageView.image == nil) {
            return
        } else {
            saveButton.isEnabled = true
        }
        
        // Renew image
        expressionImageView.image = image
        let expression = Expression(image: expressionImageView.image!, text: NSString(string: textField.text!))
        expression.image = Expression.draw()
    }

}
