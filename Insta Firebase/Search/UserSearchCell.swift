//
//  UserSearchCell.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/1/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserSearchCell: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 25
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    
    var user: Users?{
        didSet{
            
            guard let user = user else {return}
            let profileImageString = user.profileImageUrl
            profileImageView.loadImage(urlString: profileImageString)
            
            let attributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            
            Database.database().reference().child("posts").child(user.uid).observe(.value) { (snapshot) in
                attributedText.append(NSMutableAttributedString(string: "\n"+String(snapshot.childrenCount)+" posts", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.gray]))
                
                self.usernameLabel.attributedText = attributedText
            }
            
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(seperatorView)
        
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        seperatorView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true
        seperatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        seperatorView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
