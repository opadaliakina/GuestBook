//
//  DataManager.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 30.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DataManager {
    
    enum Paths {
        static let scheme = "http"
        static let host = "pusher.cpl.by"
        static let baseURL = "http://pusher.cpl.by"
        static let versionPath = "/api/v1"
    }
    
    static let shared = DataManager()
    
    //Hardcode for now
    var currentUser: User?
    
    var defaultPath: String { return Paths.baseURL + Paths.versionPath }
    
    func defaultHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            ]
        return headers
    }
    
    func url(with additionalPath: String?) -> URL? {
        guard let token = currentUser?.token else {
            return nil
        }
        let urlString = self.defaultPath + (additionalPath ?? "") + "?api_token=" + token
        return URL(string: urlString)
    }
    
    func login(withEmail email: String, password: String, block: @escaping ((User?) -> Void)) {
        var params = [String : Any]()
        params["email"] = email
        params["password"] = password
        
        guard let url = URL(string: self.defaultPath + "/auth/login") else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: self.defaultHeaders()).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                let resultDict = response.result.value as! [String: Any]
                let result = Mapper<User>().mapArray(JSONObject: [resultDict])
                block(result?.first)
            } else {
                block(nil)
            }
        }
    }
    
    func signUp(withEmail email: String, name: String, password: String, block: @escaping ((User?) -> Void)) {
        var params = [String : Any]()
        params["email"] = email
        params["password"] = password
        params["name"] = name
        params["avatar"] = " "
        
        guard let url = URL(string: self.defaultPath + "/auth/register") else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: self.defaultHeaders()).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                let resultDict = response.result.value as! [String: Any]
                let result = Mapper<User>().mapArray(JSONObject: [resultDict])
                block(result?.first)
            } else {
                block(nil)
            }
        }
    }
    
    func createComment(_ comment: Comment, block: @escaping ((Bool) -> Void)) {
        guard let url = self.url(with: "/comment") else {
            block(false)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: comment.toJSON(), encoding: URLEncoding.httpBody, headers: self.defaultHeaders()).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                block(true)
            } else {
                block(false)
            }
        }
    }
    
    func getComments(with block: @escaping (([Comment]) -> Void)) {
        guard let url = self.url(with: "/comment") else {
            block([])
            return
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: self.defaultHeaders()).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                let resultDict = response.result.value as! [String: Any]
                let result = Mapper<Comment>().mapArray(JSONObject: resultDict["data"])
                block(result ?? [])
            } else {
                block([])
            }
        }
    }
    
    func createAnswer(_ answer: Answer, for comment: Comment, block: @escaping ((Bool) -> Void)) {
        guard let commentId = comment.id else {
            block(false)
            return
        }
        guard let url = self.url(with: "/comment/\(commentId)/answer") else {
            return
        }
        
        Alamofire.request(url, method: .post, parameters: answer.toJSON(), encoding: URLEncoding.httpBody, headers: self.defaultHeaders()).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                block(true)
            } else {
                block(false)
            }
        }
    }
    
    func getAnswers(for comment: Comment, block: @escaping (([Answer]) -> Void)) {
        guard let commentId = comment.id else {
            block([])
            return
        }
        guard let url = self.url(with: "/comment/\(commentId)/answer") else {
            return
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: self.defaultHeaders()).responseJSON { (response) in
            if response.response?.statusCode == 200 && response.result.value != nil {
                let result = Mapper<Answer>().mapArray(JSONObject: response.result.value)
                block(result ?? [])
            } else {
                block([])
            }
        }
    }
}
