//
//  Utility.swift
//  Embraced
//
//  Created by Domonique Dixon on 1/9/19.
//  Copyright © 2019 Domonique Dixon. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func fileExist(_ filename: String) -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(filename).path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
//            print("FILE \(filename) AVAILABLE")
            return true
        } else {
//            print("FILE \(filename) NOT AVAILABLE")
        }
        
        return false
    }
    
    static func deleteFile(_ fileNameToDelete:String) {
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    static func drawSquare(color: CGColor, canvasSize: Double, shapeSize: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasSize, height: canvasSize))
        
        let img = renderer.image { ctx in
            let rect = CGRect(x: ((canvasSize - shapeSize) / 2), y: ((canvasSize - shapeSize) / 2), width: shapeSize, height: shapeSize)
            
            ctx.cgContext.setStrokeColor(UIColor.clear.cgColor)
            ctx.cgContext.setFillColor(color)
            
            ctx.cgContext.addRect(rect)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        return img
    }
    
    static func drawCircle(color: CGColor, canvasSize: Double, shapeSize: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasSize, height: canvasSize))
        
        let img = renderer.image { ctx in
            let rect = CGRect(x: ((canvasSize - shapeSize) / 2), y: ((canvasSize - shapeSize) / 2), width: shapeSize, height: shapeSize)
            
            ctx.cgContext.setStrokeColor(UIColor.clear.cgColor)
            ctx.cgContext.setFillColor(color)
            
            ctx.cgContext.addEllipse(in: rect)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        return img
    }
    
    static func drawTriangle(color: CGColor, canvasSize: Double, shapeSize: Double) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: canvasSize, height: canvasSize))
        
        let img = renderer.image { ctx in
            let top = (canvasSize / 2)
            ctx.cgContext.beginPath()
            ctx.cgContext.move(to: CGPoint(x: top, y: top - (shapeSize / 3)))
            ctx.cgContext.addLine(to: CGPoint(x: top + shapeSize / 2.5, y: top + shapeSize / 3))
            ctx.cgContext.addLine(to: CGPoint(x: top - shapeSize / 2.5, y: top + shapeSize / 3))
            ctx.cgContext.closePath()
            ctx.cgContext.setFillColor(color)
            ctx.cgContext.fillPath()
        }
        
        return img
    }
    
    static func getImage(path: String) -> UIImage {
        let imagePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

        if imagePath != "" {
            let imageURL = URL(fileURLWithPath: imagePath).appendingPathComponent("media/\(path)")
            
            if let image = UIImage(contentsOfFile: imageURL.path) {
                return image
            }
        }
        
        return UIImage() 
    }
    
    static func getAudio(path: String) -> URL {
        let audioPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

        if audioPath != "" {
            let audioURL = URL(fileURLWithPath: audioPath).appendingPathComponent("media/\(path)")
            
            return audioURL
        }
        
        return URL(fileURLWithPath: "")
    }
    
    static func getDownloadList(files: [TestFiles]) -> [TestFiles] {
        var rv = [TestFiles]()
        
        for file in files {
            for name in file.data {
                var path = ""
                
                if file.lang == "" {
                    path = "media/\(file.name)/\(name)"
                } else {
                    path = "media/\(file.name)/\(file.lang)/\(name)"
                }
                
                if !Utility.fileExist(path) {
                    rv.append(file)
                    break
                }
            }
        }
        
        return rv
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}

public extension UIColor {
    static let appleRed = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
    static let appleOrange = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
    static let appleYellow = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
    static let appleGreen = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    static let picGreen = UIColor(red: 141/255, green: 194/255, blue: 71/255, alpha: 1)
    static let appleTealBlue = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
    static let appleBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    static let applePurple = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    static let applePink = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
}
