//
//  MainVC.swift
//  NotiService-ex
//
//  Created by YUNI on 2018/12/20.
//  Copyright © 2018年 YUNI. All rights reserved.
//

import UIKit
import UserNotifications

class MainVC: UIViewController {

    @IBOutlet weak var sendBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        initBtn()
    }
    
    fileprivate func initBtn() {
        sendBtn.layer.cornerRadius = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    @IBAction func sendBtnPressed(_ sender: Any) {
        sendPush()
    }
    
    //MARK: Push
    fileprivate func sendPush() {
        let content = UNMutableNotificationContent.init()
        /*
         * Set the title for the push.
         */
        content.title = "NSC Title"
        /*
         * Set the subtitle for the push.
         */
        content.subtitle = "NSC subtitle"
        /*
         * Set the body for the push.
         * Must be set in your push, or you never see the push.
         */
        content.body = "This is a exampe from NotiService-ex."
        /*
         * title, subtitle and body can be localized by using other keys. See the details in
         * https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/generating_a_remote_notification.
         */
        
        /*
         * Set the bagde for the push.
         * If not 0, it will show the badge number on your app icon.
         */
        content.badge = 0
        
        /*
         * Set sound for push
         * you can set sound by this:
         * let sound = UNNotificationSound.init(named: "xxx.xxx")
         */
        content.sound = UNNotificationSound.default()
        
        /*
         * Set when to push, and set it repeat or not.
         *
         * UNTimeIntervalNotificationTrigger: send push after few seconds.
         * UNCalendarNotificationTrigger: send push in specified time. See the ex below.
         * UNLocationNotificationTrigger: send push if user approaching a location.
         * UNPushNotificationTrigger: send push by server.
         */
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        /*
         * Set the request and identifier for push.
         * If you want to cancel sending the push, we can use these function:
         *  open func removePendingNotificationRequests(withIdentifiers identifiers: [String])
         *  open func removeAllPendingNotificationRequests()
         *  open func removeDeliveredNotifications(withIdentifiers identifiers: [String])
         *  open func removeAllDeliveredNotifications()
         */
        let request = UNNotificationRequest(identifier:"notiservice-ex", content: content, trigger: trigger)
        
        /*
         * Send push by notification center
         */
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    /*
     * Add attachment to push
     */
    fileprivate func addAttachment(content: UNMutableNotificationContent) {
        let imageURL = Bundle.main.url(forResource: "xxx", withExtension: "jpg")
        if let attachment = try? UNNotificationAttachment(identifier: "", url: imageURL!, options: nil) {
            content.attachments = [attachment]
        } else {
            print("Attachment not found.")
        }
    }
    
    /*
     * UNCalendarNotificationTrigger ex
     */
    fileprivate func sendPushByDate(content: UNMutableNotificationContent) {
        content.body = "Send push by specify the date"
        let date = Date.init()
        let components = Calendar.current.dateComponents([ .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier:"notiservice-ex-sendbydate", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
