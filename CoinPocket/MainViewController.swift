//
//  MainViewController.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/20.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import UIKit
import SocketIO

class MainViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var btnCurrency: UIButton!
    @IBOutlet weak var labBalance: UILabel!
    @IBOutlet weak var tblReps: UITableView!
    @IBOutlet weak var inpTxAmount: UITextField!
    @IBOutlet weak var inpTxReceiver: UITextField!
    
    var rpc:RpcAPI!
    private var preserter: MainPresenter!
    
    private var curType = "TWD"
    private var balance: [String]?
    private var recs: [TxReceipt]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Config.udef.string(forKey: ._USERNAME)
        
        let backButton = UIBarButtonItem(title: "登出", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tblReps.backgroundColor = UIColor(red: 226/255, green: 224/255, blue: 224/255, alpha: 1)
        tblReps.separatorColor = UIColor(red: 191/255, green: 189/255, blue: 189/255, alpha: 1)

        
        //stop empty row separators
        tblReps.tableFooterView = UIView()
        
        //init presenter
        preserter = MainPresenter(rpcapi: rpc, view: self)
        preserter.getBalance()
        preserter.listReceipt()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        if parent == nil{
            // print("Back button was clicked")
            rpc.disconnect()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is CurrencyPopupViewController{
            let popup = segue.destination as! CurrencyPopupViewController
            popup.onDone = {type in
                self.btnCurrency.setTitle(type, for: .normal)
                print(type)
                self.curType = type
                self.showBalance(nil, type)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "receipt_cell")
        cell.textLabel?.text = recs![indexPath.row].toString()
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func showBalance(_ balance: [String]?, _ curType: String?){
        self.balance = balance ?? self.balance
        self.curType = curType ?? self.curType
        
        if let text = self.balance?[0], self.curType=="TWD"{
            self.labBalance.text = text
        }
        if let text = self.balance?[1], self.curType=="USD"{
            self.labBalance.text = text
        }
    }
    
    func showReceips(_ recs: [TxReceipt]){
        for rec in recs{
            print(rec.toString())
        }
        self.recs = recs
        tblReps.reloadData()
    }
    
    func appendReceip(_ newrec: TxReceipt){
        guard recs != nil else{
            return
        }
        //update existing receipt
        for (idx, rec) in recs!.enumerated(){
            if rec.txhash == newrec.txhash{
                recs![idx] = newrec
                tblReps.reloadData()
                return
            }
        }
        
        //or insert as new receipt
        recs!.insert(newrec, at: 0)
        tblReps.reloadData()
    }
    
    @IBAction func clickDeposit(_ sender: UIButton) {
        if let amount = Int((inpTxAmount?.text)!){
            preserter.deposit(curType, amount)
        }
    }
    
    @IBAction func clickWithdraw(_ sender: UIButton) {
        if let amount = Int((inpTxAmount?.text)!){
            preserter.withdraw(curType, amount)
        }
    }
    
    @IBAction func clickTransfer(_ sender: UIButton) {
        if let amount = Int((inpTxAmount?.text)!), let receiver = inpTxReceiver.text, !receiver.isEmpty{
            preserter.transfer(curType, amount, receiver)
        }
    }
}
