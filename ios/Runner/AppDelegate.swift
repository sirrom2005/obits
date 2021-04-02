import UIKit
import Flutter

import Foundation
import WebKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate
{
    static var args:[String: String]?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        GeneratedPluginRegistrant.register(with: self)
        
        let channelName = "START_CAMERA_APP"
        let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: rootViewController as! FlutterBinaryMessenger)
        
        methodChannel.setMethodCallHandler
        {
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if (call.method == "startCameraActivity")
            {
                AppDelegate.args = call.arguments as? [String: String]
              
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "video_storyboard")
                rootViewController.present(vc, animated: true)
                result("RESULT_BROADCAST_ENDED")
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
