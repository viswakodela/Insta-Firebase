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
        
        fetchUser()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeaderCell
        
        headerCell.user = user
        
        return headerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user: UserDetails?
    
    fileprivate func fetchUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            print(snapshot)
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            self.user = UserDetails(dictionary: dictionary)
            
            self.navigationItem.title = self.user?.userName
            self.collectionView?.reloadData()
        }, withCancel: nil)
    }
}
