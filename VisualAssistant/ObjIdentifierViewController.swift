//
//  ObjIdentifierViewController.swift
//  VisualAssistant
//
//  Created by George Leigh on 9/11/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ObjIdentifierViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    override var prefersStatusBarHidden: Bool{
        return true
    }
     
    @IBOutlet weak var belowView: UIView!
    
    
    @IBOutlet weak var objectName: UILabel!
    
   
    @IBOutlet weak var accuracy: UILabel!
    
    var model = Resnet50().model
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func startCamera(){
        let capture = AVCaptureSession()
        
        guard let capDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: capDevice) else { return }
        
        capture.addInput(input)
        
        capture.startRunning()
        
        let preview = AVCaptureVideoPreviewLayer(session: capture)
        view.layer.addSublayer(preview)
        
        preview.frame = view.frame
        
        //The camera has been created !!
        
        view.addSubview(belowView)
        
        belowView.clipsToBounds = true
        belowView.layer.cornerRadius = 15.0
        
        belowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        capture.addOutput(dataOutput)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for: model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            
            
            var name: String = firstObservation.identifier
            var accu: Int = Int(firstObservation.confidence * 100)
            
           
            
            var utterance = AVSpeechUtterance(string: "Holding the object in front of you and wait")
            var synth = AVSpeechSynthesizer()
            synth.speak(utterance)
            sleep(5)
            
            DispatchQueue.main.async {
                self.objectName.text = name
                self.accuracy.text = "Accuracy: \(accu) %"
            }
            
            utterance = AVSpeechUtterance(string: "The object is \(name) with accuracy \(accu).")
            synth = AVSpeechSynthesizer()
            synth.speak(utterance)
            
            sleep(8)
            
            utterance = AVSpeechUtterance(string: "Please wait 5 seonds to recgonize next object")
            synth = AVSpeechSynthesizer()
            synth.speak(utterance)
            
            sleep(5)
        }
        
        
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
    }
    
    @IBAction func startButton(_ sender: Any) {
        //For control the camera
        startCamera()
    }
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
