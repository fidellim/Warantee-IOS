//
//  Image&VideoController.swift
//  warantee
//
//  Created by Mahmoud Elmohtasseb on 2019-12-17.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class Image_VideoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    enum ImageSource {
        case photoLibrary
        case camera
    }

    //Submit Button
    @IBAction func Submit(_ sender: Any) {
        
    }
    
    //VideoViewer
    @IBOutlet weak var VideoViewer: UIImageView!

    //Button To record a Video
    @IBAction func recordVideo(_ sender: Any) {
    }
    
    
    
   @IBOutlet weak var myImage: UIImageView!
    
   @IBAction func takePhoto(_ sender: Any) {
             // check if the camera is available
              if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    
                 let imagePicker = UIImagePickerController()
                     imagePicker.delegate = self
                     imagePicker.sourceType = UIImagePickerController.SourceType.camera
             
                     imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                 
                //Save the Image in the Gallery
//            UIImageWriteToSavedPhotosAlbum(imagePicker, self, #selector(image(_didFinihSavingWithError:contextinfo)), nil)
              
                 
                 //present(imagePicker, animated: true, completion: nil)
                 //UIImageWriteToSavedPhotosAlbum(imagePicker, nil, nil, nil)
                 
            }
            else {
                         //if camera is not availabe print this message
                print("Camera UnAvailable")
            }
    }
    
    
    func image(_ image:UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if let error = error {
            //we got back an error
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            
                ac.addAction(UIAlertAction(title: "Ok", style: .default ))
                present(ac, animated: true)
             }
        else {
            
            let ac = UIAlertController(title: "Saved!", message: "Your Alertered image has been saved to your photos", preferredStyle: .alert)
            
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
    }
   
    
    
 // function to view the picture in the image view
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) -> Bool{
        if let pickedImage = info[.originalImage] as? UIImage {
            myImage.contentMode = .scaleToFill
            myImage.image = pickedImage
            let data = pickedImage.jpegData(compressionQuality: 1.0)
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
               return false
            }
            do{
                try data!.write(to: directory.appendingPathComponent("image.jpg")!)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
   
       //  this allows the user to edit the picture
       picker.dismiss(animated: true, completion: nil)
        return true
    }
    
}
         
    
    
    
   
                
   
