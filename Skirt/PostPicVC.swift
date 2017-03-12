//
//  PostPicVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/6/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit
import AVFoundation

class PostPicVC: AAPLCameraViewController, AAPLCameraVCDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var camView: AAPLPreviewView!
    
    @IBOutlet weak var takePicBtn: UIButton!
    @IBOutlet weak var rotateCamBtn: UIButton!
    
    var imagePicker: UIImagePickerController!

    
    override func viewDidLoad() {
        delegate = self
        _previewView = camView
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.allowsEditing = false

        
        
        var swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PostPicVC.showFirstViewController))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }

    @IBAction func takePicPressed(_ sender: Any) {
  
        snapStillImage()
    }

    @IBAction func rotateCamPressed(_ sender: Any) {
        changeCamera()
    }

    @IBAction func choseLibBtn(_ sender: Any) {
        
        present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: false, completion: nil)

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.performSegue(withIdentifier: "EmojiVC", sender: image)
        }
    }
    
    @IBAction func switchFlashBtn(_ sender: Any) {
     
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo )
        if (device!.hasTorch) {
            do {
                try device!.lockForConfiguration()
                if (device!.torchMode == AVCaptureTorchMode.on) {
                    device!.torchMode = AVCaptureTorchMode.off
                } else {
                    do {
                        try device!.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print(error)
                    }
                }
                device!.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
    func snapshotTaken(_ snapshotData: Data!) {
        performSegue(withIdentifier: "EmojiVC", sender: ["snapshotData":snapshotData])
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let emojiVC = segue.destination as? EmojiVC {
            if let snapDict = sender as? Dictionary<String,Data> {
                let snapData = snapDict["snapshotData"]
                emojiVC.imageData = snapData
            } else if let image = sender as? UIImage {
                    emojiVC.imageItself = image
            }
        }
    }

    func showFirstViewController() {
        self.performSegue(withIdentifier: "customSegueToPostVCUnwind", sender: self)
    }
    
    
    //unused protocol funcs
    func snapshotFailed() {
    }
    func shouldEnableCameraUI(_ enable: Bool) {
        rotateCamBtn.isEnabled = enable
        print("Should enable camera UI: \(enable)")
    }
    
    func shouldEnableRecordUI(_ enable: Bool) {
        takePicBtn.isEnabled = enable
        print("Should enable record UI: \(enable)")
    }
    
    func recordingHasStarted() {
        print("Recording has started")
    }
    
    func canStartRecording() {
        print("Can start recording")
    }
    
    func videoRecordingComplete(_ videoURL: URL!) {
    }
    
    func videoRecordingFailed() {
    }
}
