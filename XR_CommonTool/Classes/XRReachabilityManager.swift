//
//  XRReachabilityManager.swift
//
//  Created by 段新瑞 on 2018/10/29.
//  Copyright © 2018 厚大-律师学院. All rights reserved.
//  ======  时时网络监听

import UIKit
import Reachability

@objc public class XRReachabilityManager: NSObject {
    
    @objc public static let shared = XRReachabilityManager()

    @objc var UrlHost = "http://www.xivolxxn.top"
    
    /// 开启网络监听
    @objc public static func startReachability() {
        let sess = URLSession.shared;
        let urls: NSURL = NSURL.init(string: shared.UrlHost)!
        var request: URLRequest = NSURLRequest.init(url: urls as URL) as URLRequest
        request.timeoutInterval = 5
        let task = sess.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    XXLog("response: \(httpResponse.statusCode)")
                    
                } else {
                    XXLog("response: \(httpResponse.statusCode)")
                }
            }
        }
        
        task.resume()
    }
    
    @objc public static func ishaveNet() -> Bool {
        
        do {
            let reachability = try Reachability(hostname: "www.apple.com")
            if reachability.connection == .unavailable {
                return false
            } else {
                return true
            }
        } catch {
            return false
        }
    }
    
    
    public var reachability = try? Reachability(hostname: "www.apple.com")
    public typealias resultBlock = (_ isReachable: Bool) -> Void
    @objc public  static func networkChange(result: @escaping resultBlock) -> Void {
        XRReachabilityManager.shared.reachability?.whenReachable = { reachability in
            result(true)
        }
        XRReachabilityManager.shared.reachability?.whenUnreachable = { reachability in
            result(false)
        }
        
        do {
            try XRReachabilityManager.shared.reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    @objc public  static func stopNotifier() {
        XRReachabilityManager.shared.reachability?.stopNotifier()
    }
    
}
