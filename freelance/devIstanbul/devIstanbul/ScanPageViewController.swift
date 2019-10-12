//
//  ScanPageViewController.swift
//  devIstanbul
//
//  Created by Сергей Коршунов on 08.10.2019.
//  Copyright © 2019 SelimSelcuk. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import rebekka

class ScanPageViewController: UIViewController {

    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var result1Label: UILabel!
    @IBOutlet weak var result2Label: UILabel!
    @IBOutlet weak var result3Label: UILabel!
    
    @IBOutlet var ButtonsOutlet: [UIButton]!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var isCameraRunning = false
    var isPhotoTaken = false
    var isUploading = false
    var takenPhoto: UIImage!
    
    var resultMessage = String()
    
    let activityView = UIActivityIndicatorView(style: .white)
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let progressBar = UIProgressView(progressViewStyle: .default)
    let strLabel = UILabel()

    

    
    let processor = ScaledElementProcessor()
    var frameSublayer = CALayer()
    var scannedText: String = "" {
      didSet {
        if !scannedText.isEmpty {
            print(scannedText)
        }
        
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in ButtonsOutlet {
            button.layer.cornerRadius = 5
        }
        cameraView.layer.addSublayer(frameSublayer)
        drawFeatures(in: cameraView)
        
            
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        clearCameraView()
//        isCameraRunning = false
//        isPhotoTaken = false
//        takenPhoto = UIImage()
//        stopActivityViewAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.isPhotoTaken {
                //addPhotoToCameraView()
                self.drawFeatures(in: self.cameraView)
            } else if self.isCameraRunning {
                self.setupLivePreview()
            }
            if self.isUploading {
                self.startActivityViewAnimation()
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        drawFeatures(in: self.cameraView)
    }
    
    
    
    @IBAction func TapAction(_ sender: Any) {
        if !isUploading {
            takeAPicButtonAction(sender)
        }
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        if isUploading {
            dismiss(animated: true, completion: nil)
        }
        
        if isCameraRunning && !isPhotoTaken {
            clearCameraView()
            isCameraRunning = false
        } else if isPhotoTaken {
            isPhotoTaken = false
            takenPhoto = UIImage()
            clearCameraView()
        } else {
            dismiss(animated: true, completion: nil)
        }
        stopActivityViewAnimation()
    }
    
    @IBAction func takeAPicButtonAction(_ sender: Any) {
        if !isCameraRunning {
            let actionSheet = UIAlertController(title: "Photo source", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.setupCamera()
            }
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
                imagePicker.delegate = self
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(photoLibraryAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true, completion: nil)
        } else {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        }
    }
    
    func createTimeString() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let milisecond = calendar.component(.nanosecond, from: date) / 1000000
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        return "\(month)-\(day)-\(year)-\(hour)-\(minute)-\(second)-\(milisecond)"
    }
    
    func startActivityViewAnimation() {
        // setup activity view
        progressBar.removeFromSuperview()
        strLabel.removeFromSuperview()
        activityView.removeFromSuperview()
        effectView.removeFromSuperview()
        
        isUploading = true
        
        strLabel.frame = CGRect(x: 50, y: 0, width: 160, height: 46)
        strLabel.text = "Uploading"
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 60)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true

        activityView.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityView.startAnimating()
        
        progressBar.frame = CGRect(x: 15, y: 46, width: 130, height: 2)
        progressBar.progressTintColor = .white
        progressBar.progress = 0
        
        effectView.contentView.addSubview(activityView)
        effectView.contentView.addSubview(strLabel)
        effectView.contentView.addSubview(progressBar)
        view.addSubview(effectView)
        
        for button in ButtonsOutlet {
            button.isEnabled = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.ButtonsOutlet[0].isEnabled = true
        }
    }
    
    func stopActivityViewAnimation() {
        DispatchQueue.main.async {
            self.effectView.removeFromSuperview()
            self.isUploading = false

            for button in self.ButtonsOutlet {
                button.isEnabled = true
            }
           
        }
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        if !isPhotoTaken { return }
        if isUploading { return }
        
        if takenPhoto.pngData()!.count > 1000000 {
            let alertController = UIAlertController(title: "Error", message: "This image is too large to upload", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            print("image is too big")
            return
        }
        startActivityViewAnimation()
        
        
        let imageName = "\(createTimeString()).png"
        var imageURL : URL!
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("\(imageName)")
            if let imageData = takenPhoto.pngData() {
                try imageData.write(to: fileURL)
                
                
                imageURL = fileURL
            }
        } catch {
            stopActivityViewAnimation()
            print(error)
        }

        var configuration = SessionConfiguration()
        configuration.host = "ftp.bildirim.futbol"
        configuration.username = "samsunspor"
        configuration.password = "Fener1965"
        let session = Session(configuration: configuration)
        
        let path = "/http/Application/Assets/uploadedFiles/TicketPosts/\(imageName)"

        session.upload(imageURL, path: path, progressHandler: { (progress, total) in
            print("Progress: \(progress) of \(total) total")
//            DispatchQueue.main.async {
                self.progressBar.setProgress(Float(progress / total), animated: false)
//            }
            }) {
                (result, error) -> Void in
                print("File was uploaded: \(result), error: \(error?.localizedDescription ?? "no")\n\n")
                if result {
                    self.sendPOSTRequest(pictureName: imageName)
                    
                } else {
                    self.stopActivityViewAnimation()
                }
            }
        

    }
    
    func sendPOSTRequest(pictureName: String) {
        
        // create post request
        let url = URL(string: "https://bildirim.futbol/Application/esube/russia.ashx")!

        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: String] = [
            "pictureName": pictureName
        ]
        request.httpBody = parameters.percentEscaped().data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    self.stopActivityViewAnimation()
                    return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                self.stopActivityViewAnimation()
                return
            }

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                let responseCode = responseJSON["resultCode"] as! Int
                let responseString = responseJSON["resultMessage"] as! String
                if responseCode == 999 {
                    self.resultMessage = pictureName
                    DispatchQueue.main.async {
                        self.stopActivityViewAnimation()
                        self.performSegue(withIdentifier: "segueToResultPage", sender: nil)
                    }
                } else {
                    let alertController = UIAlertController(title: "Error Code: \(responseCode)", message: responseString, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    self.stopActivityViewAnimation()
                }
                
            }
        }

        task.resume()

    }
    
    func clearCameraView() {
        cameraView.image = nil
        if let layers = cameraView.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        cameraView.layer.addSublayer(frameSublayer)
        removeFrames()
        result1Label.text = "result 1:"
        result2Label.text = "result 2:"
        result3Label.text = "result 3:"
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: .video)
        
            else {
                print("Don't have access to back camera")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        } catch let error {
            print("Unable to initialize back camera:    \(error.localizedDescription)")
        }
        
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        var currentOrientation = AVCaptureVideoOrientation.portrait
        if UIDevice.current.orientation == .landscapeLeft {
            currentOrientation = .landscapeRight
        } else if UIDevice.current.orientation == .landscapeRight {
            currentOrientation = .landscapeLeft
        }
        videoPreviewLayer.connection?.videoOrientation = currentOrientation
        
        cameraView.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraView.bounds
            }
        }
        isCameraRunning = true
    }
    
    private func removeFrames() {
      guard let sublayers = frameSublayer.sublayers else { return }
      for sublayer in sublayers {
        sublayer.removeFromSuperlayer()
      }
    }
    
    func drawFeatures(in imageView: UIImageView, completion: (() -> Void)? = nil) {
        removeFrames()
        
        if cameraView.image != nil {
            
            let imageFrameX = cameraView.frame.origin.x - 10
            var imageFrameY = cameraView.frame.origin.y - 15
            
            let imageHeight = cameraView.frame.size.height / 5
            let imageWidth = cameraView.frame.size.width
            
            
            
            // layer 1
            let layer1 = CALayer()
            let purpleColor = UIColor.purple.cgColor.copy(alpha: 0.3)
            
            layer1.frame = CGRect(x: imageFrameX, y: imageFrameY, width: imageWidth, height: imageHeight)
            layer1.backgroundColor = purpleColor
            frameSublayer.addSublayer(layer1)
            imageFrameY += imageHeight
            
            // layer 2
            let layer2 = CALayer()
            let greenColor = UIColor.green.cgColor.copy(alpha: 0.5)
            
            layer2.frame = CGRect(x: imageFrameX, y: imageFrameY, width: imageWidth, height: imageHeight*3)
            layer2.backgroundColor = greenColor
            frameSublayer.addSublayer(layer2)
            imageFrameY += imageHeight*3
            
            // layer 3
            let layer3 = CALayer()
            let cyanColor = UIColor.cyan.cgColor.copy(alpha: 0.7)
            
            layer3.frame = CGRect(x: imageFrameX, y: imageFrameY, width: imageWidth, height: imageHeight)
            layer3.backgroundColor = cyanColor
            frameSublayer.addSublayer(layer3)
        }
        result1Label.text = "result 1:"
        result2Label.text = "result 2:"
        result3Label.text = "result 3:"
        processor.process(in: imageView) { text, elements in
          elements.forEach() { element in
            let border1 = self.cameraView.frame.size.height / 5
            let border2 = border1 * 4
            
            let elementYpos = element.frame.origin.y + element.frame.size.height / 2
            if elementYpos < border1 {
                self.result1Label.text! += " \(element.text)"
            } else if elementYpos > border2 {
                self.result3Label.text! += " \(element.text)"
            } else {
                self.result2Label.text! += " \(element.text)"
            }
            
            self.frameSublayer.addSublayer(element.shapeLayer)
          }
            
            if self.result1Label.text == "result 1:" {
                self.result1Label.text! += " There is no recognized text"
            }
            if self.result2Label.text == "result 2:" {
                self.result2Label.text! += " There is no recognized text"
            }
            if self.result3Label.text == "result 3:" {
                self.result3Label.text! += " There is no recognized text"
            }
          self.scannedText = text
            
          completion?()
        }
      }
    
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToResultPage" {
            let resultVC = segue.destination as! ResultPageViewController
            resultVC.resultMessage = resultMessage
            resultVC.uploadedImage = takenPhoto
        }
    }
    

}

extension ScanPageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        takenPhoto = (info[.originalImage] as? UIImage)
        addPhotoToCameraView()
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        takenPhoto = UIImage(data: imageData)
        addPhotoToCameraView()
    }
    
    func addPhotoToCameraView() {
        clearCameraView()
        cameraView.contentMode = .scaleAspectFit
        takenPhoto = takenPhoto.fixOrientation()
        cameraView.image = takenPhoto

        drawFeatures(in: cameraView)
        
        isCameraRunning = false
        isPhotoTaken = true
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
