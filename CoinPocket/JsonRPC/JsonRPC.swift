//
//  JsonRPC.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/21.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import Foundation

struct JsonRPC: Codable{
    static let ERRCODE = "code"
    static let ERRMSG = "message"

    //fields
    var jsonrpc = "2.0"
    var id = ""
    
    var method:String?
    var params:[String:Any]?
    
    var result:[String:Any]?
    var error:[String:Any]?

    //for encode/decode [String:Any]
    enum CustomerKeys: String, CodingKey
    {
        case jsonrpc, id, method, params, result, error
    }
    init(){
    }
    init (from decoder: Decoder) throws {
        let container =  try decoder.container (keyedBy: CustomerKeys.self)
        jsonrpc = try container.decode (String.self, forKey: .jsonrpc)
        id = try container.decode (String.self, forKey: .id)
        method = try? container.decode (String.self, forKey: .method)
        params = try? container.decode ([String: Any].self, forKey: .params)
        result = try? container.decode ([String: Any].self, forKey: .result)
        error = try? container.decode ([String: Any].self, forKey: .error)
    }
    func encode (to encoder: Encoder) throws
    {
        var container = encoder.container (keyedBy: CustomerKeys.self)
        try container.encode (jsonrpc, forKey: .jsonrpc)
        try container.encode (id, forKey: .id)
        try container.encode (method, forKey: .method)
        try container.encode (params, forKey: .params)
        try container.encode (result, forKey: .result)
        try container.encode (error, forKey: .error)
    }

    static func createMethod(_ method: String, _ params:[String:Any]=[:]) -> JsonRPC{

        var json = JsonRPC()
        json.id = String(Int(arc4random_uniform(UInt32.max)))
        json.method = method
        json.params = params
        return json
    }
    
    static func createErr(_ code: Int, _ message: String) -> JsonRPC{

        var json = JsonRPC()
        json.id = "local generated"
        json.error = ["code": code, "message": message]
        return json
    }
    
    static func fromJsonString(_ str: String) -> JsonRPC{
        
        let data = str.data(using: .utf8)!
        let json = try! JSONDecoder().decode(JsonRPC.self, from: data)
//        print("????", json.result!["ok"]!)

        return json
    }
    
    func toJsonString() -> String{
        let data = try! JSONEncoder().encode(self)
        return data.toJsonString()!
    }
    
    func isMethod() -> Bool {
        return method != nil
    }
    
    func isResult() -> Bool {
        return result != nil
    }
    
    func isError() -> Bool {
        return error != nil
    }
    
    func getErrCode() -> Int{
        return error?[JsonRPC.ERRCODE] as? Int ?? -1
    }
    
    func getErrMsg() -> String{
        return error?[JsonRPC.ERRMSG] as? String ?? ""
    }
    
}





