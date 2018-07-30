//
//  UserProfileController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/23/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)
        
        setUpLogOutButton()
        
        fetchUser()
        fetchPosts()
    }
    
    var posts = [Posts]()
    
    fileprivate func fetchPosts(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
//            print(snapshot.value)
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            let post = Posts()
            post.imageUrl = dictionary["imageUrl"] as? String
            self.posts.append(post)
            
            self.collectionView?.reloadData()
            
        }, withCancel: nil)
        
    }
    
    fileprivate func setUpLogOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
//    let logInController = ViewController()
    
    @objc func handleLogOut(){
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
            
            do{
                try Auth.auth().signOut()
                let mainBarController = MainTabBarController()
//                let navController = UINavigationController(rootViewController: logInController)
                self.present(mainBarController, animated: true, completion: nil)
            }catch{
                print(error)
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARKUP :- Methods of CollectionView's Header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeaderCell
        
        headerCell.user = user
        
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //MARKUP :- Methods for the collectionView Cells
    
    let cellId = "cellId"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    var user: UserDetails?
    
    fileprivate func fetchUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
//            print(snapshot)
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            self.user = UserDetails(dictionary: dictionary)
            
            self.navigationItem.title = "ℑ𝔫𝔰𝔱𝔞𝔤𝔯𝔞𝔪"
            self.collectionView?.reloadData()
        }, withCancel: nil)
    }
}
