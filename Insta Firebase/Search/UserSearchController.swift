//
//  UserSearchController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/1/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter search text"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
            if searchText.isEmpty {
                filteredUsers = users
            }
            else{
                self.filteredUsers = users.filter { (user) -> Bool in
                    return user.username.lowercased().contains(searchText.lowercased())
                }
            }
        collectionView?.reloadData()
    }
    
    
    fileprivate func searchBarConstraints(){
        
        guard let navBar = navigationController?.navigationBar else {return}
        
        searchBar.topAnchor.constraint(equalTo: navBar.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: 8).isActive = true
        searchBar.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -8).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        navigationController?.navigationBar.addSubview(searchBar)
        searchBarConstraints()
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .onDrag
        
        fetchUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    var filteredUsers = [Users]()
    var users = [Users]()
    fileprivate func fetchUsers(){
        
        let ref = Database.database().reference().child("users")
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            
            let uid = snapshot.key
            
            if uid == Auth.auth().currentUser?.uid{
                return
            }
            
            let user = Users(uid: uid, dictionary: dictionary)

            self.users.append(user)
            
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
            
//            dictionary.forEach({ (key, value) in
//
//                guard let userDictionary = value as? [String : Any] else {return}
//
//                let user = Users(uid: key, dictionary: userDictionary)
//                self.users.append(user)
            
            })
        
        
        
    }
    
    let cellId = "cellId"
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        
        return CGSize(width: width, height: 60)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let selectedUser = filteredUsers[indexPath.item].uid
        
        
        let selectedUserProfile = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        selectedUserProfile.userId = selectedUser
        navigationController?.pushViewController(selectedUserProfile, animated: true)
        
        
    }
    
    
    
    
}
