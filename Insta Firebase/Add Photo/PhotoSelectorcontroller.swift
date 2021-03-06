//
//  PhotoSelectorcontroller.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/26/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Photos


class PhotoSelectorcontroller: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoSelectorHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        setUpNavigationButtons()
        fetchPhotos()
        
    }
    
    var images = [UIImage]()
    var assests = [PHAsset]()
    
    fileprivate func fetchPhotos(){
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                
                let fetchOptions = PHFetchOptions()
                let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
                fetchOptions.sortDescriptors = [sortDescriptor]
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
//                print("Found \(allPhotos.count) assets")
                DispatchQueue.global(qos: .background).async {
                    
                    allPhotos.enumerateObjects({ (asset, count, stop) in
                        let imageManager = PHImageManager()
                        let targetSize = CGSize(width: 200, height: 200)
                        let options = PHImageRequestOptions()
                        options.isSynchronous = true
                        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                            
                            if let image = image {
                                self.images.append(image)
                                self.assests.append(asset)
                                
                                if self.seletcedImage == nil {
                                    self.seletcedImage = self.images.first
                                }
                            }
                            if count == allPhotos.count - 1{
                                DispatchQueue.main.async {
                                    self.collectionView?.reloadData()
                                }
                            }
                        })
                    })
                }
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                // Should not see this when requesting
                print("Not determined yet")
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    fileprivate func setUpNavigationButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(NextButton))
    }
    @objc func cancel(){
        dismiss(animated: true, completion: nil)
    }
    @objc func NextButton(){
        
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = headerCell?.photoImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
        
    }
    
    
    
    //MARK :- CollectionView Cell Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    var seletcedImage: UIImage?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.seletcedImage = images[indexPath.item]
        self.collectionView?.reloadData()
        
        let indexpath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .bottom, animated: true)
    }
    
    
    
    // UICollectionViewDelegateFlowLayout Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    
    //MARK :- CollectionView Header Methods
    
    var headerCell: PhotoSelectorHeaderCell?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeaderCell
        
//        header.photoImageView.image = seletcedImage
        
        if let selectedImage = self.seletcedImage{
            let index = self.images.index(of: selectedImage)
            if let index = index{
                
                let selectedAsset = self.assests[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    
                    header.photoImageView.image = image
                    self.headerCell = header
                }
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    
    
    
    
}
