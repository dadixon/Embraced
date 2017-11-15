//
//  AsynchronousOperation.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/22/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

/// Asynchronous NSOperation subclass for downloading

//class DownloadOperation : AsynchronousOperation {
//    var task: URLSessionTask!
//    
//    init(session: URLSession, URL: Foundation.URL) {
//        super.init()
//        
//        task = session.downloadTask(with: URL as URL) { temporaryURL, response, error in
//            defer {
//                self.completeOperation()
//            }
//            
//            print(URL.lastPathComponent)
//            
//            guard error == nil && temporaryURL != nil else {
//                print(error!)
//                return
//            }
//            
//            do {
//                let manager = FileManager.default
//                let documents = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                let destinationURL = documents.appendingPathComponent(URL.lastPathComponent)
//                if manager.fileExists(atPath: destinationURL.path) {
//                    try manager.removeItem(at: destinationURL)
//                }
//                try manager.moveItem(at: temporaryURL!, to: destinationURL)
//                print(destinationURL)
//            } catch let moveError {
//                print(moveError)
//            }
//        }
//    }
//    
//    override func cancel() {
//        task.cancel()
//        super.cancel()
//    }
//    
//    override func main() {
//        task.resume()
//    }
//    
//}


//
//  AsynchronousOperation.swift
//
//  Created by Robert Ryan on 9/20/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//

import Foundation

/// Asynchronous Operation base class
///
/// This class performs all of the necessary KVN of `isFinished` and
/// `isExecuting` for a concurrent `NSOperation` subclass. So, to developer
/// a concurrent NSOperation subclass, you instead subclass this class which:
///
/// - must override `main()` with the tasks that initiate the asynchronous task;
///
/// - must call `completeOperation()` function when the asynchronous task is done;
///
/// - optionally, periodically check `self.cancelled` status, performing any clean-up
///   necessary and then ensuring that `completeOperation()` is called; or
///   override `cancel` method, calling `super.cancel()` and then cleaning-up
///   and ensuring `completeOperation()` is called.

open class AsynchronousOperation : Operation {
    
    override open var isAsynchronous: Bool { return true }
    
    fileprivate let stateLock = NSLock()
    
    fileprivate var _executing: Bool = false
    override fileprivate(set) open var isExecuting: Bool {
        get {
            return stateLock.withCriticalScope { _executing }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            stateLock.withCriticalScope { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    fileprivate var _finished: Bool = false
    override fileprivate(set) open var isFinished: Bool {
        get {
            return stateLock.withCriticalScope { _finished }
        }
        set {
            willChangeValue(forKey: "isFinished")
            stateLock.withCriticalScope { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    /// Complete the operation
    ///
    /// This will result in the appropriate KVN of isFinished and isExecuting
    
    open func completeOperation() {
        if isExecuting {
            isExecuting = false
        }
        
        if !isFinished {
            isFinished = true
        }
    }
    
    override open func start() {
        if isCancelled {
            isFinished = true
            return
        }
        
        isExecuting = true
        
        main()
    }
    
    override open func main() {
        fatalError("subclasses must override `main`")
    }
}

/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 An extension to `NSLock` to simplify executing critical code.
 
 From Advanced NSOperations sample code in WWDC 2015 https://developer.apple.com/videos/play/wwdc2015/226/
 From https://developer.apple.com/sample-code/wwdc/2015/downloads/Advanced-NSOperations.zip
 */

import Foundation

extension NSLock {
    
    /// Perform closure within lock.
    ///
    /// An extension to `NSLock` to simplify executing critical code.
    ///
    /// - parameter block: The closure to be performed.
    
    func withCriticalScope<T>(_ block: () -> T) -> T {
        lock()
        let value = block()
        unlock()
        return value
    }
}
