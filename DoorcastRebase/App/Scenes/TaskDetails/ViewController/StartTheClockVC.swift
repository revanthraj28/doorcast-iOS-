//
//  StartTheClockVC.swift
//  DoorcastRebase
//
//  Created by Codebele 09 on 10/05/22.
//

import UIKit

class StartTheClockVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    static var newInstance: StartTheClockVC? {
        let storyboard = UIStoryboard(name: Storyboard.taskDetails.name,
                                      bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className()) as? StartTheClockVC
        return vc
    }
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var startTheClockView: UIView!
    @IBOutlet weak var startTheClockLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var cancelImage: UIImageView!
    @IBOutlet weak var startTimerImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startView: UIView!
    
    var imagePicker: UIImagePickerController!
    var captured = String()
    var openCamera = Bool()
    var imageBase64 = String()
    var imageData = NSData()
    
    
    override func viewWillAppear(_ animated: Bool) {
   
        
        if captured == "true" {
            StartTheClock()
        } else {
            startCamera()
        }
        
        
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        CheckInternetConnection()
        
      
    }
    
   
    @objc func showTheClock() {
        print("startTheClockLabel")
        startTheClockLabel.text = "START THE CLOCK"
        startLabel.text = "You must start the task clock before you can complete sub-tasks."
        cancelImage.image = UIImage(named: "cancel")
        startTimerImage.image = UIImage(named: "startTimer")
    }
    
    @objc func startCamera() {
          startTheClockLabel.text = "UNIT REQUIRES PHOTO"
          startLabel.text = "This unit does not have a photo on record. Please take a photo of the front door before starting the timer."
          cancelImage.image = UIImage(named: "cancel")
          startTimerImage.image = UIImage(named: "camera-solid")
          self.openCamera = true
      }
    
    @IBAction func startButtonAction(_ sender: Any) {
        
        if openCamera == true {
            self.openGallery()
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            present(picker, animated: true)
             
        } else  {
            print("nothing")
        }
     }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.delegate = self
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            startTimerImage.image  = tempImage
        print("tempImage = \(tempImage)")
        
        let imageStringData = convertImageToBase64(image: tempImage)
                print("IMAGE base64 String: \(imageStringData)")
        
        let base64 = imageData.base64EncodedData(options: .lineLength64Characters)
            self.dismiss(animated: true, completion: nil)
        

    }

    
    func openGallery() {
            print("openGallery")
    
    print("UIImagePickerController")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.modalPresentationStyle = .fullScreen
                self.present(picker, animated: true, completion: nil)
    
            }else {
                print("Device has no photo library...")
            }
   
        }
  
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func updateUI() {
        cancelImage.layer.cornerRadius = 24
        startView.layer.cornerRadius = 26
        
        startView.layer.shadowColor = UIColor.gray.cgColor
        startView.layer.shadowOpacity = 0.5
        startView.layer.shadowRadius = 10
    
        
    }
    
    func CheckInternetConnection() {
        if ServiceManager.isConnection() == true {
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
            self.showAlertOnWindow(title: "No Internet Connection!", message: "Please check your internet connection and try again", titles: ["retry"]) { (key) in
                self.CheckInternetConnection()
            }
        }
    }
    
    func StartTheClock() {
        startTheClockLabel.text = "START THE CLOCK"
        startLabel.text = "You must start the task clock before you can complete sub-tasks."
        cancelImage.image = UIImage(named: "cancel")
        startTimerImage.image = UIImage(named: "startTimer")
        self.openCamera = false
        
    }
    
    
   
    
 
    
    
    

}


