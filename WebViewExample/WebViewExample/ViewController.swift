//
//  ViewController.swift
//  WebViewExample
//
//  Created by 張書彬 on 2017/12/25.
//  Copyright © 2017年 Joshua Chang. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        urlTextField.delegate = self // also to ensure that urlTextField is delegate
        
        webView.navigationDelegate = self // once have that hooked up and get callbacks on delegate
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // get called when view comes on to the screen
        let urlString:String = "https://www.apple.com"
        
        let url:URL = URL(string: urlString)!
        // let url as an object not just as string
        // and don't type in string literals here as such as website address
        
        let urlRequest:URLRequest = URLRequest(url: url) //A URL load request
        webView.load(urlRequest) // present the website on webView element
        
        urlTextField.text = urlString // present current website address
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //process that string that's user type in website address and retrn a boolean
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let urlString:String = urlTextField.text!
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        textField.resignFirstResponder()
        //dismiss keynoard after the text field is hit and return
        
        return true
    }

    
    
    // shall go to call an action on the webview for enable those button
    @IBAction func backButtonTapped(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    // This's a Delegate method, called when the navigation is complete
    // when the webpage is finished and check to see if it can to back and forward in history
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack // back button is enable if canGoBack is true too
        forwardButton.isEnabled = webView.canGoForward //forware button is enable if canGoForware is true too
        // tell each one of the buttons that ok once you're done loading
        
        urlTextField.text = webView.url?.absoluteString
        // that'll give us everything from HTTP forward slash and then the rest of the URL plus directories and other files that it's loading
    }
    
}

