//
//  TxReceipt.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/21.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import Foundation

struct TxReceipt {
    var txhash = ""
    var sender = ""
    var dtypes = ""
    var action = ""
    var amount = ""
    var receiver = ""
    
    mutating func update(item: [String:String]){
        txhash = item["txhash"]!
        sender = item["sender"]!
        dtypes = item["dtypes"]!
        action = item["action"]!
        amount = item["amount"]!
        receiver = item["receiver"]!
    }
    
    mutating func updateTxHash(_ txhash: String){
        self.txhash = txhash
    }

    func toString() -> String{
        switch action {
        case "deposit":
            return "存入 " + amount + " " + dtypes
        case "withdraw":
            return "提出 " + amount + " " + dtypes
        case "transfer":
            return sender + " 轉帳 " + amount + " " + dtypes + " to " + receiver
        default:
            return txhash
        }
    }
    
    static func fromList(_ list: Array<[String: Any]>) -> [TxReceipt]{
        var recs = [TxReceipt]()
        
        for item in list{
            var rec = TxReceipt()
            rec.update(item: item as! [String:String])
            
            //since rec is a struct not a reference type, you have to add(copy) it to list after modification
            recs.append(rec)
        }

        return recs
    }

}
