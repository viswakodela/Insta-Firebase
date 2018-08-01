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
        iv.contentMode = .scaleAspectFit
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
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(fileName)
        
        guard let image = selectedImage else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else{return}
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error != nil {
                print(error ?? "Error Uploading the image into the Firebase")
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error ?? "Error creating the downloadURl")
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
                
                if let imageUrl = url?.absoluteString{
                    
                    self.saveDataIntoFirebase(imageUrl: imageUrl)
                    
                }
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    fileprivate func saveDataIntoFirebase(imageUrl: String){
        
        guard let postImage = selectedImage else { return }
    
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postsRef = Database.database().reference().child("posts").child(uid).childByAutoId()
        guard let caption = textView.text else { return }
        
        let values: [String : Any] = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date.timeIntervalSinceReferenceDate]
        
        postsRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error ?? "Error Updating the values in Posts Node")
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    
}
