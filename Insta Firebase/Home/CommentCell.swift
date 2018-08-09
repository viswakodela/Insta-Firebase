//
//  CommentCell.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/8/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet{
//            print(comment?.comment ?? "")
            
            guard let commentText = comment?.comment else {return}
            guard let username = comment?.user?.username else {return}
            
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " " + commentText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black]))
            
            textView.attributedText = attributedText
            guard let imageUrl = comment?.user?.profileImageUrl else {return}
            profileImageView.loadImage(urlString: imageUrl)
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageview = CustomImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFill
        imageview.layer.cornerRadius = 20
        imageview.clipsToBounds = true
        return imageview
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(textView)
        
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        textView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 4).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
