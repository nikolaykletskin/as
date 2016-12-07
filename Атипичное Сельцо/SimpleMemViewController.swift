//
//  SimpleMemViewController.swift
//  Атипичное Сельцо
//
//  Created by Николай Клёцкин on 10/12/16.
//  Copyright © 2016 Nikolay Kletskin. All rights reserved.
//

import UIKit
import Photos
import VK_ios_sdk

class SimpleMemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let albumName = "Атипичное Сельцо"

    // MARK: Properties
    @IBOutlet weak var simpleMemImage: UIImageView!
    @IBOutlet weak var topTextField: CustomTextField!
    @IBOutlet weak var bottomTextField: CustomTextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
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
        
        if (image != nil) {
            simpleMemImage.image = image
        } else {
            topTextField.isEnabled = false
            bottomTextField.isEnabled = false
        }
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        simpleMemImage.contentMode = UIViewContentMode.scaleAspectFit
        simpleMemImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }

    // MARK: Actions
    @IBAction func addImage(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Шаблоны", style: .default, handler: openTemplates))
        alertController.addAction(UIAlertAction(title: "Галерея", style: .default, handler: openPhotoLibrary))
        alertController.addAction(UIAlertAction(title: "Сделать фотографию", style: .default, handler: shootPhoto))
        alertController.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        print("Понеслась")
        VKNetworking.shared.vkLogin(completion: {_ in
            print("Авторизовался")
            
            let alertMessage = UIAlertController(title: nil, message: "Предложить данный мем к публикации?", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Да", style: .default, handler: {_ in
                self.activityIndicator.center = self.view.center
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
                self.view.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
                let VKRequest = VKApi.uploadWallPhotoRequest(self.simpleMemImage.image, parameters: VKImageParameters.jpegImage(withQuality: 100), userId: 0, groupId: 134615445)
                
                VKRequest?.execute(resultBlock: {(_ response: VKResponse?) -> Void in
                    print("Залил картинку")
                    
                    let vkPhotoArray = response!.parsedModel as! VKPhotoArray
                    let photo = vkPhotoArray.object(at: 0) as VKPhoto
                    let photoAttachment = "photo\(photo.owner_id!)_\(photo.id!)"
                    
                    let post = VKApi.wall().post([VK_API_ATTACHMENTS : photoAttachment, VK_API_OWNER_ID : "-134615445"])
                    post?.execute(resultBlock: { (response) in
                        self.activityIndicator.stopAnimating()
                        print("Запостил картинку")
                    }, errorBlock: { (error) in
                        if error != nil {
                            print(error!)
                        }
                    })
                }, errorBlock: {(_ error: Error?) -> Void in
                    print("failure \(error)")
                })
            }))
            alertMessage.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: {_ in
                print("Нарисовал alert")
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
        
        let imageSize = (simpleMemImage.image?.size)!
        
        // Getting top and bottom Text
        let topText = NSString(string: topTextField.text!)
        let bottomText = NSString(string: bottomTextField.text!)
        
        // Common font styles
        let fontStyle = NSMutableParagraphStyle()
        fontStyle.alignment = .center
        let fontAttributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSStrokeWidthAttributeName: -2,
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: fontStyle
        ] as [String : Any]
        
        // Getting maximum height of text areas on image
        let maxTextHeight = (simpleMemImage.image?.size.height)! / 4
        
        // Adjust top text font
        let topTextFontSize = getFontSize(text: topText, img: simpleMemImage.image, fontSize: maxTextHeight, maxTextHeight: maxTextHeight, fontAttributes: fontAttributes)
        let topTextFont = UIFont(name: "Helvetica Bold", size: topTextFontSize)!
        
        // Adjust bottom text font
        let bottomTextFontSize = getFontSize(text: bottomText, img: simpleMemImage.image, fontSize: maxTextHeight, maxTextHeight: maxTextHeight, fontAttributes: fontAttributes)
        let bottomTextFont = UIFont(name: "Helvetica Bold", size: bottomTextFontSize)!
        
        // Setting top text attributes
        var topTextFontAttributes = fontAttributes
        topTextFontAttributes[NSFontAttributeName] = topTextFont
        
        // Setting bottom text attributes
        var bottomTextFontAttributes = fontAttributes
        bottomTextFontAttributes[NSFontAttributeName] = bottomTextFont
        
        //Drawing
        UIGraphicsBeginImageContext(imageSize)
        simpleMemImage.image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize))
        
        // Draw top text
        let topTextBoundingRect = topText.boundingRect(with: CGSize(width: imageSize.width, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: topTextFontAttributes, context: nil)
        let topTextOriginPoint = CGPoint(x: (imageSize.width - topTextBoundingRect.width) / 2, y: 10)
        let topTextRect = CGRect(origin: topTextOriginPoint, size: CGSize(width: topTextBoundingRect.width, height: topTextBoundingRect.height))
        topText.draw(in: topTextRect, withAttributes: topTextFontAttributes)
        
        // Draw bottom text
        let bottomTextBoundingRect = bottomText.boundingRect(with: CGSize(width: imageSize.width, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: bottomTextFontAttributes, context: nil)
        let bottomTextOriginPoint = CGPoint(x: (imageSize.width - bottomTextBoundingRect.width) / 2, y: imageSize.height - bottomTextBoundingRect.height - 10)
        let bottomTextRect = CGRect(origin: bottomTextOriginPoint, size: CGSize(width: bottomTextBoundingRect.width, height: bottomTextBoundingRect.height))
        bottomText.draw(in: bottomTextRect, withAttributes: bottomTextFontAttributes)
        
        // Get result image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        simpleMemImage.image = newImage
    }
    
    func getFontSize(text: NSString, img: UIImage?, fontSize: CGFloat, maxTextHeight: CGFloat, fontAttributes: [String : Any]) -> CGFloat {
        let font = UIFont(name: "Helvetica Bold", size: fontSize)!
        
        var newFontAttributes = fontAttributes
        newFontAttributes[NSFontAttributeName] = font
        
        let boundingRect = text.boundingRect(with: CGSize(width: (img?.size.width)!, height: CGFloat(DBL_MAX)), options: .usesLineFragmentOrigin, attributes: newFontAttributes, context: nil)
        
        if (boundingRect.height > maxTextHeight) {
            //recursive with bigger fontSize
            let newFontSize = fontSize - 1
            return getFontSize(text: text, img: img, fontSize: newFontSize, maxTextHeight: maxTextHeight, fontAttributes: fontAttributes)
        }
        
        return fontSize
    }
}
