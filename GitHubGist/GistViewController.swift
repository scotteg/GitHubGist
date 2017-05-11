//
//  GistViewController.swift
//  GitHubGist
//
//  Created by Scott Gardner on 5/11/17.
//  Copyright © 2017 Scott Gardner. All rights reserved.
//

import UIKit

final class GistViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var gist: Gist?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        guard let gist = gist,
            let url = URL(string: gist.htmlUrlString)
            else { return }
        
        webView.delegate = self
        let request = URLRequest(url: url)
        activityIndicator.startAnimating()
        webView.loadRequest(request)
    }
}

extension GistViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_: UIWebView, didFailLoadWithError: Error) {
        activityIndicator.stopAnimating()
        
        let alert = UIAlertController(title: "😱", message: "There was a problem loading this page. Please tap back to Gists and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true)
    }
}
