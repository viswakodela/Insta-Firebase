//
//  CameraController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 8/3/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCaptureSession()
        constraints()
        
    }
    
    let captureButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapture), for: .touchUpInside)
        return button
    }()
    
    let dismissButtom: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss()
    {
        dismiss(animated: true, completion: nil)
    }
    
    func constraints() {
        
        view.addSubview(captureButton)
        view.addSubview(dismissButtom)
        
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dismissButtom.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        dismissButtom.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        dismissButtom.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dismissButtom.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    @objc func handleCapture() {
        
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else {return}
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey: previewFormatType] as [String : Any]
        
        captureOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        let previewImage = UIImage(data: imageData!)
        
        let previewImageView = UIImageView(image: previewImage)
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewImageView)
        
        previewImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previewImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        previewImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
    }
    
    let captureOutput = AVCapturePhotoOutput()
    
    func setUpCaptureSession() {
        
        let captureSession = AVCaptureSession()
        
        
        //1. - set up Input
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        do {
            let captureInput = try AVCaptureDeviceInput(device: captureDevice)
            
            if captureSession.canAddInput(captureInput){
                captureSession.addInput(captureInput)
            }
        }catch {
            print(error)
        }
        
        // 2. - set up Output
        
        if captureSession.canAddOutput(captureOutput){
            captureSession.addOutput(captureOutput)
        }
        
        //3. Set up preview Layer
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
    }
}
