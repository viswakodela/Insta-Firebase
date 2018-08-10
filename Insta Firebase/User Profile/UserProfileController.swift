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

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate{
    
    var isGridView: Bool = true
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
    
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    let homePostCellId = "hoomePostCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfileCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
        collectionView?.alwaysBounceVertical = true
        
        setUpLogOutButton()
        
        fetchUser()
//        fetchPosts()
        
    }
    
    var userId: String?
        
    
    var posts = [Posts]()
    
    var user: Users?
    
    var isFinishedPaging = false
//    fileprivate func paginatePosts() {
//        print("Start paging for more posts")
//
//        guard let uid = self.user?.uid else { return }
//        let ref = Database.database().reference().child("posts").child(uid)
//
//        //        let value = "-Kh0B6AleC8OgIF-mZNT"
//        //        let query = ref.queryOrderedByKey().queryStarting(atValue: value).queryLimited(toFirst: 6)
//
//        //        var query = ref.queryOrderedByKey()
//
//        var query = ref.queryOrdered(byChild: "creationDate")
//
//        if posts.count > 0 {
//            //            let value = posts.last?.id
//            let value = posts.last?.creationDate?.timeIntervalSince1970
//            query = query.queryEnding(atValue: value)
//        }
//
//        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
//
//            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
//
//            allObjects.reverse()
//
//            if allObjects.count < 4 {
//                self.isFinishedPaging = true
//            }
//
//            if self.posts.count > 0 && allObjects.count > 0 {
//                allObjects.removeFirst()
//            }
//
////            guard let user = self.user else { return }
//
//            allObjects.forEach({ (snapshot) in
//
//                guard let dictionary: [String : Any] = snapshot.value as? [String : Any] else {return}
//                //                guard let postId = snapshot.key as? String else {return}
//                let post  = Posts()
//                post.imageUrl = dictionary["imageUrl"] as? String
//                post.user = self.user
//                post.postId = snapshot.key
//                post.caption = dictionary["caption"] as? String
//                guard let date = dictionary["creationDate"] as? Double else {return}
//                post.creationDate = Date(timeIntervalSinceReferenceDate: date)
//
//                self.posts.insert(post, at: 0)
//
//                //                print(snapshot.key)
//            })
//
//            self.posts.forEach({ (post) in
//                print(post.postId ?? "")
//            })
//
//            self.collectionView?.reloadData()
//
//
//        }) { (err) in
//            print("Failed to paginate for posts:", err)
//        }
//    }
    
    fileprivate func fetchUser(){
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
            
            self.fetchPosts()
//            self.paginatingPosts()
            
        }
    }
    

    fileprivate func paginatingPosts() {

        guard let uid = user?.uid else {return}
        let ref =  Database.database().reference().child("posts").child(uid)

        var query = ref.queryOrdered(byChild: "creationDate")

        if posts.count > 0 {
            let value = posts.last?.creationDate?.timeIntervalSinceReferenceDate
            query = query.queryEnding(atValue: value)
        }

        query.queryLimited(toLast: 6).observeSingleEvent(of: .value) { (snapshot) in

            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else {return}

            allObjects.reverse()

            if allObjects.count < 6 {
                self.isFinishedPaging = true
            }

            if self.posts.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            allObjects.forEach({ (snapshot) in
//                print(snapshot.key)

                guard let dictionary: [String : Any] = snapshot.value as? [String : Any] else {return}
//                guard let postId = snapshot.key as? String else {return}
                let post  = Posts()
                post.imageUrl = dictionary["imageUrl"] as? String
                post.user = self.user
                post.postId = snapshot.key
                post.caption = dictionary["caption"] as? String
                guard let date = dictionary["creationDate"] as? Double else {return}
                post.creationDate = Date(timeIntervalSinceReferenceDate: date)
                self.posts.append(post)

            })

//            self.posts.forEach({ (post) in
//                print(post.postId ?? "")
//            })

            self.collectionView?.reloadData()

        }
    }
    
    fileprivate func fetchPosts(){
        
        guard let uid = user?.uid else{return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
//            print(snapshot.value)
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            
            guard let user = self.user else {return}
            let post = Posts()
            post.imageUrl = dictionary["imageUrl"] as? String
            post.caption = dictionary["caption"] as? String
            post.user = user
            guard let date = dictionary["creationDate"] as? Double else{return}
            post.creationDate = Date(timeIntervalSinceReferenceDate: date)
            
            self.posts.insert(post, at: 0)
//            self.posts.append(post)
            
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate?.compare(p2.creationDate!) == .orderedDescending
            })
            
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
    
    //MARK:- Methods of CollectionView's Header
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeaderCell
        
        headerCell.user = user
        headerCell.delegate = self
        
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //MARK:- Methods for the collectionView Cells
    
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
        
        //How to fire off the paginate call
        
        if indexPath.item == posts.count - 1 && !isFinishedPaging {
            paginatingPosts()
        }
        
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCell
            cell.post = posts[indexPath.item]
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            var height: CGFloat = 40 + 8 + 8
            height = height + view.frame.width
            height += 50
            height += 60
            return CGSize(width: view.frame.width, height: height)
        }
        
    }
    
   
        
//        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
//
////            print(snapshot)
//            guard let dictionary = snapshot.value as? [String : Any] else {return}
//            self.user = Users(uid: uid, dictionary: dictionary)
//
//            self.navigationItem.title = self.user?.username
//            self.collectionView?.reloadData()
//        }, withCancel: nil)
    
}
