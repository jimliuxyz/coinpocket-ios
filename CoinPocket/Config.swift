//
//  Config.swift
//  CoinPocket
//
//  Created by JimLiu on 2018/5/21.
//  Copyright © 2018年 JimLiu. All rights reserved.
//

import Foundation

extension String{
    static let _SERVER = "server"
    static let _PORT = "port"
    static let _USERNAME = "username"
    static let _SERVER_AWS = "server_aws"
    static let _SERVER_LOC = "server_loc"
}

class Config{
    
    private static let userDefaultsDefaults:[String : Any] = [
        String._SERVER : "ec2-18-221-14-16.us-east-2.compute.amazonaws.com",
        String._PORT : 8081,
        String._SERVER_AWS : "ec2-18-221-14-16.us-east-2.compute.amazonaws.com",
        String._SERVER_LOC : "192.168.1.101",
        String._USERNAME : "guest"
    ]
    
    static let udef:UserDefaults = {
        print("load user default...")
        UserDefaults.standard.register(defaults: userDefaultsDefaults)
        
        return UserDefaults.standard
    }()

}
