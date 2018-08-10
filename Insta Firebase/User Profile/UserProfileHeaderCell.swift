//
//  UserProfileHeaderCell.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/24/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeaderCell: UICollectionViewCell{
    
    var delegate: UserProfileHeaderDelegate?
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 40
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Viswajith Kodela"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
//        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChnageGridView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChnageGridView() {
        
        print("Chnaging to grid View")
        listButton.tintColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        gridButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        delegate?.didChangeToGridView()
        
    }
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToListView() {
        
        print("Changing to List View")
        listButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        gridButton.tintColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        delegate?.didChangeToListView()
        
    }
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
        
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
        
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
        
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(handleEditProfileFollowButton), for: .touchUpInside)
        return button
    }()
    
    var user: Users? {
        didSet{
            
            self.userNameLabel.text = self.user?.username
            guard let urlString = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: urlString)
            guard let uid = user?.uid else {return}
            
            postsFollowersFollowingLabelSetUp(uid: uid)
            setEditFollowButton()
        }
    }
    
    func postsFollowersFollowingLabelSetUp(uid: String) {
        
        
        Database.database().reference().child("posts").child(uid).observe(.value) { (snap) in
            let numberOfPosts = snap.childrenCount
            //                print(snap.childrenCount)
            
            let postLabelAttributedText = NSMutableAttributedString(string: String(numberOfPosts)+"\n", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14)])
            
            postLabelAttributedText.append(NSAttributedString(string: "posts", attributes: [ kCTForegroundColorAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
            
            Database.database().reference().child("following").child(uid).observe(.value, with: { (snapshot) in
                let followingattributedText = NSMutableAttributedString(string: String(snapshot.childrenCount)+"\n" , attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14)])
                
                followingattributedText.append(NSAttributedString(string: "following", attributes: [  kCTForegroundColorAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
                
                self.followingLabel.attributedText = followingattributedText
            })
            
            Database.database().reference().child("followers").child(uid).observe(.value, with: { (snapshot) in
                let attributedText = NSMutableAttributedString(string: String(snapshot.childrenCount)+"\n", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14)])
                
                attributedText.append(NSAttributedString(string: "followers", attributes: [  kCTForegroundColorAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
                self.followersLabel.attributedText = attributedText
            })
            
            self.postsLabel.attributedText = postLabelAttributedText
        }
    }
    
    func setEditFollowButton(){
        
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if currentLoggedInUser == userId{
            
            editProfileFollowButton.setTitle("Edit profile", for: .normal)
            
        }else{
        Database.database().reference().child("following").child(currentLoggedInUser).child(userId).observe(.value) { (snap) in
                
                if let isFollwing = snap.value as? Int, isFollwing == 1 {
                    //Unfollow
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    self.editProfileFollowButton.setTitleColor(.white, for: .normal)
                    self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
                    self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.7).cgColor
                }else {
                    //Follow
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                    self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
                    self.editProfileFollowButton.setTitleColor(.white, for: .normal)
                    self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.7).cgColor
                    
                }
            }
        }
    }
    
   
    
    @objc func handleEditProfileFollowButton(){
        
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else{return}
        guard let userId = user?.uid else {return}
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow"{
            
        //Unfollow
        Database.database().reference().child("following").child(currentLoggedInUser).child(userId).removeValue { (error, ref) in
                if error != nil{
                    print(error ?? "Error Unfollwing the user")
                }
                print("Unfollowing the user Successfully")
            }
            Database.database().reference().child("followers").child(userId).child(currentLoggedInUser).removeValue { (error, ref) in
                if error != nil {
                    print(error ?? "Error")
                }
            }
            
        }else{
            
            //MARK:- Following Node
            let followingReference = Database.database().reference().child("following").child(currentLoggedInUser)
            
            
            
            //MARK:- Follwers Node
            let followersReference = Database.database().reference().child("followers").child(userId)
            let followersvalues = [currentLoggedInUser : 1]
            followersReference.updateChildValues(followersvalues) { (error, ref) in
                if error != nil {
                    print(error ?? "Error Followinmg the user")
                }
            }
            
            
            
            
            //MARK:- Follwing Node Continues
            let followingvalues = [userId: 1]
            
            followingReference.updateChildValues(followingvalues) { (error, ref) in
                if error != nil {
                    print(error ?? "Error following the user")
                }
                    print("Following the user successfully")
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .blue
        
        addSubview(profileImageView)
        
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        setUpToolBarStackView()
        setupUserStatsView()
        
        addSubview(editProfileFollowButton)
        
        editProfileFollowButton.topAnchor.constraint(equalTo: postsLabel.bottomAnchor, constant: 5).isActive = true
        editProfileFollowButton.leftAnchor.constraint(equalTo: postsLabel.leftAnchor).isActive = true
        editProfileFollowButton.rightAnchor.constraint(equalTo: followingLabel.rightAnchor).isActive = true
        editProfileFollowButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    fileprivate func setupUserStatsView(){
        
        let statsStackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        statsStackView.distribution = .fillEqually
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.axis = .horizontal
        
        addSubview(statsStackView)
        
        statsStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        statsStackView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        statsStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        statsStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    fileprivate func setUpToolBarStackView(){
        
        let topDividerView = UIView()
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(userNameLabel)
        
        userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 12).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        
        addSubview(topDividerView)
        
        topDividerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        topDividerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        topDividerView.bottomAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        topDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(bottomDividerView)
        
        bottomDividerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomDividerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomDividerView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        bottomDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
