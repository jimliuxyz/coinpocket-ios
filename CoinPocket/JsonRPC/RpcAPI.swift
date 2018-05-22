//
//  RpcAPI.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/21.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import Foundation
import SocketIO

typealias RpcHandler = (JsonRPC)->()

class RpcAPI {
    
    private static let JSONRPC = "jsonrpc"
    
    var manager:SocketManager!
    var socket:SocketIOClient?
    var eventWatcher: RpcHandler?

    //    func test(_ onDone: @escaping ((_ ok:Bool)->Void)?){
    //    }
    
    init(_ username:String, _ onDone: ((_ ok:Bool)->Void)?){
        var _onDone = onDone
        let url = "http://" + Config.udef.string(forKey: ._SERVER)! + ":" + Config.udef.string(forKey: ._PORT)!
        
        print("conn...\(url)")
        
        manager = SocketManager(socketURL: URL(string: url)!, config: [.log(false), .compress])
        socket = manager!.defaultSocket
        
        socket!.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
            let json = JsonRPC.createMethod("login", ["name":username,"pwd":"_"])
            self.sendRpc(json){data in
                let ok = data.result?["ok"] as? Bool ?? false
                _onDone?(ok)
                _onDone = nil
                if ok{
                    self.sendWatch()
                }
            }
        }
        socket!.on(clientEvent: .error) { (data, ack) in
            print("socket error")
            _onDone?(false)
            _onDone = nil
            self.disconnect()
        }
        socket!.on(clientEvent: .disconnect) { (data, ack) in
            print("socket disconnected")
        }
        socket!.onAny { event in
            //            print("socket event : \(event)")
        }
        
        socket!.on(RpcAPI.JSONRPC){data, ack in
            let j = JsonRPC.fromJsonString(data[0] as! String)
            self.receiveRpc(j)
        }
        socket!.connect()
    }
    
    func disconnect(){
        guard let _ = socket else {
            return
        }
        print("disconnect")
        socket?.disconnect()
        manager.disconnect()
        socket = nil
    }
    
    private var map : [String:RpcHandler] = [:]
    private func pushHandler(_ id: String, _ handler: @escaping RpcHandler){
        map[id] = handler
    }
    private func popupHandler(_ id: String) -> RpcHandler?{
        let handler = map[id]
        map[id] = nil
        return handler
    }
    
    private func sendRpc(_ json: JsonRPC, _ handler: RpcHandler?=nil){
        print("\nsendRpc", json.toJsonString())
        if let handler = handler{
            pushHandler(json.id, handler)
        }
        guard let _ = socket else {
            return
        }
        socket?.emit(RpcAPI.JSONRPC, with: [json.toJsonString()])
    }
    
    private func receiveRpc(_ json: JsonRPC){
        
        let handler = popupHandler(json.id)
        if let handler = handler{
            print("\ngot result", json.toJsonString())

            handler(json)
        }
        else if json.isMethod(), json.method! == "takeReceipt"{
            print("got receipt", json)
            eventWatcher?(json)
        }
        else{
            print("got unknown", json)
        }
    }
    
    private func sendWatch(){
        let json = JsonRPC.createMethod("watchEvent")
        self.sendRpc(json)
    }
    
    func watchEvent(handler: @escaping RpcHandler){
        eventWatcher = handler
    }
    
    func getBalance(handler: @escaping RpcHandler){
        let json = JsonRPC.createMethod("balance")
        self.sendRpc(json, handler)
    }
    
    func listReceipt(handler: @escaping RpcHandler){
        let json = JsonRPC.createMethod("listReceipt")
        self.sendRpc(json, handler)
    }
    
    private func curType2Int(_ curType: String) -> Int{
        return (curType=="TWD") ? 0 : 1
    }
    
    func deposit(_ curType: String, _ amount:Int, handler: @escaping RpcHandler){
        let type = curType2Int(curType)
        
        let json = JsonRPC.createMethod("deposit", ["type":type, "amount":amount])
        self.sendRpc(json, handler)
    }
    
    func withdraw(_ curType: String, _ amount:Int, handler: @escaping RpcHandler){
        let type = curType2Int(curType)

        let json = JsonRPC.createMethod("withdraw", ["type":type, "amount":amount])
        self.sendRpc(json, handler)
    }
    
    func transfer(_ curType: String, _ amount:Int, _ receiver:String, handler: @escaping RpcHandler){
        let type = curType2Int(curType)
        
        let json = JsonRPC.createMethod("transfer", ["type":type, "amount":amount, "receiver":receiver])
        self.sendRpc(json, handler)
    }
    
}
