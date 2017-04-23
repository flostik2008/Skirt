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
    private var _date: Double!
    
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
    
    var date: Double {
        return _date
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
        
        if let date = postData["date"] as? Double {
            self._date = date
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        print("Zhenya: adjustLikes in Post is called")

        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.child("likes").setValue(_likes)
    }


}








