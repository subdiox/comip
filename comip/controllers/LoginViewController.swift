//
//  LoginViewController.swift
//  comicatalog
//
//  Created by subdiox on 2019/01/12.
//  Copyright © 2019 Yuta Ooka. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SVProgressHUD
import Alertift

class LoginViewController: UIViewController {
    
    var webView: WKWebView?
    var currentStatus = 0
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for development purpose
        emailField.text = "subdiox@gmail.com"
        passwordField.text = "passw0rd"
        
        let script: WKUserScript = WKUserScript(source: """
            var meta = document.createElement('meta');
            meta.name = 'viewport';
            meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            var head = document.getElementsByTagName('head')[0];
            head.appendChild(meta);
        """, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        userContentController.addUserScript(script)
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(webView!)
//        webView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        webView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        webView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        webView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if emailField.text!.isEmpty || passwordField.text!.isEmpty {
            Alertift.alert(title: "エラー", message: "メールアドレス、パスワードの両方を入力してください")
                .action(.default("OK"))
                .show(on: self)
        } else {
            SVProgressHUD.show(withStatus: "ログイン画面読み込み中")
            currentStatus = 1
            webView?.load(URLRequest(url: URL(string: "https://auth2.circle.ms")!))
        }
    }
}

extension LoginViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let urlString = webView.url?.absoluteString {
            if urlString.starts(with: "https://auth2.circle.ms") {
                if currentStatus == 1 {
                    SVProgressHUD.setStatus("ログイン情報入力中")
                    webView.evaluateJavaScript("""
                        document.getElementById(\"Username\").value = \"\(emailField.text!)\";
                        document.getElementById(\"Password\").value = \"\(passwordField.text!)\";
                        document.getElementById(\"loginbtn\").click();
                        """)
                    currentStatus = 2
                    SVProgressHUD.setStatus("ログイン処理中")
                } else if currentStatus == 2 {
                    SVProgressHUD.dismiss()
                    Alertift.alert(title: "エラー", message: "メールアドレスもしくはパスワードが間違っているか、アカウントがロックされています。5回連続でパスワードを間違えた場合は30分間アカウントがロックされるので、時間が経ってからもう一度お試しください。")
                        .action(.default("OK"))
                        .show(on: self)
                }
            } else if urlString.starts(with: "https://portal.circle.ms") {
                let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
                cookieStore.getAllCookies() { (cookies) in
                    let cookieString = cookies.map {"\($0.name)=\($0.value); "}.joined()
                    let ud = UserDefaults.standard
                    ud.set(cookieString, forKey: "cookie")
                    SVProgressHUD.dismiss()
                    let homeViewController = self.storyboard!.instantiateViewController(withIdentifier: "Home")
                    self.present(homeViewController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension LoginViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}
