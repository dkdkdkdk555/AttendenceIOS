//
//  ViewController.swift
//  AttendenceIOS
//
//  Created by 박욱현 on 2022/04/06.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!
    
    override func loadView() {
            super.loadView()
        
            let contentController = WKUserContentController()
            let config = WKWebViewConfiguration()
        
            contentController.add(self, name: "callbackHandler")
        
            config.userContentController = contentController
        
            webView = WKWebView(frame: self.view.frame, configuration: config)
            webView.uiDelegate = self
            webView.navigationDelegate = self
//            self.view = self.webView
            self.view.addSubview(webView)
            webView.allowsBackForwardNavigationGestures = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "http://172.30.1.40:8888/")
        let request = URLRequest(url: url!)

        webView.load(request)
    }
    
    // JS -> Native CALL
    @available(iOS 8.0, *)
    func userContentController( _ contentController: WKUserContentController, didReceive message: WKScriptMessage){
       if(message.name == "callbackHandler"){
           UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               exit(0)

           }
       }
   }

    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35)); toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6);
            toastLabel.textColor = UIColor.white;
            toastLabel.font = font
            toastLabel.textAlignment = .center;
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds = true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0
                
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
                
            })
    }

}

