//
//  ViewController.swift
//  QRCodeScanSwift
//
//  Created by Nodirbek on 28/06/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideo()
        // test
    }

    func setupVideo(){
        // 1. Nastroit session
//        let session = AVCaptureSession()
        // 2. Nastraivaem ustroystvo video
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        // 3. Nastroim input
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        // 4. Nastroim output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        // 5
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
    }
    //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
    
    func startRunning(){
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    func stopScanning(){
        video.removeFromSuperlayer()
        session.stopRunning()
    }
    
    @IBAction func startVideoTapped(_ sender: UIButton){
        startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                // do smthing
                print("Nodir ", object.stringValue)
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Pereyti", style: .default, handler: { action in
                    print(object.stringValue)
                }))
                alert.addAction(UIAlertAction(title: "Kopirovat", style: .default, handler: { action in
                    UIPasteboard.general.string = object.stringValue
                    print(object.stringValue)
                }))
                present(alert, animated: true)
            }
        }
    }

}

//import NFCPassportReader
//
//class PassportUtils {
//
//    func getMRZKey(passportNumber: String, dateOfBirth: String, dateOfExpiry: String ) -> String {
//
//        // Pad fields if necessary
//        //print("passportNumber: \(passportNumber)")
//        //print("dateOfBirth: \(dateOfBirth)")
//        //print("dateOfExpiry: \(dateOfExpiry)")
//        let pptNr = pad( passportNumber, fieldLength:9)
//        let dob = pad(dateOfBirth, fieldLength:6)
//        let exp = pad(dateOfExpiry, fieldLength:6)
//        //print("pptNr: \(pptNr)")
//        //print("dob: \(dob)")
//        //print("exp: \(exp)")
//        // Calculate checksums
//        let passportNrChksum = calcCheckSum(pptNr)
//        let dateOfBirthChksum = calcCheckSum(dob)
//        let expiryDateChksum = calcCheckSum(exp)
//
//        //print("passportNrChksum: \(passportNrChksum)")
//        //print("dateOfBirthChksum: \(dateOfBirthChksum)")
//        //print("expiryDateChksum: \(expiryDateChksum)")
//        let mrzKey = "\(pptNr)\(passportNrChksum)\(dob)\(dateOfBirthChksum)\(exp)\(expiryDateChksum)"
//
//        return mrzKey
//    }
//
//    func pad( _ value : String, fieldLength:Int ) -> String {
//        // Pad out field lengths with < if they are too short
//        let paddedValue = (value + String(repeating: "<", count: fieldLength)).prefix(fieldLength)
//        return String(paddedValue)
//    }
//
//    func calcCheckSum( _ checkString : String ) -> Int {
//        let characterDict  = ["0" : "0", "1" : "1", "2" : "2", "3" : "3", "4" : "4", "5" : "5", "6" : "6", "7" : "7", "8" : "8", "9" : "9", "<" : "0", " " : "0", "A" : "10", "B" : "11", "C" : "12", "D" : "13", "E" : "14", "F" : "15", "G" : "16", "H" : "17", "I" : "18", "J" : "19", "K" : "20", "L" : "21", "M" : "22", "N" : "23", "O" : "24", "P" : "25", "Q" : "26", "R" : "27", "S" : "28","T" : "29", "U" : "30", "V" : "31", "W" : "32", "X" : "33", "Y" : "34", "Z" : "35"]
//
//        var sum = 0
//        var m = 0
//        let multipliers : [Int] = [7, 3, 1]
//        for c in checkString {
//            guard let lookup = characterDict["\(c)"],
//                let number = Int(lookup) else { return 0 }
//            let product = number * multipliers[m]
//            sum += product
//            m = (m+1) % 3
//        }
//
//        return (sum % 10)
//    }
//}
