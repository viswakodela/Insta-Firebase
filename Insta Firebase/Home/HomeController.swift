//
//  HomeController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/30/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setUpNavigationItems()
        fetchPosts()
        
       fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else{return}
        Database.database().reference().child("following").child(currentUserId).observe(.childAdded) { (snapshot) in
            
            let uid = snapshot.key
//            guard let userIdsDictionary = snapshot.value as? [String : Any] else {return}
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                self.fetchPostsWithUser(user: user)
            })
        }
    }
    
    var posts = [Posts]()
    
    func fetchPosts(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        // This method is from Firebase utils file
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
        
//        Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String : Any] else {return}
//
//            let user = Users(uid: uid, dictionary: dictionary)
//
//            self.fetchPostsWithUser(user: user)
//        }
    }
    
    fileprivate func fetchPostsWithUser(user: Users){
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observe(.childAdded) { (snap) in
            guard let dictionary = snap.value as? [String : Any] else {return }
            
            let post = Posts()
            post.imageUrl = dictionary["imageUrl"] as? String
            post.caption = dictionary["caption"] as? String
            post.user = user
            
            guard let secondsFrom1970 = dictionary["creationDate"] as? Double else{return}
            post.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
            
            self.posts.insert(post, at: 0)
            
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate?.compare(p2.creationDate!) == .orderedDescending
            })
            
            self.collectionView?.reloadData()
        }
    }
    
    fileprivate func setUpNavigationItems(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    let cellId = "cellId"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8
        height = height + view.frame.width
        height += 50
        height += 80
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    
}




