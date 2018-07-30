//
//  CustomImageView.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/30/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String){
        
        lastURLUsedToLoadImage = urlString
        
        let imageUrl = urlString
        guard let url = URL(string: imageUrl) else {return}
        URLSession.shared.dataTask(with: url) { (data, respomse, error) in
            if error != nil {
                print(error ?? "")
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let data = data else {return}
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
        
    }
}
