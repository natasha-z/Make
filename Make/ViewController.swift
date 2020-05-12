//
//  ViewController.swift
//  Make
//
//  Created by Ataman on 10.05.2020.
//  Copyright © 2020 Ataman. All rights reserved.
//
import Photos
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightText
        
    }
    fileprivate func presentPhotoPickerController() {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true)
        }
    }
    
    @IBAction func imageTap(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    self.presentPhotoPickerController()
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        self.presentPhotoPickerController()
                    }
                case .restricted:
                    let alert = UIAlertController(title: "Access is Restricted", message: "To use this app, access to Photos Library should be allowed", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                case .denied:
                    let alert = UIAlertController(title: "Access is Denied", message: "To use this app, access to Photos Library should be allowed", preferredStyle: .alert)
                    DispatchQueue.main.async {
                        let goToSettingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
                            let url = URL(string: UIApplication.openSettingsURLString)!
                            UIApplication.shared.open(url, options: [:])
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                        alert.addAction(goToSettingsAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true)
                    }
                default:
                    break
                }
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.imageView.image = image
        } else if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

