//
//  SaveImageViewController.swift
//  GreenTech
//
//  Created by HyagoHirai on 01/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SaveImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let service = FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func takePhotoButton(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion:nil)
    }
    
    @IBAction func selectPhotoButton(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        uploadPhotoStorage(image)
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadPhotoStorage(_ image: UIImage) {
        //let imageResize = image.resizeWith(0.1)
        //let imageData: Data = UIImagePNGRepresentation(imageResize!)!
        //let path = "images/rivers.jpg"
        //service.uploadDataStorage(imageData, path: path)
    }
}
