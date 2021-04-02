//
//  RecorderPlayerViewController.swift
//  Runner
//
//  Created by rohan morris on 5/30/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class RecorderPlayerViewController: UIViewController, BambuserViewDelegate
{
    let PROFILE_IMG_URL:String = AppDelegate.args!["profilePicUrl"]!
    let PROFILE_IMAGE_SIZE:CGFloat = 64
    var mSaveResourceUrl:String
    var mEndBroadcastUrl:String
    var mAuthToken:String
    var mBroadcastId:String = ""
    
    let bambuserView : BambuserView
    let fullName, eventType, textInfo: MyTextLabel
    let profileImage: UIImageView
    
    required init?(coder aDecoder: NSCoder)
    {
        bambuserView    = BambuserView(preparePreset: kSessionPresetAuto)
        textInfo        = MyTextLabel()
        fullName        = MyTextLabel()
        eventType       = MyTextLabel()
        profileImage    = UIImageView()
        mSaveResourceUrl = AppDelegate.args!["SaveResourceUrl"]!
        mEndBroadcastUrl = AppDelegate.args!["EndBroadcastUrl"]!
        mAuthToken       = AppDelegate.args!["authToken"]!
  
        super.init(coder: aDecoder)

        bambuserView.delegate       = self
        bambuserView.applicationId  = AppDelegate.args!["bambUserAppIosId"]!
        bambuserView.author         = AppDelegate.args!["userName"]!;
        bambuserView.broadcastTitle = "\(AppDelegate.args!["fullName"]!) \(AppDelegate.args!["eventType"]!)";
        bambuserView.customData     = "Date: \(AppDelegate.args!["date"]!) Time: \(AppDelegate.args!["time"]!)"
        bambuserView.saveOnServer   = true;
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let imgMargin:CGFloat = 10.0
        var padding:CGFloat = 0.0
        bambuserView.orientation = UIApplication.shared.statusBarOrientation
        
        self.view.addSubview(bambuserView.view)

        bambuserView.startCapture()
    
        fullName.text = AppDelegate.args!["fullName"]!
        fullName.textAlignment = NSTextAlignment.left
        
        eventType.text = AppDelegate.args!["eventType"]!
        eventType.font = UIFont.boldSystemFont(ofSize:13)
        eventType.textColor = UIColor(red: 0.08, green: 0.58, blue: 0.26, alpha: 1.00)
        eventType.textAlignment = NSTextAlignment.left
        
        if #available(iOS 11.0, *) {
            padding = 3
        }
    
        profileImage.frame      = CGRect(x:imgMargin + padding, y:imgMargin, width:PROFILE_IMAGE_SIZE, height:PROFILE_IMAGE_SIZE)
        fullName.frame          = CGRect(x:75 + imgMargin + padding, y: 8 + imgMargin, width:130, height:20)
        eventType.frame         = CGRect(x:75 + imgMargin + padding, y:30 + imgMargin, width:130, height:20)
        textInfo.frame          = CGRect(x: (getScreenHeight/2)-120, y: 0, width:210, height:60)
        
        let url = NSURL(string: PROFILE_IMG_URL)! as URL
        if let imageData: NSData = NSData(contentsOf: url) {
            profileImage.image = UIImage(data: imageData as Data)
        }else{
            profileImage.image = UIImage(named: "default_profile")
        }
        profileImage.layer.cornerRadius = PROFILE_IMAGE_SIZE/2;
        profileImage.layer.masksToBounds = true;
        
        self.view.addSubview(profileImage)
        self.view.addSubview(fullName)
        self.view.addSubview(eventType)
        self.view.addSubview(textInfo)
        
        if(self.bambuserView.hasFrontCamera){
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 2
            self.view.addGestureRecognizer(tap)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopBroadcasting), name: Notification.Name("stopBroadcastingFunction"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startCameraBroadcasting), name: Notification.Name("startCameraBroadcastingFunction"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPause), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewWillLayoutSubviews()
    {
        bambuserView.setOrientation(UIInterfaceOrientation.landscapeRight, previewOrientation: UIInterfaceOrientation.landscapeRight)
        bambuserView.previewFrame = CGRect(x:0.0, y:0.0, width:getScreenWidth, height:getScreenHeight)
    }
    
    override public var shouldAutorotate: Bool {
      return true
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      return .landscapeRight
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
      return .landscapeRight
    }
    
    @objc func onPause() {
        endBroadcastPost()
    }
    
    @objc func doubleTapped() {
        bambuserView.swapCamera()
    }
    
    @objc func closeWindow() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func broadcast() {
        textInfo.text = "Connecting..."
        bambuserView.startBroadcasting()
    }
    
    @objc func stopBroadcasting(notification: NSNotification) {
        textInfo.text = "Broadcast stoped."
        bambuserView.stopBroadcasting()
        endBroadcastPost()
    }
    
    @objc func startCameraBroadcasting(notification: NSNotification) {
       broadcast()
    }
    
    func broadcastStarted() {
        textInfo.text = "Your are now streaming live."
    }
    
    func broadcastDisconnected() {
        textInfo.text = "Broadcast disconnected."
    }
    
    func broadcastResumed() {
        textInfo.text = "Broadcast resumed."
    }
    
    func broadcastStopped() {
        textInfo.text = "Stream ended..."
    }
    
    func broadcastIdReceived(_ broadcastId: String!) {
        mBroadcastId = broadcastId
        PostJsonData().execute(
            broadcastId: mBroadcastId,
            saveResourceUrl: mSaveResourceUrl,
            authToken: mAuthToken)
    }

    func bambuserError(_ errorCode: BambuserError, message errorMessage: String!) {}
    
    public var getScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    public var getScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func endBroadcastPost(){
        if(!mBroadcastId.isEmpty){
            let url = mEndBroadcastUrl + mBroadcastId + "/archive"
            PostJsonData().executeEndBroadCast(endBroadcastUrl: url, authToken: mAuthToken)
        }
    }
}
