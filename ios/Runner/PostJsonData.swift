//
//  PostJsonData.swift
//  Runner
//
//  Created by rohan morris on 6/10/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

public class PostJsonData
{
    var inId:String = ""
    
    public func execute(broadcastId:String, saveResourceUrl:String, authToken:String)
    {
        let uploadDataModel = UploadData(service: ["bambuser_broadcast_id" : broadcastId])

        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }

        var request = URLRequest(url: URL(string: saveResourceUrl)!)
        request.httpBody = jsonData
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
    
    public func executeEndBroadCast(endBroadcastUrl:String, authToken:String)
    {
        var request = URLRequest(url: URL(string: endBroadcastUrl)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
    }
    
    struct UploadData: Codable {
        let service: [String: String]
    }
}
