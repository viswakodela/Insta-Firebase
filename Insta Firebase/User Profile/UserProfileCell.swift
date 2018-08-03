//
//  UserProfileCell.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/28/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class UserProfileCell: UICollectionViewCell{
    
    
    var post: Posts? {
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            photoImageView.loadImage(urlString: imageUrl)
        }
    }
    
    let photoImageView: CustomImageView = {
        
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        
        photoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
