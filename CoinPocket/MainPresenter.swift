//
//  MainPresenter.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/22.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import Foundation
import UIKit

class MainPresenter{
    
    let api: RpcAPI
    let view: MainViewController
    init(rpcapi: RpcAPI, view: MainViewController){
        self.api = rpcapi
        self.view = view
        
        self.api.watchEvent(){ (json) in
            var rec = TxReceipt()
            rec.update(item: json.params!["receipt"] as! [String : String])
            self.view.appendReceip(rec)
            self.getBalance()
        }
    }
    
    private func dismissAlertLater(_ alert: UIAlertController, _ errmsg: String?=nil){
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: { (_) in
            alert.dismiss(animated: (errmsg==nil) ? true:false){
                if let errmsg = errmsg{
                    ToastView.shared.long(self.view.view, txt_msg: errmsg)
                }
            }
        })
    }
    
    func getBalance(){
        api.getBalance { (json) in
            if json.isResult(){
                DispatchQueue.main.async{
                    self.view.showBalance(json.result!["balance"] as? [String], nil)
                }
            }
        }
    }
    
    func listReceipt(){
        api.listReceipt { (json) in
            if json.isResult(){
                let list = json.result!["list"]! as! Array<[String: String]>
                let recs = TxReceipt.fromList(list)
                
                DispatchQueue.main.async{
                    self.view.showReceips(recs)
                }
            }
        }
    }
    
    func deposit(_ curType: String, _ amount: Int){
        let alert = view.showLoadingAlert()
        
        api.deposit(curType, amount) { (json) in
            var errmsg:String?
            if json.isResult(){
                var rec = TxReceipt()
                rec.updateTxHash(json.result!["txhash"]! as! String)
                self.view.appendReceip(rec)
            }
            else{
                errmsg = json.getErrMsg()
            }
            self.dismissAlertLater(alert, errmsg)
        }
    }
    
    func withdraw(_ curType: String, _ amount: Int){
        let alert = view.showLoadingAlert()
        
        api.withdraw(curType, amount) { (json) in
            var errmsg:String?
            if json.isResult(){
                var rec = TxReceipt()
                rec.updateTxHash(json.result!["txhash"]! as! String)
                self.view.appendReceip(rec)
            }
            else{
                errmsg = json.getErrMsg()
            }
            self.dismissAlertLater(alert, errmsg)
        }
    }

    func transfer(_ curType: String, _ amount: Int, _ receiver: String){
        let alert = view.showLoadingAlert()
        
        api.transfer(curType, amount, receiver) { (json) in
            var errmsg:String?
            if json.isResult(){
                var rec = TxReceipt()
                rec.updateTxHash(json.result!["txhash"]! as! String)
                self.view.appendReceip(rec)
            }
            else{
                errmsg = json.getErrMsg()
            }
            print("tx done,", errmsg)
            self.dismissAlertLater(alert, errmsg)
        }
    }
}
