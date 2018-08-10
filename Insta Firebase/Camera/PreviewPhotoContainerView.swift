//
//  PreviewPhotoContainerView.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/4/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let photoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
        
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSave() {
        
        guard let previewImage = photoImageView.image else {return}
        let photoLibrary = PHPhotoLibrary.shared()
        
        photoLibrary.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print(error)
            }
            
            print("Successfully saved the photo")
            
            DispatchQueue.main.async {
                
                let saveLabel = UILabel()
                saveLabel.text = "Saved Successfully"
                saveLabel.font = UIFont.boldSystemFont(ofSize: 18)
                saveLabel.numberOfLines = 0
                saveLabel.textColor = .white
                saveLabel.textAlignment = .center
                saveLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                saveLabel.layer.cornerRadius = 5
                saveLabel.clipsToBounds = true
                
                saveLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                saveLabel.center = self.center
                
                self.addSubview(saveLabel)
                
                self.saveButton.isHidden = true
                self.saveButton.isEnabled = false
                
                saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        
                    }, completion: { (_) in
                        self.removeFromSuperview()
                    })
                })
            }
        }
    }
    
    @objc func handleCancelButton() {
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        addSubview(cancelButton)
        addSubview(saveButton)
        
        photoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        saveButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
