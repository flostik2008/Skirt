//
//  PostPicVC.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/6/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import UIKit

class PostPicVC: AAPLCameraViewController, AAPLCameraVCDelegate {

    
    @IBOutlet weak var camView: AAPLPreviewView!
    
    @IBOutlet weak var takePicBtn: UIButton!
    @IBOutlet weak var rotateCamBtn: UIButton!
    
    
    override func viewDidLoad() {
        delegate = self
        _previewView = camView
        super.viewDidLoad()
    }

    @IBAction func takePicPressed(_ sender: Any) {
    // call for a func that is declared in AAPLCameraViewController.h file. 
       // snapStillImage()
        snapStillImage()
    }

    @IBAction func rotateCamPressed(_ sender: Any) {
        changeCamera()
    }

    @IBAction func choseLibBtn(_ sender: Any) {
        
    }
    
    @IBAction func switchFlashBtn(_ sender: Any) {
    }
    
    func snapshotTaken(_ snapshotData: Data!) {
        performSegue(withIdentifier: "EmojiVC", sender: ["snapshotData":snapshotData])
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let emojiVC = segue.destination as? EmojiVC {
            if let snapDict = sender as? Dictionary<String,Data> {
                let snapData = snapDict["snapshotData"]
                emojiVC.imageData = snapData
            }
        }
    }

    
    
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
