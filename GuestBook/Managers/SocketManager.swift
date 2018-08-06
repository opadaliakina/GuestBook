
//
//  SocketManager.swift
//  GuestBook
//
//  Created by Olga Padaliakina on 31.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import Foundation
import SocketIO
import ObjectMapper

extension Notification {
    enum Keys {
        static let publicCommentAdded = "comment_added"
    }
}

class WebSocketManager {
    
    enum SocketPaths {
        static let webSocketURL = "http://pusher.cpl.by:6020"
        static let publicChannel = "public-push"
        static let listenPublic = "App\\Events\\PublicPush"
        static let listenPrivate = "App\\Events\\UserPush"
    }
    
    static let shared = WebSocketManager()
    
    var socketManager: SocketManager? = nil
    var socket: SocketIOClient? = nil
    
    let user = DataManager.shared.currentUser ?? User()
    
    var privateChannel: String { return "user.\(user.id ?? 2)"}
    
    func connect() {
        self.socketManager = SocketManager(socketURL: URL(string: SocketPaths.webSocketURL)!, config: [.log(true)])
        self.socket = self.socketManager?.defaultSocket
      //  .extraHeaders(["Authorization" : "saidydsyuaXY5i89dy6jd62e"]
        self.socket?.connect()
        
        self.socket?.on(SocketPaths.listenPublic, callback: { (data, emitter) in
            print("Public event handler")
            let result = data[1] as? [String : Any]
            let comments = Mapper<Comment>().mapArray(JSONObject: [result!["comment"]])
            NotificationCenter.default.post(name: Notification.Name.init(Notification.Keys.publicCommentAdded), object: nil, userInfo: ["comment" : comments!.first!])
        })
        
        self.socket?.on(SocketPaths.listenPrivate, callback: { (data, emitter) in
            print("Private event handler")
            let result = data[1] as? [String : Any]
            let data = result!["data"] as? [String : Any]
            let answers = Mapper<Answer>().mapArray(JSONObject: [data!["answer"]])
            let commentId = (data!["answer"] as! [String : Any])["comment_id"]
            NotificationCenter.default.post(name: Notification.Name.init("answer_added_\(commentId!)"), object: nil, userInfo: ["answer" : answers!.first!])
        })
    
        socket?.on("connect") {data, ack in
            print("socket connected.")
            
            let data = [["channel": SocketPaths.publicChannel]]
            self.socket?.emit("subscribe", with : data)
            
            let privateData = [["channel": "private-" + self.privateChannel, "auth" : ["headers" : ["Authorization" : self.user.token!]]]]
            self.socket?.emit("subscribe", with: privateData)
        }
    }
    
    func disconnect() {
        self.socketManager?.disconnect()
        self.socketManager = nil
        self.socket = nil
    }
}
