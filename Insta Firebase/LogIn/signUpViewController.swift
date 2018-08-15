//
//  ViewController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/21/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseMessaging

class signUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(plusPhotoButton)
        plusButtonConstraints()
        
        setUpTextFields()
        signInBottomButtonConstraints()
        
    }
    
    let plusPhotoButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlusPhotoButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhotoButton(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.height / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
        
    }
    
    func plusButtonConstraints(){
        
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        plusPhotoButton.heightAnchor.constraint(equalToConstant: 150).isActive = true
        plusPhotoButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    let emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.08)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.borderStyle = .roundedRect
        tf.placeholder = "Email"
        return tf
    }()
    
    @objc func handleTextInputChange(){
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    let userNameTextField: UITextField = {
        
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.08)
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.placeholder = "Username"
        return tf
    }()
    
    let passwordTextField: UITextField = {
        
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.08)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.borderStyle = .roundedRect
        tf.placeholder = "Password"
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    let value = 1...5
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account  ", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        //        attributedText.append([])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignInButton(){
        navigationController?.popViewController(animated: true)
    }
    
    func signInBottomButtonConstraints(){
        
        view.addSubview(logInButton)
        
        logInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        logInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
        logInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setUpTextFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
                                     stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                                     stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
                                     stackView.heightAnchor.constraint(equalToConstant: 200)])
    }
    
    @objc func handleSignUp(){
        
        guard let email = emailTextField.text, email.count > 0 else{return}
        guard let password = passwordTextField.text, password.count > 0 else{return}
        guard let userName = userNameTextField.text, userName.count > 0 else{return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error ?? "Not able to register")
            }
            
            print("User successfully created:", result?.user.uid ?? "" )
            
            guard let image = self.plusPhotoButton.imageView?.image else{return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else{return}
            
            let profileImageUniqueId = NSUUID().uuidString
            let profileImageStorageRef = Storage.storage().reference().child("profile_images").child(profileImageUniqueId)
            profileImageStorageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error ?? "Error Uplading the Image into the Firebase Storage")
                    }
                
                profileImageStorageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error ?? "Error getting the Url for the Image")
                    }
                    
                    guard let profileImageUrl = url?.absoluteString else {return}
                    guard let fcmToken = Messaging.messaging().fcmToken else {return}
                   
                    let values: [String : AnyObject] = ["username": userName, "email": email, "profileImageUrl": profileImageUrl, "fcmToken": fcmToken] as [String : AnyObject]
                    
                    if let uid = result?.user.uid{
                        let usersRef = Database.database().reference().child("users").child(uid)
                        
                        usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error ?? "Error updating the Values")
                            }
                            let mainController = MainTabBarController()
                            self.present(mainController, animated: true, completion: nil)
                        })
                    }
                })
            })
        }
    }
    
}

