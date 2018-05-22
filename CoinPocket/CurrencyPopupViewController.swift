//
//  CurrencyPopupViewController.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/20.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import UIKit

class CurrencyPopupViewController: UIViewController {
    
    var onDone: ((_ type: String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //handle click outside the dialog
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first

        if (view == touch?.view){
            dismiss(animated: true, completion: nil)
        }
    }

    //handle click on currency type
    @IBAction func clickOnType(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        onDone?(sender.currentTitle!)
    }
}
