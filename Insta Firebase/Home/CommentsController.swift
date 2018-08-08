//
//  CommentsController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/4/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

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
        
        
        containerView.addSubview(commentsTextField)
        containerView.addSubview(submitButton)
        

        submitButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        
        commentsTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        commentsTextField.rightAnchor.constraint(equalTo: submitButton.leftAnchor).isActive = true
        commentsTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        commentsTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return containerView
        
    }()
    
    let commentsTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Type your comment..."
        return tf
    }()
    
    var postId: String?
    
    @objc func handleSend() {
        
        print("Handling Submit")
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//        print(postId)
        guard let postId = postId else {return}
        
        let values = ["comment" : commentsTextField.text ?? "", "creationDate" : Date().timeIntervalSince1970, "uid" : currentUserId] as [String : Any]
        
        Database.database().reference().child("comments").child(currentUserId).child(postId).updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "Error updating the comment")
            }

            print("Succesfully inserted the comment")
        
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
}
