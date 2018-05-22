//
//  ServerPopupViewController.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/21.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import UIKit

class ServerPopupViewController: UIViewController {

    @IBOutlet weak var inpServer: UITextField!
    @IBOutlet weak var inpPort: UITextField!
    
    var onDone: ((_ type: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inpServer.text = Config.udef.string(forKey: ._SERVER)
        inpPort.text = Config.udef.string(forKey: ._PORT)

    }
    
    //handle click outside the dialog
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch: UITouch? = touches.first
        
        if (view == touch?.view){
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func insteadOfServer(_ sender: UIButton) {
        if sender.currentTitle == "AWS"{
            inpServer.text = Config.udef.string(forKey: ._SERVER_AWS)
        }
        if sender.currentTitle == "Local"{
            inpServer.text = Config.udef.string(forKey: ._SERVER_LOC)
        }
    }
    
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickConfirm(_ sender: Any) {
        Config.udef.set(inpServer.text, forKey: ._SERVER)
        Config.udef.set(inpPort.text, forKey: ._PORT)
        dismiss(animated: true, completion: nil)
    }
}
