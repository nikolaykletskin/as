import UIKit

class MemViewController: UIViewController, UITextFieldDelegate {
    let saveButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(saveImage))
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveButton.isEnabled = false
        navigationItem.rightBarButtonItem = saveButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveImage(_ sender: UIBarButtonItem) {
        activityIndicator.center = simpleMemImage.center
        activityIndicator.startAnimating()
        
        VKNetworking.shared.login(completion: {_ in
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
                        self.alert(message: "Мем предложен к публикации")
                    }, errorBlock: { (error) in
                        self.activityIndicator.stopAnimating()
                        self.alert(message: "При публикации произошла ошибка (код: \((error as! NSError).code).")
                    })
                }, errorBlock: {(_ error: Error?) -> Void in
                    self.activityIndicator.stopAnimating()
                    self.alert(message: "При публикации произошла ошибка (код: \((error as! NSError).code).")
                })
            }))
            postConfirmationAlert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
            self.present(postConfirmationAlert, animated: true, completion: {_ in
                self.activityIndicator.stopAnimating()
            })
        }, failure: {(_ error: Error?) -> Void in
            self.alert(message: "При авторизации произошла ошибка (код: \((error as! NSError).code).")
        })
        
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
    }
}
