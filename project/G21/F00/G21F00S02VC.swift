//
//  G21F00S02VC.swift
//  project
//
//  Created by SPJ on 10/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework
import AVFoundation
import AudioToolbox

class G21F00S02VC: BaseChildViewController {
    var captureSession: AVCaptureSession?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var imageFocus: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationBar(title: "QUÉT MÃ QRCODE")
        //self.showAlertWith(content: "abc")
        setupVideoPreviewLayer()
        // Do any additional setup after loading the view.
    }
    
    @objc func didChangeCaptureInputPortFormatDescription(notification: NSNotification) {
        if let metadataOutput = self.captureSession?.outputs.last as? AVCaptureMetadataOutput,
            let rect = self.videoPreviewLayer?.metadataOutputRectOfInterest(for: self.imageFocus.frame) {
            metadataOutput.rectOfInterest = rect
        }
    }
    
    func setupVideoPreviewLayer() {
        self.view.layoutIfNeeded()
        // tạo một instance của AVCaptureDevice, khởi tạo một device object và cung cấp một video như AVMediaType.video
        //let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            // tạo một instance của AVCaptureDeviceInput sử dụng device object đã khai báo ở trên
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            // khởi tạo captureSession, thằng này sẽ mở ra một session để thao tác hoàn toàn trên nó
            captureSession = AVCaptureSession()
            // set input cho session
            captureSession?.addInput(input)
            // khởi tạo một AVCaptureMetadataOutput và set nó là output device cho captureSession đã khai báo ở trên
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            // set delegate cho output. Lưu ý hãy để nó trên main Queue nhé.
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // set nhưng  type mà ta có thể nhận. Phần này nếu mở rộng để quét barcode thì bạn nên định nghĩa các type đó ra một mảng và set vào đây nhé
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            // Khởi tạo video preview layer, đoạn này chỉ đơn thuần là setup lần cuối :D
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            //self.cameraView.layer.addSublayer(videoPreviewLayer!)
            self.view.layer.addSublayer(videoPreviewLayer!)
            // layer
            let layerRect = self.cameraView.layer.bounds
            self.videoPreviewLayer?.frame = layerRect
            self.videoPreviewLayer?.position = CGPoint(x: layerRect.midX, y: layerRect.midY)
            // Start video capture.
            if self.captureSession?.isRunning == false {
                self.captureSession?.startRunning()
            }
            view.bringSubview(toFront: self.imageFocus)
            
        } catch {
            return
        }
    }
    
    func showAlertWith(content: String) {
        let alertController = UIAlertController(title: "Content Qr Code", message: content, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (alert) in
            //self.startScanQRcode()
            BaseModel.shared.sharedCode = content
            self.navigationController?.popViewController(animated: true)
            //self.pushToViewAndClearData(name: "G21F00S01VC")
        }
        let actionCancel = UIAlertAction(title: "Huỷ", style: .default) { (alert) in
            self.startScanQRcode()
//            BaseModel.shared.sharedCode = content
//            self.navigationController?.popViewController(animated: true)
            //self.pushToViewAndClearData(name: "G21F00S01VC")
        }
        alertController.addAction(actionCancel)
        alertController.addAction(actionOk)
        self.present(alertController, animated: true, completion: nil)
    }
    func startScanQRcode() {
        if self.captureSession?.isRunning == false {
            self.captureSession?.startRunning()
        }
    }
    
    func stopScanQRcode() {
        if self.captureSession?.isRunning == true {
            self.captureSession?.stopRunning()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // NotificationCenter
        NotificationCenter.default.addObserver(self, selector:#selector(self.didChangeCaptureInputPortFormatDescription(notification:)), name: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil)
        self.startScanQRcode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove notificationCenter
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil)
    }
}
extension G21F00S02VC: AVCaptureMetadataOutputObjectsDelegate {
//    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
////    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//        
//        if let value = metadataObj.stringValue, metadataObj.type == AVMetadataObjectTypeQRCode {
//            self.stopScanQRcode()
//            self.showAlertWith(content: value)
//        }
//    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            //qrCodeFrameView?.frame = CGRect.zero
            print("No QR code is detected")
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode {
//            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            //qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                //qrCodeFrameView?.frame = CGRect.zero
                self.stopScanQRcode()
                self.showAlertWith(content: metadataObj.stringValue)
                //print(metadataObj.stringValue)
                //pushToViewAndClearData(name: "G21F00S01VC")
            }
        }
    }
    
}
