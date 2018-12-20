//
//  NotificationService.swift
//  NotificationService
//
//  Created by YUNI on 2018/12/20.
//  Copyright © 2018年 YUNI. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            func fail() {
                contentHandler(request.content)
            }
            
            guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
                return fail()
            }
            
            /*
             * actions
             */
            let category: String = content.categoryIdentifier
            handleCategories(category: category)
            
            /*
             * preview image
             */
            if let mediaUrl = content.userInfo["media-url"] as? String {
                guard let mediaData = NSData(contentsOf:NSURL(string: mediaUrl)! as URL) else {
                    return fail()
                }
                guard let attachment = UNNotificationAttachment.create(data: mediaData, options: nil) else {
                    return fail()
                }
                content.attachments = [attachment]
            }
            
            contentHandler(content.copy() as! UNNotificationContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    fileprivate func handleCategories(category: String) {
        let liveViewAction = UNNotificationAction(identifier: "meow", title: "Meow", options: [UNNotificationActionOptions.foreground])
        let contactAction = UNNotificationAction(identifier: "wang", title: "Wang", options: [])
        let categories = UNNotificationCategory(identifier: category, actions: [liveViewAction, contactAction], intentIdentifiers: [], options: [])

        UNUserNotificationCenter.current().setNotificationCategories([categories])
    }
}

extension UNNotificationAttachment {
    static func create(data: NSData, options: [NSObject : AnyObject]?) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let fileIdentifier = folderName + ".png"
        let fileUrlPath = NSURL(fileURLWithPath: NSTemporaryDirectory())
        let folderUrl = fileUrlPath.appendingPathComponent(folderName, isDirectory: true)
        do {
            try fileManager.createDirectory(at: folderUrl!, withIntermediateDirectories: true, attributes: nil)
            let fileUrl = folderUrl?.appendingPathComponent(fileIdentifier)
            try data.write(to: fileUrl!, options: [])
            let imageAttachment = try UNNotificationAttachment.init(identifier: fileIdentifier, url: fileUrl!, options: options)
            return imageAttachment
        } catch let error {
            print("notification service file error: \(error)")
        }
        
        return nil
    }
}
