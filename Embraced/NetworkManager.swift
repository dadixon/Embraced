//
//  NetworkManager.swift
//  Embraced
//
//  Created by Domonique Dixon on 4/4/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation
import SVProgressHUD

class NetworkManager: NSObject {
//    var reachability: Reachability!
//    static let sharedInstance: NetworkManager = {
//        return NetworkManager()
//    }()
//    override init() {
//        super.init()
//        // Initialise reachability
//        reachability = Reachability()!
//        // Register an observer for the network status
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(networkStatusChanged(_:)),
//            name: .reachabilityChanged,
//            object: reachability
//        )
//        do {
//            // Start the network status notifier
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//    }
//
//    @objc func networkStatusChanged(_ notification: Notification) {
//        let reachability = notification.object as! Reachability
//
//        switch reachability.connection {
//        case .none:
////            SVProgressHUD.showInfo(withStatus: "No internet connection")
//            print("No internet connection")
//        default:
////            SVProgressHUD.showInfo(withStatus: "Internet Available")
//            print("Internet Available")
//            StorageManager.sharedInstance.pushStoredFiles()
//        }
//    }
//
//    static func stopNotifier() -> Void {
//        do {
//            // Stop the network status notifier
//            try (NetworkManager.sharedInstance.reachability).startNotifier()
//        } catch {
//            print("Error stopping notifier")
//        }
//    }
//
//    // Network is reachable
//    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
//        if (NetworkManager.sharedInstance.reachability).connection != .none {
//            completed(NetworkManager.sharedInstance)
//        }
//    }
//
//    // Network is unreachable
//    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
//        if (NetworkManager.sharedInstance.reachability).connection == .none {
//            completed(NetworkManager.sharedInstance)
//        }
//    }
}
