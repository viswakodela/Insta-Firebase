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

class UserProfileHeaderCell: UICollectionViewCell{
    
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
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
//        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts", attributes: [ kCTForegroundColorAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
        
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "followers", attributes: [  kCTForegroundColorAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
        
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "following", attributes: [  kCTForegroundColorAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
            label.attributedText = attributedText
            
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
        
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 3
        return button
    }()
    
    
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
        
        addSubview(editProfileButton)
        
        editProfileButton.topAnchor.constraint(equalTo: postsLabel.bottomAnchor, constant: 5).isActive = true
        editProfileButton.leftAnchor.constraint(equalTo: postsLabel.leftAnchor).isActive = true
        editProfileButton.rightAnchor.constraint(equalTo: followingLabel.rightAnchor).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
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
    
    var user: Users? {
        didSet{
            
            self.userNameLabel.text = self.user?.username
            guard let urlString = user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: urlString)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
