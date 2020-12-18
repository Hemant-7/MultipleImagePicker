//
//  ViewController.swift
//  MultipleImagePicker
//
//  Created by Brain Tech on 24/09/2020 Saka.
//  Copyright © 1942 Brain Tech. All rights reserved.
//


//-----------Refrence---//https://iosexample.com/a-multiple-image-picker-for-ios/--------------

import UIKit
import BSImagePicker
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Properties
    var imagePicker = ImagePickerController()
    var arrOfImages = [UIImage]()
//    var arrOfSelectedImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnSelectImage(_ sender: UIButton) {
        showImagePicker()
    }
    func showImagePicker(){
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 100
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.settings.selection.unselectOnReachingMax = true
        
        let start = Date()
        self.presentImagePicker(imagePicker, select: { (asset) in
            print("Selected: \(asset)")
        }, deselect: { (asset) in
            print("Deselected: \(asset)")
        }, cancel: { (assets) in
            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            print("Finished with selections: \(assets)")
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
            requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            // this one is key
            requestOptions.isSynchronous = true
            
            for asset in assets
            {
                if (asset.mediaType == PHAssetMediaType.image)
                {
                    PHImageManager.default().requestImage(for: asset , targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (pickedImage, info) in
                        self.arrOfImages.append(pickedImage!)
                        print(self.arrOfImages)
                    })
                }
            }
            self.collectionView.reloadData()
        }, completion: {
            let finish = Date()
            print(finish.timeIntervalSince(start))
        })
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImages", for: indexPath) as! CellImages
        cell.selectedImages.image = arrOfImages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
