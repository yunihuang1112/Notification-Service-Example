# NotiService-ex

This is a example for **Rich Push Notification** in iOS 10*.
Only **Notification Service Extension**.  

## Build 

To build NotificationService to your test device, you need to change your **scheme** to your service, and build it to your device.

## Debug

To debug NotificationService, you need to do following steps:

 1. Build NotificationService to your device.
 2. Set break points in NotificationService.
 3. Go to Debug >> Attach to Process by PID or Name... >> enter NotificationService name and choose the version >> Attach
 4. Then Xcode will show that it is in "Waiting to attach to NotificationService on your phone" this state. 
 5. Send notification and wait.

## Archive

If you want to archive to enterprise, it needs its own provision profile.

 - Create a new app id for your NotificationService:
	> If the app id of your project is "com.XXX.myProj", then the app id of your NotificationService needs to be like "com.XXX.myProj.NSXXX".
	
- After creating app id, go to create the provision profile for your NotificationService, and remember, **the certification of your project and NotificationService are the same**, just the provision profile is different.

- Go back to Xcode, set the bundle ids and provision profiles in both project and NotificationService, the go to Product >> Archive.
- After finishing archiving, it will select the provision profiles again for project and NotificationService, choose it and you can export and get the ipa file.

## Send notification

There are two ways to send notification:

- Server send the push to APNS then get the notification in your phone. (Remote notification)
- Use local notification by UserNotifications.

Here we provide two ways for sending push in our example.
You can see the detail of local notification in MainVC.swift.
And the detail of remote notification in push.js.

### Use Node js to send notification

Before start using node js, you need to go [Apple developer](https://developer.apple.com/) to set your certification and provision profile, and make sure your app can receive the notification.

To use node js to be the server to send notifications, here are some settings to be done:

 - Create an APNs key.
	 - Go to  [Apple developer](https://developer.apple.com/) >> Certificates, Identifiers & Profiles >> Key >> create a new key.
	 > One APNs key is used for all of yours apps.
	 > APNs key will not expired automatically, it will be always active until you delete it.
 - Dowload the APNs key, and you will get a .p8 file. 
	 > One APNs key can only be downloaded **once**.
 - Download [Node js](https://nodejs.org/en/download/) to your mac. If success, you can use node command in cmd.
 - Create a folder and install **apn** kit. We can see the details [here](https://github.com/node-apn/node-apn).
	>     mkdir apns 
	>     cd apns
	>     npm install apn --save
 - Put the .p8 file in this folder.
 - Create a your own js or use the push.js in this example.
 - In push.js, you need to set some settings:
	 - APNs key name 
		 - Enter your .p8 file name
	 - Key Id
		 - You can find it in your APNs key in [Apple developer](https://developer.apple.com/) .
	- Team Id
		- You can find it in [Apple developer](https://developer.apple.com/)  >> Membership.
	- Topic
		- The topic of the notification you sent is your bundle id.
	 - Device token
		 - Change it to the  token of your test device.
- Finally, go to cmd and set command, the you can get the push in your device.
	>     node push.js
	>     (node "your js name")
- If you want to send push by push.js in Enterprise, you need to change the "production" to true in push.js.

## Others

In your push payload, remember the key **mutable-content**, set it to **1**, then it will go through your NotificationService before the notification showing on your device.
