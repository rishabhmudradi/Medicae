//
//  CancerViewController.swift
//  healthHacks
//
//  Created by Rishabh Mudradi on 1/20/19.
//  Copyright © 2019 Rishabh Mudradi. All rights reserved.
//

import UIKit
import CoreML

class CancerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imagePickerView = UIImagePickerController()
        imagePickerView.delegate = self
        
        alert.addAction(UIAlertAction(title: "Choose Image", style: .default) { _ in
            imagePickerView.sourceType = .photoLibrary
            self.present(imagePickerView, animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Take Image", style: .default) { _ in
            imagePickerView.sourceType = .camera
            self.present(imagePickerView, animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        processImage(image)
    }
    
    func processImage(_ image: UIImage) {
        let model = FinalSkinCancer()
        let size = CGSize(width: 299, height: 299)
        
        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }
        
        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }
        
        let confidence = result.classLabelProbs["\(result.classLabel)"]! * 100.0
        let converted = String(format: "%.2f", confidence)
        
        imageView.image = image
        percentage.text = "\(converted) %"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
