//
//  ViewController.swift
//  ImageUpload_With_ProgressBar_Swift
//
//  Created by DeEp KapaDia on 20/08/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var IMGView: UIImageView!
    @IBOutlet weak var LBL: UILabel!
    @IBOutlet weak var Progress: UIProgressView!
    @IBOutlet weak var BTN: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func BTN_Upload(_ sender: Any) {
        
        let MypickerController = UIImagePickerController()
        
        MypickerController.delegate = self
        MypickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(MypickerController, animated: true, completion: nil)
        
        
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        IMGView.image = info[UIImagePickerControllerOriginalImage] as? UIImage

        IMGView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage()
    {
        let imageData = UIImageJPEGRepresentation(IMGView.image!, 1)
        
        if(imageData == nil )  { return }
        
        self.BTN.isEnabled = false
        
        
        let uploadScriptUrl = NSURL(string:"http://www.swiftdeveloperblog.com/http-post-example-script/")
        let request = NSMutableURLRequest(url: uploadScriptUrl! as URL)
        request.httpMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        
        let configuration = URLSessionConfiguration.default
        let seesion1 = URLSession(session: configuration, task: self, didCompleteWithError: OperationQueue.main)
        
        let task = seesion1.uploadTask(with: request as URLRequest, from: imageData!)
        task.resume()
        
    }
    
    func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?)
    {
        let myAlert = UIAlertController(title: "Upload Error", message: "Please Check Your network connections", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        myAlert.addAction(ok)
        
        self.present(myAlert, animated: true, completion: nil)
        
        self.BTN.isEnabled = true

    }
    
    
    func URLSession(session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64)
    {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        
        Progress.progress = uploadProgress
        let progressPercent = Int(uploadProgress*100)
        LBL.text = "\(progressPercent)%"
        
    }
    
    func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void)
    {
        
        self.BTN.isEnabled = false
        
    }
    

}

