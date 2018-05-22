//
//  LoginViewController.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/20.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var inpUser: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inpUser.text = Config.udef.string(forKey: ._USERNAME)!
        btnLogin.setTitleColor(UIColor.gray, for: .disabled)
    }
    
    var availedRpc:RpcAPI?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is MainViewController{
            let main = segue.destination as! MainViewController
            main.rpc = availedRpc!
        }
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        login()
    }
    
    private func login(){
        btnLogin.isEnabled = false
        let alert = showLoadingAlert()

        let user = inpUser.text!
        Config.udef.set(user, forKey: ._USERNAME)

        var rpc: RpcAPI!
        rpc = RpcAPI(user){ok in
            alert.dismiss(animated: false){
                if (ok){
                    self.availedRpc = rpc
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                }
                else{
                    rpc.disconnect()
                    ToastView.shared.short(self.view, txt_msg: "登入失敗!")
                }
                self.btnLogin.isEnabled = true
            }
        }
    }
    
}

