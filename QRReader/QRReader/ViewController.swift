//
//  ViewController.swift
//  QRReader
//
//  Created by Joshua Chang on 2018/10/5.
//  Copyright © 2018年 Joshua Chang. All rights reserved.
//

import UIKit
import AVFoundation

enum error: Error {
    case noCameraAvailble
    case videoInputInitFail
}

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var videoPreview: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    var avCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    var stringURL = String()
    var qrCodeFramView: UIView? //scan frame edge line
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            try scanBarCodes()
        } catch {
            print("Failed to scan the QRcode/Barcode.")
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if supportedBarCodes.contains(machineReadableCode.type) {
                
                // let barCodeObject = avCaptureVideoPreviewLayer?.transformedMetadataObject(for: machineReadableCode as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                // ???: - check effect
                // implement the scan frame edge line
                guard let barCodeObject = avCaptureVideoPreviewLayer?.transformedMetadataObject(for: machineReadableCode) as? AVMetadataMachineReadableCodeObject else {return}
                qrCodeFramView?.frame = barCodeObject.bounds
                
                stringURL = machineReadableCode.stringValue!
                messageLabel.text = machineReadableCode.stringValue!
                performSegue(withIdentifier: "openLink", sender: self)
            }
        } else {
            qrCodeFramView?.frame = CGRect.zero
            messageLabel.text = "No barcode/QR code is detected"
            return
        }
    }
    
    func scanBarCodes() throws {
        // init AVCaptureDevice with 'AVMediaType.video' for capture video
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("No camera.")
            throw error.noCameraAvailble
        }
        
        // use captureDevice to get the object of AVCaptureDeviceInput
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Failed to init camera.")
            throw error.videoInputInitFail
        }
        
        // MARK: - init AVCaptureSession() to setting input device
        let avCaptureSession = AVCaptureSession()
        avCaptureSession.addInput(avCaptureInput)
        
        // MARK: - init AVCaptureMetadataOutput() to catch the output device of AVCaptureSession()
        let avCaptureMetaOutput = AVCaptureMetadataOutput()
        avCaptureSession.addOutput(avCaptureMetaOutput)
        
        // perform delegate and use the default dispatch queue to execute the call back
        avCaptureMetaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // Detect all the supported bar code
        avCaptureMetaOutput.metadataObjectTypes = supportedBarCodes
        
        // MARK: - Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer?.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer!)
        
        // video capture start
        avCaptureSession.startRunning()
        
        // Move the message label to the top view
        view.bringSubviewToFront(messageLabel)
        
        // Initialize scan frame to highlight the QR code
        qrCodeFramView = UIView()
        qrCodeFramView?.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        qrCodeFramView?.layer.borderWidth = 3
        view.addSubview(qrCodeFramView!)
        view.bringSubviewToFront(qrCodeFramView!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openLink" {
            let destination = segue.destination as! WebViewController
            destination.url = URL(string: stringURL)
        }
    }
}

