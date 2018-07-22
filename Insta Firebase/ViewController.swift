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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusPhotoButton)
        plusButtonConstraints()
        
        setUpTextFields()
        
    }
    
    let plusPhotoButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    @objc func handleSignUp(){
        
        guard let email = emailTextField.text, email.characters.count > 0 else{return}
        guard let password = passwordTextField.text, password.characters.count > 0 else{return}
        guard let userName = userNameTextField.text, userName.characters.count > 0 else{return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error ?? "Not able to register")
            }
            
            print("User successfully created:", result?.user.uid ?? "" )
        }
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
    
    
    
    
}

