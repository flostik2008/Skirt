//
//  Post.swift
//  Skirt
//
//  Created by Evgeny Vlasov on 3/6/17.
//  Copyright © 2017 Evgeny Vlasov. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    private var _userKey: String!
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    var userKey: String {
        return _userKey
    }
    
    init(imageUrl: String, likes: Int) {
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
        self._postKey = postKey
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        if let userKey = postData["userKey"] as? String {
            self._userKey = userKey
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes + 1
        }
        
        _postRef.child("likes").setValue(_likes)
    }


}








