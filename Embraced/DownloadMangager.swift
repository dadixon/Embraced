//
//  DownloadMangager.swift
//  Embraced
//
//  Created by Domonique Dixon on 11/22/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

/// Manager of asynchronous NSOperation objects

class DownloadManager: NSObject, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    /// Dictionary of operations, keyed by the `taskIdentifier` of the `NSURLSessionTask`
    
    private var operations = [Int: DownloadOperation]()
    
    /// Serial NSOperationQueue for downloads
    
    let queue: OperationQueue = {
        let _queue = OperationQueue()
        _queue.name = "download"
        _queue.maxConcurrentOperationCount = 1
        
        return _queue
    }()
    
    /// Delegate-based NSURLSession for DownloadManager
    
    lazy var session: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }()
    
    
    /// Add download
    ///
    /// - parameter URL:  The URL of the file to be downloaded
    ///
    /// - returns:        The DownloadOperation of the operation that was queued
    
    func addDownload(URL: NSURL) -> DownloadOperation {
        let operation = DownloadOperation(session: session, URL: URL)
        operations[operation.task.taskIdentifier] = operation
        queue.addOperation(operation)
        return operation
    }
    
    /// Cancel all queued operations
    
    func cancelAll() {
        queue.cancelAllOperations()
    }
    
    // MARK: NSURLSessionDownloadDelegate methods
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        operations[downloadTask.taskIdentifier]?.URLSession(session: session, downloadTask: downloadTask, didFinishDownloadingToURL: location as NSURL)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        operations[downloadTask.taskIdentifier]?.URLSession(session: session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
    
    // MARK: NSURLSessionTaskDelegate methods
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let key = task.taskIdentifier
        operations[key]?.URLSession(session: session, task: task, didCompleteWithError: error as NSError?)
        operations.removeValue(forKey: key)
    }
    
}

/// Asynchronous NSOperation subclass for downloading

class DownloadOperation : AsynchronousOperation {
    let task: URLSessionTask
    
    init(session: URLSession, URL: NSURL) {
        task = session.downloadTask(with: URL as URL)
        super.init()
    }
    
    override func cancel() {
        task.cancel()
        super.cancel()
    }
    
    override func main() {
        task.resume()
    }
    
    // MARK: NSURLSessionDownloadDelegate methods
    
    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do {
            let manager = FileManager.default
            let documents = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationURL = documents.appendingPathComponent(downloadTask.originalRequest!.url!.lastPathComponent)
            if manager.fileExists(atPath: destinationURL.path) {
                try manager.removeItem(at: destinationURL)
            }
            try manager.moveItem(at: location as URL, to: destinationURL)
        } catch {
            print(error)
        }
    }
    
    func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("\(downloadTask.originalRequest!.url!.absoluteString) \(progress)")
    }
    
    
    // MARK: NSURLSessionTaskDelegate methods
    
    func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
        completeOperation()
        if error != nil {
            print(error!)
        }
    }
    
}
