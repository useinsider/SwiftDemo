//
//  MainViewController.swift
//  Example
//
//  Created by Özgür Vatansever on 12.05.2026.
//

import InsiderMobile
import InsiderWebView
import UIKit
import WebKit

public final class MainViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        Insider.setupWebViewSDK(on: webView)

        // Locally (via NSBundle)
        if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
            let url = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }

        // Remotely (via URL)
//        if let url = URL(string: "http://localhost:8080/index.html") {
//            webView.load(URLRequest(url: url))
//        }
    }
}
