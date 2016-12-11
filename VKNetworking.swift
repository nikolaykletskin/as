import VK_ios_sdk

class VKNetworking: NSObject {
    static let shared = VKNetworking()
    static let VK_APP_ID = "5739524"
    static let GROUP_ID = 134615445
    let permissions = NSArray(objects: "email", "wall", "photos") as [AnyObject]
    
    var userEmail = String()
    
    func vkLogin(completion: @escaping () -> ()) {
        VKSdk.wakeUpSession(self.permissions, complete: { (state, error) in
            if state == .authorized && error == nil && VKSdk.accessToken() != nil {
                completion()
            } else if state == .initialized {
                VKSdk.authorize(self.permissions)
            } else {
                if error != nil {
                    print(error!)
                }
            }
        })
    }
    
    func vkLogout() {
        VKSdk.forceLogout()
    }
}

extension VKNetworking: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil && result.error == nil {
            if let email = result.token.email {
                self.userEmail = email
            }
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
    }
}

extension VKNetworking: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        //self.present(controller, animated: true, completion: { _ in })
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
}
