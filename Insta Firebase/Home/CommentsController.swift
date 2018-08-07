//
//  CommentsController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/4/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .red
        navigationItem.title = "Comments"
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    lazy var containerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.backgroundColor = .white
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Send", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type your comment..."
        
        containerView.addSubview(textField)
        containerView.addSubview(submitButton)
        
        submitButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        
        textField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: submitButton.leftAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return containerView
        
    }()
    
    @objc func handleSend() {
        
        print("Handling Submit")
        
    }
    
    
    
    
    
    
    
}
