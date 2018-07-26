//
//  LoginController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/25/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedTitle = NSMutableAttributedString(string: "Dont have an account?  ", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
//        attributedText.append([])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleSignUpButton), for: .touchUpInside)
        return button
    }()
    
    let logoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "Instagram_logo_white")
        return iv
    }()
    
    let emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.08)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        tf.borderStyle = .roundedRect
        tf.placeholder = "Email"
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
    
    lazy var LoginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.tintColor = .white
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogInButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return button
    }()
    
    @objc func handleTextInputChange(){
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid{
            LoginButton.isEnabled = true
            LoginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }else{
            LoginButton.isEnabled = false
            LoginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc func handleLogInButton(){
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                print(error ?? "Error logging in")
            }
            
//            print(result?.user.uid)
            let mainTabController = MainTabBarController()
            
            self.present(mainTabController, animated: true, completion: nil)
        }
    }
    
    func stackViewForInputFields(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, LoginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: logoContainerView.bottomAnchor, constant: 40).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }

    
    func setUpButtonConstraints(){
        
        view.addSubview(signUpButton)
        
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 10).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        }
    
    func logoViewConstraints(){
        
        view.addSubview(logoContainerView)
        
        logoContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logoContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        logoContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        logoContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func logoImageViewConstraints(){
        
        view.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @objc func handleSignUpButton(){
        
        let signUpController = signUpViewController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        
        setUpButtonConstraints()
        logoViewConstraints()
        logoImageViewConstraints()
        stackViewForInputFields()
        
    }
}
