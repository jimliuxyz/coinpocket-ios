//
//  ViewController.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/22.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import UIKit

extension UIViewController{
    func showLoadingAlert() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
        //alert.dismiss(animated: false, completion: nil)
    }
}
