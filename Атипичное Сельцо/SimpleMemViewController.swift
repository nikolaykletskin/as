import UIKit
import Photos


class SimpleMemViewController: MemViewController, UIImagePickerControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var simpleMemImage: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var topTextField: CustomTextField!
    @IBOutlet weak var bottomTextField: CustomTextField!
    
    @IBOutlet weak var simpleMemImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imageView = simpleMemImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage))
        gestureRecognizer.numberOfTapsRequired = 1
        simpleMemImage.isUserInteractionEnabled = true
        simpleMemImage.addGestureRecognizer(gestureRecognizer)
        
        if (image != nil) {
            plusImageView.isHidden = true
            simpleMemImage.image = image
        }
        
        // UI
        self.view.backgroundColor = UIColor.nDarkColor()
        containerView.backgroundColor = UIColor.nDarkColor()
        simpleMemImage.backgroundColor = UIColor.nBrightSkyBlueColor()
        simpleMemImage.layer.cornerRadius = 5
        topTextField.attributedPlaceholder = NSAttributedString(string:"Текст сверху", attributes:[NSForegroundColorAttributeName: UIColor.nSlateColor()])
        bottomTextField.attributedPlaceholder = NSAttributedString(string:"Текст снизу", attributes:[NSForegroundColorAttributeName: UIColor.nSlateColor()])
        
        // Handle the text field’s user input through delegate callbacks.
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.addTarget(self, action: #selector(SimpleMemViewController.textFieldDidChange(_:)), for: .editingChanged)
        bottomTextField.addTarget(self, action: #selector(SimpleMemViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        AppState.shared.memType = .simpleMem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let selectedImageAspectRatio = selectedImage.size.width / selectedImage.size.height
        let simpleMemImageOldHeight = simpleMemImage.frame.size.height
        let simpleMemImageNewHeight = simpleMemImage.frame.size.width / selectedImageAspectRatio
        let heightDifference = simpleMemImageNewHeight - simpleMemImageOldHeight
        simpleMemImageHeightConstraint.isActive = false
        simpleMemImage.heightAnchor.constraint(equalToConstant: simpleMemImageNewHeight).isActive = true
        simpleMemImage.contentMode = .scaleAspectFill
        image = selectedImage
        simpleMemImage.image = selectedImage
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: scrollView.contentSize.height + heightDifference)
        
        plusImageView.isHidden = true
        topTextField.isEnabled = true
        bottomTextField.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    func addImage(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Шаблоны", style: .default, handler: openTemplates))
        alertController.addAction(UIAlertAction(title: "Галерея", style: .default, handler: openPhotoLibrary))
        alertController.addAction(UIAlertAction(title: "Сделать фотографию", style: .default, handler: shootPhoto))
        alertController.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func openTemplates(_ sender : UIAlertAction) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesTableViewController") as! CategoriesTableViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func openPhotoLibrary(_ sender : UIAlertAction) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func shootPhoto(_ sender: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    override func textFieldDidChange(_ textField: UITextField) {
        if (simpleMemImage.image == nil) {
            return
        } else {
            saveButton.isEnabled = true
        }
        
        // Renew image
        simpleMemImage.image = image
        
        let simpleMem = SimpleMem(image: simpleMemImage.image!, topText : NSString(string: topTextField.text!), bottomText: NSString(string: bottomTextField.text!))
        simpleMemImage.image = simpleMem.draw()
    }
}
