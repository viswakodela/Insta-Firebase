//
//  SharePhotoController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/28/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class SharePhotoController: UIViewController{
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    var selectedImage: UIImage? {
        didSet{
            imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setUpImageAndTextView()
        
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setUpImageAndTextView(){
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        containerView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        imageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 84).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        
        containerView.addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        
        
    }
    
    @objc func handleShare(){
        
        
        
    }
    
}
