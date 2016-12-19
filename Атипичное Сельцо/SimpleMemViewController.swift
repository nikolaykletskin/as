import UIKit
import Photos
import VK_ios_sdk

class SimpleMemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var simpleMemImage: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var topTextField: CustomTextField!
    @IBOutlet weak var bottomTextField: CustomTextField!
    let saveButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(saveImage))
    @IBOutlet weak var simpleMemImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    var image: UIImage? = nil
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewWillAppear(_ animated: Bool) {
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton
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
        
        // Initialize activity indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(activityIndicator)
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
    
        let simpleMemImageheight = simpleMemImage.frame.size.width / selectedImageAspectRatio
        simpleMemImageHeightConstraint.isActive = false
        simpleMemImage.heightAnchor.constraint(equalToConstant: simpleMemImageheight).isActive = true
        simpleMemImage.contentMode = .scaleAspectFill
        simpleMemImage.image = selectedImage
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
    
    func saveImage(_ sender: UIBarButtonItem) {
        activityIndicator.center = simpleMemImage.center
        activityIndicator.startAnimating()
        
        VKNetworking.shared.vkLogin(completion: {_ in
            let postConfirmationAlert = UIAlertController(title: nil, message: "Предложить мем к публикации?", preferredStyle: .alert)
            postConfirmationAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: {_ in
                self.activityIndicator.startAnimating()
                
                let VKRequest = VKApi.uploadWallPhotoRequest(self.simpleMemImage.image, parameters: VKImageParameters.jpegImage(withQuality: 100), userId: 0, groupId: VKNetworking.GROUP_ID)
                
                VKRequest?.execute(resultBlock: {(_ response: VKResponse?) -> Void in                    
                    let vkPhotoArray = response!.parsedModel as! VKPhotoArray
                    let photo = vkPhotoArray.object(at: 0) as VKPhoto
                    let photoAttachment = "photo\(photo.owner_id!)_\(photo.id!)"
                    
                    let post = VKApi.wall().post([VK_API_ATTACHMENTS : photoAttachment, VK_API_OWNER_ID : "-\(VKNetworking.GROUP_ID)"])
                    post?.execute(resultBlock: { (response) in
                        self.activityIndicator.stopAnimating()
                        let postResultAlert = UIAlertController(title: nil, message: "Мем предложен к публикации", preferredStyle: .alert)
                        self.present(postResultAlert, animated: true, completion: {_ in})
                    }, errorBlock: { (error) in
                        if error != nil {
                            print(error!)
                        }
                    })
                }, errorBlock: {(_ error: Error?) -> Void in
                    print("failure \(error)")
                })
            }))
            postConfirmationAlert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
            self.present(postConfirmationAlert, animated: true, completion: {_ in
                self.activityIndicator.stopAnimating()
            })
        })
        
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
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldDidChange(_ textField: UITextField) {
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
