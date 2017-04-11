//
//  SecondViewController.swift
//  dmj108
//
//  Created by Jirayudech on 4/5/2560 BE.
//  UI/UX Designed by Nopphakhun
//  Developed by RGT Soft.

import UIKit

class SecondViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {


        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.delegate = self //Use to create did start load and did finish load event.
        
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
    
    //Loading animation
    func webViewDidStartLoad(_ webView: UIWebView){
        activity.isHidden = false
        activity.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        activity.isHidden = true
        activity.stopAnimating()
    }

}

