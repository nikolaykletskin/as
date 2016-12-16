import UIKit
import Photos
import VK_ios_sdk

class SimpleMemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let albumName = "Атипичное Сельцо"

    // MARK: Properties
    @IBOutlet weak var simpleMemImage: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var topTextField: CustomTextField!
    @IBOutlet weak var bottomTextField: CustomTextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var simpleMemImageHeightConstraint: NSLayoutConstraint!
    var image: UIImage? = nil
    var assetCollection: PHAssetCollection!
    var albumFound: Bool = false
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
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
    
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
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
            
            //let shareDialog = VKShareDialogController()
            //shareDialog

//            let shareDialog = VKShareDialogController()
//            //1
//            shareDialog.text = "This post created using #vksdk #ios"
//            let uploadImage = VKUploadImage(image: self.simpleMemImage.image, andParams: nil)
//            shareDialog.uploadImages = [uploadImage as Any]
//            //3
//            shareDialog.shareLink = VKShareLink(title: "Super puper link, but nobody knows", link: URL(string: "https://vk.com/tiredbullshit_arts")!)
//            //4
//            shareDialog.completionHandler = {(_ controller: VKShareDialogController?, _ result: VKShareDialogControllerResult) -> Void in
//                print("completed")
//                self.dismiss(animated: true, completion: { _ in })
//                print("hello")
//            }
//            //5
//            self.present(shareDialog, animated: true, completion: { _ in })//6 }
        })
        
        
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
//        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//        if (collection.firstObject != nil) {
//            albumFound = true
//            assetCollection = collection.firstObject! as PHAssetCollection
//        } else {
//            PHPhotoLibrary.shared().performChanges({
//                _ = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
//            },
//            completionHandler: {(success: Bool, error: Error?) in
//                NSLog("Creation of folder - %@", (success ? "Success" : "error"))
//                self.albumFound = success
//            })
//        }
//        
//        if (albumFound) {
//            PHPhotoLibrary.shared().performChanges({
//                // Request creating an asset from the image.
//                let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.simpleMemImage.image!)
//                // Request editing the album.
//                guard let addAssetRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
//                    else { return }
//                // Get a placeholder for the new asset and add it to the album editing request.
//                addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
//                }, completionHandler: { success, error in
//                    if !success { NSLog("error creating asset: \(error)") }
//            })
//        }
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
        
        let simpleMem = SimpleMem(image: image!, topText : NSString(string: topTextField.text!), bottomText: NSString(string: bottomTextField.text!))
        simpleMemImage.image = simpleMem.draw()
    }
}
