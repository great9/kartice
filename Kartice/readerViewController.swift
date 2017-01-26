//
//  ViewController.swift
//  barcodeScanner
//
//  Created by Darko Dujmovic on 07/11/2016.
//  Copyright © 2016 Darko Dujmovic. All rights reserved.
//
import AVFoundation
import UIKit

protocol passData {
    func barcodeScanned(code: String, type:String)
}

class readerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var barcodeParserObj = barcodeParser()
    var delegate: passData?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var readerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeITF14Code]
        } else {
            failed()
            return
        }
        
       
        
        
        
        let halfOfTheView:CGFloat = (self.view.frame.width/CGFloat(2))
        let widthOfTheButton:CGFloat = (self.view.frame.width * 0.8)
        let positionOfButton = halfOfTheView - (widthOfTheButton/2)
        //position and size of cancel button
        let positionForCancelButton:CGRect = CGRect(x: positionOfButton ,
                                                    y: self.view.bounds.maxY - 140,
                                                    width: widthOfTheButton,
                                                    height: 60)
        
        let positionForTorchButton:CGRect = CGRect(x: positionOfButton,
                                                   y: self.view.bounds.minY + 50,
                                                   width: widthOfTheButton,
                                                   height: 40)
        
        //cancel button
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        
        cancelButton.frame = positionForCancelButton
        cancelButton.backgroundColor = customColors.scheme1Color4
        cancelButton.addTarget(self, action: #selector(closeViewFinder), for: .touchUpInside)
        
        //torch
        let torch = UIButton()
        torch.setTitle("💡", for: .normal)
        torch.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 35)
        
        torch.frame = positionForTorchButton
        //torch.backgroundColor = customColors.scheme1Color2
        torch.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        self.view.addSubview(cancelButton)
        self.view.addSubview(torch)
       
        captureSession.startRunning()
    }
    
    func closeViewFinder(){
    
        self.dismiss(animated: true, completion: nil)
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported",
                                   message: "Your device does not support scanning a code from an item. Please use a device with a camera.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            let systemSoundID: SystemSoundID = 1057
            AudioServicesPlaySystemSound(systemSoundID)
            
            if let del = delegate{

                del.barcodeScanned(code: readableObject.stringValue, type:readableObject.type!)
            }
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        readerLabel.text = code
        
    }
    
    func toggleTorch(){
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)!{
            do{
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureTorchMode.on){
                    device?.torchMode = AVCaptureTorchMode.off
                }else{
                    do {
                        try device?.setTorchModeOnWithLevel(1.0)
                    } catch {
                        print("Error trying to set torch mode")
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print("Error trying to lock for configuration")
                
            }
        
        }
    
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    
}




