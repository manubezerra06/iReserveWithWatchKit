//
//  AppDelegate.swift
//  iReserve
//
//  Created by Felipe Silva  on 5/7/15.
//  Copyright (c) 2015 Felipe Silva . All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var homeViewController: MapViewController?


    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [NSObject: AnyObject]?) -> Bool {
            
        //iBeacon

        let uuidString = "D0D3FA86-CA76-45EC-9BD9-6AF4505D009C"
        let beaconIdentifier = "iBeacon"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
                identifier: beaconIdentifier)
            
            
        locationManager = CLLocationManager()
            
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
            
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
            
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()

        
        //Notifications
            
        let userNotificationTypes = (UIUserNotificationType.Alert |  UIUserNotificationType.Badge |  UIUserNotificationType.Sound);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        Parse.setApplicationId("BbxWpqFcgVJqtjEyyVx20Z1VfFMgitBnDXNXQbog",
            clientKey: "PEZEGopK395wgOa2k8lg9guBCajWxtZs55PApv1m")
            
           
        
            
        return true
    }
    
    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        
        if let userInfo = userInfo, request = userInfo["request"] as? String{
            if request == "getReservas"{
                
                var query1 = PFQuery(className: "Product")
                query1.whereKey("reservedBy", equalTo: PFUser.currentUser()!.username!)
                var qtdReservas = query1.countObjects()
                
                reply(["replay": "Você tem: " + qtdReservas.description + " reservas"])
            
            }
            else if request == "getMeusProdutos"{
                
                var query2 = PFQuery(className: "Product")
                query2.whereKey("reservedBy", equalTo: PFUser.currentUser()!.username!)
                
                var products = query2.findObjects() as! Array<PFObject>
                println(products)
                var productsNames = [String]()
                
                
                for p in products{
                    productsNames.append(p["name"] as! String)
                }
                reply(["products": productsNames])
                
                
            }
            else{
            
             reply(["message": "invalid request"])
            }
            
        }
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Store the deviceToken in the current Installation and save it to Parse
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
       // UIApplication.sharedApplication().can
    }
    
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            //let mapViewController:MapViewController = window!.rootViewController as! MapViewController
            //mapViewController.beacons = beacons as! [CLBeacon]?
            //viewController.tableView!.reloadData()
            
            NSLog("didRangeBeacons");
            var message:String = ""
            
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] as! CLBeacon
                
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                
                //case CLProximity.Far:
                //message = "You are far away from the beacon"
                
                switch nearestBeacon.proximity {
                case CLProximity.Near:
                    message = "Você está perto da loja! Que tal comprar um dos produtos?"
                case CLProximity.Immediate:
                    message = "Você está do lado de uma loja! Passe e compre uma lembrança!"
                case CLProximity.Unknown:
                    return
                case CLProximity.Far:
                    return
                }
            } else {
                
                if(lastProximity == CLProximity.Unknown) {
                    return;
                }
                
                //message = "No beacons are nearby"
                lastProximity = CLProximity.Unknown
            }
            
            NSLog("%@", message)
            sendLocalNotificationWithMessage(message)
    }
    
    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("You entered the region")
            //sendLocalNotificationWithMessage("You entered the region")
    }
    
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
            //sendLocalNotificationWithMessage("You exited the region")
    }
    
    
    //HANDOFF
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]!) -> Void) -> Bool {
        
        if let win = window {
            let configViewController = win.rootViewController as! ConfigViewController
            
            configViewController.restoreUserActivityState(userActivity)
        }
        
        return true
    }
    
}

