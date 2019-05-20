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


class QRCodeInformation: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var backButton: UIButton!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrFrameView:UIView?
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        //let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        backButton.layer.cornerRadius = 10
        backButton.layer.zPosition = 1000
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
            popupView.backgroundColor = .clear
            /*
            let background = UIImageView(frame: popupView.frame)
            background.image = UIImage(named: "gradient")
            background.backgroundColor = .clear
            background.layer.zPosition = 100
 
            popupView.addSubview(background)
            */
            let name = UILabel()
            let description = UILabel()
            let dosage = UILabel()
            
            name.frame = CGRect(x: 25, y: 150, width: view.frame.width-50, height: 50)
            description.frame = CGRect(x: 25, y: 250, width: view.frame.width-50, height: 200)
            dosage.frame = CGRect(x: 25, y: 450, width: view.frame.width-50, height: 50)
            
            self.ref.child("medicine").observeSingleEvent(of: .value) { (snapshot) in
                print("has child: " + String(snapshot.hasChild(metadataObj.stringValue!)))
                print("QR Code: " + metadataObj.stringValue!)
                
                if(snapshot.hasChild(metadataObj.stringValue!)){
                    self.ref.child("medicine").child(metadataObj.stringValue!).observeSingleEvent(of: .value) { (snapshot) in
                        let array = snapshot.value as! NSMutableArray
                        name.text = array[1] as! String
                        description.text = array[2] as! String
                        dosage.text = array[3] as! String
                        print(array[1])
                        print(array[2])
                        print(array[3])
                    }
                }
            }
            
            view.addSubview(popupView)
            popupView.translatesAutoresizingMaskIntoConstraints = false
            popupView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            popupView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            
            popupView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
            popupView.layer.zPosition = 1
            
            popupView.addSubview(name)
            popupView.addSubview(description)
            popupView.addSubview(dosage)
            
            
            /*
            backButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            backButton.titleLabel?.backgroundColor = UIColor(red: 42/255, green: 205/255, blue: 163/255, alpha: 1)
            */
            name.layer.zPosition = 10
            description.layer.zPosition = 10
            dosage.layer.zPosition = 10
            
            name.textColor = UIColor(red: 21/255, green: 102/255, blue: 81/255, alpha: 1)
            description.textColor = UIColor(red: 21/255, green: 102/255, blue: 81/255, alpha: 1)
            dosage.textColor = UIColor(red: 21/255, green: 102/255, blue: 81/255, alpha: 1)
            
            name.font = UIFont(name: "AvenirNext-Medium", size: 40.0)
            description.font = UIFont(name: "AvenirNext-Medium", size: 20.0)
            dosage.font = UIFont(name: "AvenirNext-Medium", size: 20.0)
            
            description.numberOfLines = 0
            
            name.textAlignment = .center
            description.textAlignment = .center
            dosage.textAlignment = .center
            /*
            name.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: 0).isActive = true
            description.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: 0).isActive = true
            dosage.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: 0).isActive = true
            
            name.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 100).isActive = true
            description.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 50).isActive = true
            dosage.topAnchor.constraint(equalTo: description.bottomAnchor, constant: 50).isActive = true
            */
            updateViewConstraints()
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
