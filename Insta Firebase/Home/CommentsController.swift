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

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView?.backgroundColor = .white
        navigationItem.title = "Comments"
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 350, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
        commentsTextField.delegate = self
        
        fetchComments()
        
    }
    
    var comments = [Comment]()
    fileprivate func fetchComments() {
        guard let postId = self.postId else {return}
        let reference = Database.database().reference().child("comments").child(postId)
            
            reference.observe(.childAdded, with: { (snap) in
                guard let dictionary = snap.value as? [String : Any] else {return}
                let comment = Comment()
                guard let uid = dictionary["uid"] as? String else {return}
                
                Database.fetchUserWithUID(uid: uid, completion: { (user) in
                    
                    comment.comment = dictionary["comment"] as? String
                    comment.uid = user.uid
                    comment.user = user
                    
                    self.comments.append(comment)
                    self.collectionView?.reloadData()
                    
                    let indexPath = NSIndexPath(item: self.comments.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)

                })
        }, withCancel: nil)
        
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
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Send", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        let seperaterLine = UIView()
        seperaterLine.backgroundColor = UIColor.lightGray
        seperaterLine.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(commentsTextField)
        containerView.addSubview(submitButton)
        containerView.addSubview(seperaterLine)
        
        submitButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        
        commentsTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        commentsTextField.rightAnchor.constraint(equalTo: submitButton.leftAnchor).isActive = true
        commentsTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        commentsTextField.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
        seperaterLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperaterLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperaterLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperaterLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
        
    }()
    
    let commentsTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
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
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "Error updating the comment")
            }
            self.commentsTextField.text = ""

            print("Succesfully inserted the comment")
        } 
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}

extension CommentsController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let width = collectionView.frame.width
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}


















