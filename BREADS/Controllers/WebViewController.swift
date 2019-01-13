//
//  WebViewController.swift
//  BREADS
//
//  Created by Dharani Reddy on 17/12/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    // MARK:- Variables
    internal var webUrl: String?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "DON BOSCO, BREADS"
        loadWebView()
        navigationBackWithNoText()
        navigationController?.isNavigationBarHidden = false
    }
    
    private func loadWebView() {
        let urlRequest = NSURLRequest(url: NSURL(string: webUrl ?? "http://www.breadsbangalore.org/")! as URL)
        webView.loadRequest(urlRequest as URLRequest)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
