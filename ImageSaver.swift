import Photos

class ImageSaver {
    let albumName = "Атипичное Сельцо"
    var assetCollection: PHAssetCollection!
    var albumFound: Bool = false
    
    func save(image: UIImage) {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
                let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                if (collection.firstObject != nil) {
                    albumFound = true
                    assetCollection = collection.firstObject! as PHAssetCollection
                } else {
                    PHPhotoLibrary.shared().performChanges({
                        _ = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
                    },
                    completionHandler: {(success: Bool, error: Error?) in
                        NSLog("Creation of folder - %@", (success ? "Success" : "error"))
                        self.albumFound = success
                    })
                }
        
                if (albumFound) {
                    PHPhotoLibrary.shared().performChanges({
                        // Request creating an asset from the image.
                        let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                        // Request editing the album.
                        guard let addAssetRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
                            else { return }
                        // Get a placeholder for the new asset and add it to the album editing request.
                        addAssetRequest.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
                        }, completionHandler: { success, error in
                            if !success { NSLog("error creating asset: \(error)") }
                    })
                }
    }
}
