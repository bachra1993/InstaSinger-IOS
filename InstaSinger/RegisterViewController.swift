//
//  RegisterViewController.swift
//  InstaSinger
//
//  Created by Trabelsi Firas on 11/9/16.
//  Copyright © 2016 Bechir Kaddech. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import Material
import EZLoadingActivity
import SwiftSpinner

class RegisterViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    
    
    //@IBOutlet weak var usernameTextField: ErrorTextField!
    
    @IBOutlet weak var fullnameTextField: ErrorTextField!
    
    
    @IBOutlet weak var emailTextField: ErrorTextField!
    
    @IBOutlet weak var passwordTextField: TextField!
    
    @IBOutlet weak var retypepasswordTextfield: TextField!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    // initiation du base
    let ref = FIRDatabase.database().reference(fromURL: "https://instasinger-e9947.firebaseio.com/")
    
    
    
    // deisgn textefields
    
    
    
    
   // private func prepareUsernameField() {
        
     //   usernameTextField.placeholder = "User Name"
      //  usernameTextField.placeholderNormalColor = .orange
      //  usernameTextField.placeholderActiveColor = .black
        
       // usernameTextField.detail = "Error, incorrect email"
      //  usernameTextField.isClearIconButtonEnabled = true
      //  usernameTextField.delegate = self
        
        
      //  let leftView = UIImageView()
      //  leftView.image = Icon.edit
        
      //  usernameTextField.leftView = leftView
      //  usernameTextField.leftViewMode = .always
      //  usernameTextField.leftViewNormalColor = .orange
      //  usernameTextField.leftViewActiveColor = .black
        
        // Set the colors for the emailField, different from the defaults.
        //        emailField.placeholderNormalColor = Color.amber.darken4
        //        emailField.placeholderActiveColor = Color.pink.base
        //        emailField.dividerNormalColor = Color.cyan.base
        //        emailField.dividerActiveColor = Color.green.base
        
   // }
    
    
    private func prepareFullnameField() {
        
        fullnameTextField.placeholder = "Full Name"
        fullnameTextField.placeholderNormalColor = .black
        fullnameTextField.placeholderActiveColor = .black
        
        fullnameTextField.detail = "Error, incorrect email"
        fullnameTextField.isClearIconButtonEnabled = true
        fullnameTextField.delegate = self
        
        
        let leftView = UIImageView()
        leftView.image = Icon.edit
        
        fullnameTextField.leftView = leftView
        fullnameTextField.leftViewMode = .always
        fullnameTextField.leftViewNormalColor = .black
        fullnameTextField.leftViewActiveColor = .black
        
        // Set the colors for the emailField, different from the defaults.
        //        emailField.placeholderNormalColor = Color.amber.darken4
        //        emailField.placeholderActiveColor = Color.pink.base
        //        emailField.dividerNormalColor = Color.cyan.base
        //        emailField.dividerActiveColor = Color.green.base
        
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
        
        passwordTextField.detailColor = .brown
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
    private func prepareRetypePasswordField() {
        retypepasswordTextfield.placeholder = "Retype your Password"
        retypepasswordTextfield.placeholderNormalColor = .black
        retypepasswordTextfield.placeholderActiveColor = .black
        
        retypepasswordTextfield.detailColor = .brown
        retypepasswordTextfield.clearButtonMode = .whileEditing
        retypepasswordTextfield.isVisibilityIconButtonEnabled = true
        let leftView = UIImageView()
        leftView.image = Icon.edit
        
        retypepasswordTextfield.leftView = leftView
        retypepasswordTextfield.leftViewMode = .always
        retypepasswordTextfield.leftViewNormalColor = .black
        retypepasswordTextfield.leftViewActiveColor = .black
        
        // Setting the visibilityIconButton color.
        retypepasswordTextfield.visibilityIconButton?.tintColor = Color.orange.withAlphaComponent(passwordTextField.isSecureTextEntry ? 0.38 : 0.54)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // prepareUsernameField()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
        prepareFullnameField()
        prepareEmailField()
        preparePasswordField()
        prepareRetypePasswordField()
        
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.isUserInteractionEnabled = true
        
        // profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        // profileImageView.layer.masksToBounds = true
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreafted.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    
    
    
    
    func handleSelectProfileImageView()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func signinTappedAction(_ sender: UIButton) {
        var errorvalide : Bool = true
        
        handleResignResponderButton()
        
       // if (usernameTextField.text == "")
      //  {
           // usernameTextField.rightView = UIImageView(image: UIImage(named: "cancel"))
      //      errorvalide = false
       // }
      //  else
      //  {
          //  usernameTextField.rightView = UIImageView(image: UIImage(named: "checked"))
            
       // }
        
        
        if (fullnameTextField.text == "")
        {
            fullnameTextField.rightView = UIImageView(image: UIImage(named: "cancel"))
            errorvalide = false
        }
        else
        {
            fullnameTextField.rightView = UIImageView(image: UIImage(named: "checked"))
            
        }
        if (emailTextField.text == "" )
        {
            emailTextField.rightView = UIImageView(image: UIImage(named: "cancel"))
            errorvalide = false
        }
        else
        {
            emailTextField.rightView = UIImageView(image: UIImage(named: "checked"))
            
        }
        if (passwordTextField.text == "")
        {
            passwordTextField.rightView = UIImageView(image: UIImage(named: "cancel"))
            errorvalide = false
        }
        else
        {
            passwordTextField.rightView = UIImageView(image: UIImage(named: "checked"))
            
        }
        if ((retypepasswordTextfield.text == "") || (retypepasswordTextfield.text != passwordTextField.text))
        {
            retypepasswordTextfield.rightView = UIImageView(image: UIImage(named: "cancel"))
            errorvalide = false
        }
        else
        {
            retypepasswordTextfield.rightView = UIImageView(image: UIImage(named: "checked"))
            
        }
        
        
        if (errorvalide == false)
        {
            var alert = UIAlertView(title: "Error", message: "Check your Information", delegate: nil, cancelButtonTitle: "OK")
            
            
            alert.show()
            return
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if (error?.localizedDescription != nil )
                {
                    
                //    var alert = UIAlertView(title: "Error", message: "The email address is badly formatted", delegate: nil, cancelButtonTitle: "OK")
                    
                    
                  //  alert.show()
                }
                else
                {
                    //EZLoadingActivity.show("Authentificating...", disableUI: true)
                    SwiftSpinner.show(progress: 0.2, title: "Authentificating...")
                    FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                    {
                        (user, error) in
                        // ...
                        if user != nil{
                            
                            print("User Loged")
                        }
                        
                        
                    }
                    let UID = FIRAuth.auth()?.currentUser?.uid
                    let storageref = FIRStorage.storage().reference().child(UID!+".png")
                    
                    if let uploaddata = UIImagePNGRepresentation(self.profileImageView.image!){
                        storageref.put(uploaddata, metadata: nil, completion:
                            { ( metadata , error) in
                                if (error != nil )
                                {
                                    return
                                }
                                let username : String = self.fullnameTextField.text! + self.randomString(length: 3)
                                let user = ["username" : username,
                                            "fullname" : self.fullnameTextField.text!,
                                            "email" : self.emailTextField.text!,
                                            "profilePictureURL" : metadata?.downloadURL()?.absoluteString]
                                self.regiterUsertoDatabase(UID: UID!, values: user as AnyObject)
                                SwiftSpinner.hide()
                                //EZLoadingActivity.hide(true, animated: true)
                                self.dismiss(animated: true, completion: nil)
                        }
                        )
                    }
                }
            }
        }
        
        
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
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton() {
     //   usernameTextField?.resignFirstResponder()
        fullnameTextField?.resignFirstResponder()
        emailTextField?.resignFirstResponder()
        passwordTextField?.resignFirstResponder()
        retypepasswordTextfield?.resignFirstResponder()
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
    
    
    @IBAction func cancelTappedAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"]
        {
            selectedImageFromPicker = editedImage as? UIImage
        } else if let originalImage = info["UIImagePickerController"]
        {
            
            selectedImageFromPicker = originalImage as? UIImage
            
        }
        if let selectImage = selectedImageFromPicker {
            profileImageView.image = selectImage
        }
        print(info)
        self.dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


