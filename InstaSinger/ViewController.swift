//
//  ViewController.swift
//  InstaSinger
//
//  Created by Bechir Kaddech on 11/6/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FacebookCore
import FBSDKCoreKit
import FirebaseDatabase
import Material
import EZLoadingActivity
import SwiftSpinner



class ViewController: UIViewController, GIDSignInDelegate , GIDSignInUIDelegate , FBSDKLoginButtonDelegate {
    
    
    // initiation du base
    let ref = FIRDatabase.database().reference(fromURL: "https://instasinger-e9947.firebaseio.com/")
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                          accessToken: (authentication?.accessToken)!)
        FIRAuth.auth()?.signIn(with: credential, completion : { (userfire, error) in
            
            if error != nil {
                print("failed google")
                return
            }
            
            let UID = FIRAuth.auth()?.currentUser?.uid
            
            
            
            let user = ["username" : user.profile.familyName+self.randomString(length: 3),
                        "fullname" : user.profile.givenName,
                        "email" : user.profile.email,
                        "profilePictureURL" : user.profile.imageURL(withDimension: 100).absoluteString]
            
            
            self.regiterUsertoDatabase(UID: UID!, values: user as AnyObject)
            self.dismiss(animated: true, completion: nil)
            
            
            
            
            
            //self.fetchProfile()
            self.dismiss(animated: true, completion: nil)
            
            
            
            
            
        })
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    
    var NS : NSURL!
    override func viewDidAppear(_ animated: Bool) {
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //facebook
        let loginFacebookButton = FBSDKLoginButton()
        let xf = (self.view.width / 2 )  - 75
        
        view.addSubview(loginFacebookButton)
        loginFacebookButton.frame = CGRect(x: xf, y: 300, width: 150, height: 30)
        loginFacebookButton.delegate = self
        loginFacebookButton.readPermissions = ["email", "public_profile"]
        
        //google
        
        let logingoogleButton = GIDSignInButton()
        logingoogleButton.frame = CGRect(x: xf, y: 300 + 66 , width: 150, height: 30)
        GIDSignIn.sharedInstance().uiDelegate = self
        
        view.addSubview(logingoogleButton)

    
    }
    
    
    override func viewDidLoad() {
        // test()
        
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
        }
        else
        {
            print("Internet Connection not Available!")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        
        //design textField
        
        prepareEmailField()
        preparePasswordField()
    }
    
    
    
    
    
    private func prepareEmailField() {
        
        emailTextField.placeholder = "Email"
        emailTextField.placeholderNormalColor = .black
        emailTextField.placeholderActiveColor = .black
        
        emailTextField.detail = "Error, incorrect email"
        emailTextField.isClearIconButtonEnabled = true
        emailTextField.delegate = self
        
        
        let leftView = UIImageView()
        leftView.image = Icon.email
        
        emailTextField.leftView = leftView
        emailTextField.leftViewMode = .always
        emailTextField.leftViewNormalColor = .black
        emailTextField.leftViewActiveColor = .black
        
        // Set the colors for the emailField, different from the defaults.
        //        emailField.placeholderNormalColor = Color.amber.darken4
        //        emailField.placeholderActiveColor = Color.pink.base
        //        emailField.dividerNormalColor = Color.cyan.base
        //        emailField.dividerActiveColor = Color.green.base
        
    }
    
    private func preparePasswordField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.placeholderNormalColor = .black
        passwordTextField.placeholderActiveColor = .black
        
    
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.isVisibilityIconButtonEnabled = true
        let leftView = UIImageView()
        leftView.image = Icon.edit
        
        passwordTextField.leftView = leftView
        passwordTextField.leftViewMode = .always
        passwordTextField.leftViewNormalColor = .black
        passwordTextField.leftViewActiveColor = .black
        
        // Setting the visibilityIconButton color.
        passwordTextField.visibilityIconButton?.tintColor = Color.orange.withAlphaComponent(passwordTextField.isSecureTextEntry ? 0.38 : 0.54)
        
    }
    
    
    
    //facebook
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did logout")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        let accessToken = FBSDKAccessToken.current()
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("failed facebook")
                return
            }
            
            
            
            self.fetchProfile()
            self.dismiss(animated: true, completion: nil)
            
            
            
        })
        
        
    }
    
    private func regiterUsertoDatabase(UID: String, values: AnyObject)
    {
        
        let userRef = ref.child("users")
        let uidref = userRef.child(UID)
        uidref.updateChildValues(values as! [AnyHashable : Any], withCompletionBlock: {( err , ref) in
            if (err != nil)
            {
                print(err!)
            }
            print("saved")
            
        })
        
    }
    
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func fetchProfile() {
        let parameters = ["fields": "email, name, first_name , picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { (connection, user, requestError) -> Void in
            
            if requestError != nil {
                print(requestError!)
                return
            }
            let data:[String:AnyObject] = user as! [String : AnyObject]
            print(data["first_name"]!)
            
            var email = data["email"] as? String
            let Name = data["name"] as? String
            let firstName = data["first_name"] as? String
            
            if email == nil {
                email = "No email"
            }
            var pictureUrl = ""
            
            if let picture = data["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                pictureUrl = url
            }
            let UID = FIRAuth.auth()?.currentUser?.uid
            
            
            
            let user = ["username" : firstName!+self.randomString(length: 3),
                        "fullname" : Name,
                        "email" : email,
                        "profilePictureURL" : pictureUrl]
            self.regiterUsertoDatabase(UID: UID!, values: user as AnyObject)
            self.dismiss(animated: true, completion: nil)
            
            
        })
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreafted.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    @IBOutlet weak var emailTextField: ErrorTextField!
    
    
    
    
    @IBOutlet weak var passwordTextField: TextField!
    
    
    
    @IBAction func LogIn(_ sender: Any) {
        var errorvalid:Bool = true
        
        if(emailTextField.text == "")
        {
            emailTextField.rightView = UIImageView(image: UIImage(named: "cancel"))
            errorvalid = false
        }
        else
        {
            emailTextField.rightView = UIImageView(image: UIImage(named: "checked"))
            
        }
        if(passwordTextField.text == "")
        {
            passwordTextField.rightView = UIImageView(image: UIImage(named: "cancel"))
            errorvalid = false
            
        }
        else
        {
            emailTextField.rightView = UIImageView(image: UIImage(named: "checked"))
            
        }
        if ( errorvalid == false)
        {
            
             var alert = UIAlertView(title: "Error", message: "Check Email and Password", delegate: nil, cancelButtonTitle: "OK")
            
            
            alert.show()
            return
        }
        
        
        //EZLoadingActivity.show("Logging in...", disableUI: true)
        SwiftSpinner.show(duration: 1.0, title: "Logging in...")

        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            // ...
            if let user = user{
                print(user.email!)
                
                print("User Loged")
                print(user)
                print(error?.localizedDescription)
                

                
                //EZLoadingActivity.hide(true, animated: true)
                SwiftSpinner.hide()
                self.dismiss(animated: true, completion: nil)

                
            }
            else{
              
                if (error?.localizedDescription == "The email address is badly formatted.")
                {
                    var alert = UIAlertView(title: "Error", message: "The email address is badly formatted", delegate: nil, cancelButtonTitle: "OK")
                    
                    
                    alert.show()
                    self.emailTextField.rightView = UIImageView(image: UIImage(named: "cancel"))
                    
                }
                else
                {
                    var alert = UIAlertView(title: "Error", message: "Check Email and Password", delegate: nil, cancelButtonTitle: "OK")
                    
                    
                    alert.show()
                    self.emailTextField.rightView = UIImageView(image: UIImage(named: "checked"))
                    self.passwordTextField.rightView = UIImageView(image: UIImage(named: "cancel"))
                    
                }
                
                //EZLoadingActivity.hide(false, animated: true)
                SwiftSpinner.hide()
                
            }
        }
        
    }
    
    
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    
}






extension UIViewController: TextFieldDelegate {
    /// Executed when the 'return' key is pressed when using the emailField.
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = true
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(textField: UITextField, didChange text: String?) {
        print("did change", text ?? "")
    }
    
    public func textField(textField: UITextField, willClear text: String?) {
        print("will clear", text ?? "")
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        print("did clear", text ?? "")
    }
}










