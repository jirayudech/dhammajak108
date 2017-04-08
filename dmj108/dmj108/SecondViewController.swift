//
//  SecondViewController.swift
//  dmj108
//
//  Created by Mac mini on 4/5/2560 BE.
//  Copyright © 2560 RGT Soft. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {


        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.delegate = self
        loadDmj108Blog()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDmj108Blog(){
        let url = URL(string: "http://dmj108.blogspot.com/")

        webView.loadRequest(URLRequest(url:url!))
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        
        activity.isHidden = false
        activity.startAnimating()
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        
        activity.isHidden = true
        activity.stopAnimating()
    }

}

