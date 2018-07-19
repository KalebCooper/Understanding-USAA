//
//  WebViewController.swift
//  Understanding USAA
//
//  Created by Kaleb Cooper on 7/18/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, URLSessionDataDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var importedTitle = ""
    var importedURL = ""
    
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
        
        self.title = importedTitle
        
        let url = URL(string: importedURL)

        print(importedURL)
        
        
        
        if let unwrappedURL = url {
            
            let request = URLRequest(url: unwrappedURL)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in

                if error == nil {
                    
                    DispatchQueue.main.async {
                        self.webView.load(request)
                    }

                }
                else {
                    print("ERROR: \(String(describing: error))")
                }
            }
            task.resume()
            
        }
        

        // Do any additional setup after loading the view.
    }
    
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(self.webView.estimatedProgress);
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.progressView.progress = Float(self.webView.estimatedProgress);
                }
            }
            
            if Float(self.webView.estimatedProgress) == 1.0 {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1.0) {
                        self.progressView.alpha = 0.0
                    }
                }
            }
            
            
            
        }
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
