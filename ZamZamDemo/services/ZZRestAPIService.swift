//
//  ZZRestService.swift
//  ZamZamDemo
//
//  Created by Daniil Pendikov on 10/11/2018.
//  Copyright © 2018 Daniil Pendikov. All rights reserved.
//

import Foundation

/// Result from REST API
///
/// - response: response data
/// - error: error object
enum ZZAPIResult {
    case response(Data)
    case error(ZZError)
}

/// Base class for handling url requests
class ZZRestAPIService {
    
    typealias Completion = (ZZAPIResult) -> Void
    
    func request(url: URL, completion: @escaping Completion) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            self.handle(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    func handle(data: Data?,
                        response: URLResponse?,
                        error: Error?,
                        completion: @escaping Completion) {
        if error != nil {
            let nserror = error! as NSError
            if nserror.code != NSURLErrorCancelled {
                let desc = nserror.localizedDescription
                completion(ZZAPIResult.error(ZZError(text: desc)))
            }
        } else {
            if let httpResp = response as? HTTPURLResponse {
                switch httpResp.statusCode {
                case 200 ... 299:
                    if let data = data {
                        completion(ZZAPIResult.response(data))
                    } else {
                        completion(ZZAPIResult.error(ZZError(text: "No data")))
                    }
                default:
                    let desc = HTTPURLResponse.localizedString(forStatusCode: httpResp.statusCode) + "\ntransaction\n\(httpResp.url?.absoluteString ?? "")"
                    let error = ZZError(text: desc, code: httpResp.statusCode)
                    completion(ZZAPIResult.error(error))
                }
            } else {
                let desc = "Response is not a HTTPURLResponse"
                completion(ZZAPIResult.error(ZZError(text: desc)))
            }
        }
    }
    
}
