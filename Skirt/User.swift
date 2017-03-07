//
//  User.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/6/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import Foundation


class User {
    
    
    private var _userKey: String!
    private var _avatarUrl: String!
    private var _userName: String!
    private var _gender: String!
    
    var userKey: String {
        return _userKey
    }
    
    var avatarUrl: String {
        return _avatarUrl
    }
    
    var userName: String {
        return _userName
    }
    
    var gender: String {
        return _gender
    }
    
    init(userKey: String, avatarUrl: String, userName: String) {
        self._userKey = userKey
        self._avatarUrl = avatarUrl
        self._userName = userName
    }
    
    init(userKey: String, userData: Dictionary<String, AnyObject>) {
        self._userKey = userKey
        
        if let avatarUrl = userData["avatarUrl"] as? String {
            self._avatarUrl = avatarUrl
        }
        
        if let userName = userData["username"] as? String {
            self._userName = userName
        }
    }
}









