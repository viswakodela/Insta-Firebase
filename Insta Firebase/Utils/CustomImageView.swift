//
//  CustomImageView.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/30/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
  
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String){
        
        self.image = nil
        
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        
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
            
            imageCache[url.absoluteString] = image
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
