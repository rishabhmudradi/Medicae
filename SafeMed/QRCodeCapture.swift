//
//  QRCodeCapture.swift
//  SafeMed
//
//  Created by Shanky(Prgm) on 1/20/19.
//  Copyright © 2019 Shashank Venkatramani. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase


class QRCodeCapture: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var backButton: UIButton!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrFrameView:UIView?
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        backButton.layer.cornerRadius = 10
        backButton.layer.zPosition = 10
        ref = Database.database().reference()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            print(input.description)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetaDataOutput)
        
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height)
        view.layer.addSublayer(videoPreviewLayer)
        captureSession?.startRunning()
        
        qrFrameView = UIView()
        
        if let qrFrameView = qrFrameView {
            qrFrameView.layer.borderColor = UIColor.green.cgColor
            qrFrameView.layer.borderWidth = 2
            view.addSubview(qrFrameView)
            view.bringSubviewToFront(qrFrameView)
        }
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            print(metadataObj.stringValue)
            captureSession?.stopRunning()
            
            let popupView = UIView()
            
            
            self.ref.child("medicine").observeSingleEvent(of: .value) { (snapshot) in
                print("has child: " + String(snapshot.hasChild(metadataObj.stringValue!)))
                print("QR Code: " + metadataObj.stringValue!)
                
                if(snapshot.hasChild(metadataObj.stringValue!)){
                    self.ref.child("medicine").child(metadataObj.stringValue!).observeSingleEvent(of: .value) { (snapshot) in
                        let array = snapshot.value as! NSMutableArray
                        if(array[0] as! Int == 0){
                            //true
                            array[0] = true
                            self.ref.child("medicine").child(metadataObj.stringValue!).setValue(array)
                            popupView.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.9)
                            
                        } else {
                            popupView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.9)
                        }
                    }
                }
            }
            
            view.addSubview(popupView)
            popupView.translatesAutoresizingMaskIntoConstraints = false
            
            popupView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            
            popupView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
            popupView.layer.zPosition = 1
            backButton.layer.zPosition = 10
            
            let target = UITapGestureRecognizer(target: self, action: #selector(someAction(_:)))
            popupView.addGestureRecognizer(target)
        }
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "home") as! ViewController
        self.present(vc, animated: false, completion: nil)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
