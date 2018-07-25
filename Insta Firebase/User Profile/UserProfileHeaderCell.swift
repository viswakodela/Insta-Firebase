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
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 40
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
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
        
    }
    
    fileprivate func setUpToolBarStackView(){
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    var user: UserDetails? {
        didSet{
            setUpProfileImageView()
        }
    }
    
    func setUpProfileImageView(){
        
        guard let profileImageUrl = user?.profileImageUrl else { return }
        
        if let url = URL(string: profileImageUrl) {
            URLSession.shared.dataTask(with: url , completionHandler: { (data, respomse, error) in
                if error != nil {
                    print(error ?? "Error fetching the image from Firebase")
                }
                
                guard let data = data else { return }
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }).resume()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
