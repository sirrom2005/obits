//
//  CameraViewController.swift
//  Runner
//
//  Created by rohan morris on 5/26/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//
import UIKit
import CoreMotion


class CameraViewController: UIViewController
{
    @IBOutlet weak var recorderContainer: UIView!
    @IBOutlet weak var endBroadCastBtn: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var rotateView: UIView!
    @IBOutlet weak var startCameraView: UIView!
    @IBOutlet weak var startCameraButton: UIButton!
    
    var motionManager: CMMotionManager!
    var windowOpen:Bool = false
    let PROFILE_IMAGE_SIZE:CGFloat = 64
    let broadcastButton : MyButton
    let bottomInfo: MyTextLabel
    
    required init?(coder aDecoder: NSCoder)
    {
        broadcastButton = MyButton()
        bottomInfo      = MyTextLabel()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        recorderContainer.layer.masksToBounds = true
        recorderContainer.layer.shadowColor = UIColor.black.cgColor
        recorderContainer.layer.shadowOpacity = 1
        recorderContainer.layer.shadowOffset = .zero
        recorderContainer.layer.shadowRadius = 10
        
        motionManager = CMMotionManager()
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        closeButton.addTarget(self, action: #selector(CameraViewController.moveWindowAction), for: UIControl.Event.touchUpInside)
        endBroadCastBtn.addTarget(self, action: #selector(CameraViewController.endBroadcast), for: UIControl.Event.touchUpInside)
        startCameraButton.addTarget(self, action: #selector(CameraViewController.startCamera), for: UIControl.Event.touchUpInside)
        
        let imgMargin:CGFloat = 10.0
        var padding:CGFloat = 0.0
        if #available(iOS 11.0, *) {
            padding = 3
        }
        
        broadcastButton.frame   = CGRect(x: getScreenHeight-PROFILE_IMAGE_SIZE-imgMargin-padding, y: getScreenWidth-PROFILE_IMAGE_SIZE-imgMargin, width:PROFILE_IMAGE_SIZE, height:PROFILE_IMAGE_SIZE)
        broadcastButton.setBackgroundImage(UIImage(named: "stop_icon"), for: .normal)
        broadcastButton.addTarget(self, action: #selector(CameraViewController.stopButtonMoveAction), for: UIControl.Event.touchUpInside)
        
        bottomInfo.text = "Swipe Down to Stop\nDouble Tap to Flip Camera"
        bottomInfo.frame = CGRect(x: (getScreenHeight/2)-120, y: getScreenWidth-PROFILE_IMAGE_SIZE-imgMargin, width:240, height:PROFILE_IMAGE_SIZE)
        
        rotateView.isHidden = false
        self.view.addSubview(broadcastButton)
        self.view.addSubview(bottomInfo)
    }
    
    override func viewWillLayoutSubviews()
    {
        closeButtonLocation(padding: 0)
        endBroadCastBtn.frame = CGRect(x:100, y:20, width:getScreenWidth-200, height:50)
        recorderContainer.frame = CGRect(x:0, y:0, width:getScreenWidth, height:getScreenHeight)
        rotateView.center = self.view.center
        startCameraView.center = self.view.center
        rotateEvent()
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .up {
            windowOpen = true
            moveWindowAction()
        }
        else if gesture.direction == .down {
            windowOpen = false
            moveWindowAction()
        }
    }
    
    @objc func endBroadcast() {
        if motionManager != nil {
            motionManager.stopDeviceMotionUpdates()
        }
        NotificationCenter.default.post(name: Notification.Name("stopBroadcastingFunction"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func startCamera() {
        startCameraView.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("startCameraBroadcastingFunction"), object: nil)
    }
    
    @objc func moveWindowAction() {
        windowOpen = !windowOpen
        UIView.animate(withDuration: 0.25) {
            self._moveWindowAction()
        }
    }
    
    @objc func stopButtonMoveAction() {
        UIView.animate(withDuration: 0.25) {
            self.windowOpen = false
            self.moveWindowAction()
        }
    }
    
    func _moveWindowAction()
    {
        recorderContainer.layer.cornerRadius = self.windowOpen ? 40 : 0
        recorderContainer.frame =
        windowOpen ? CGRect(x:0, y:90, width:getScreenWidth, height:getScreenHeight)
                   : CGRect(x:0, y:0,   width:getScreenWidth, height:getScreenHeight)
        
        closeButtonLocation(padding: self.windowOpen ? 90 : 0)
    }
    
    func closeButtonLocation(padding:CGFloat)
    {
        closeButton.frame = CGRect(x:getScreenWidth-50, y:20+padding, width:32, height:32)
    }
    
    override public var shouldAutorotate: Bool {
      return false
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      return .landscapeRight
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
      return .landscapeRight
    }
    
    public var getScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    public var getScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    func rotateEvent() {
        if(motionManager.isGyroAvailable){
            motionManager.deviceMotionUpdateInterval = 0.1
            
            let queue = OperationQueue()
            motionManager?.startDeviceMotionUpdates(to: queue, withHandler: { [weak self] (motion, error) -> Void in
                if let attitude = motion?.attitude {
                    let x = fmod(2 * Double.pi + atan2(attitude.roll, -attitude.pitch), 2 * Double.pi)
                    DispatchQueue.main.async {
                        if(x < 1 || x > 5){
                            self!.showRotateView(x: 1.566)
                        }else if(x <= 4 && x >= 2){
                            self!.showRotateView(x: 4.7059)
                        }else
                        {
                            self!.rotateView.isHidden = true
//                            UIView.transition(with: self!.rotateView, duration: 0.30, options: .transitionCrossDissolve, animations: {
//                            })
                        }
                    }
                }
            })
        }
    }
    
    func showRotateView(x:CGFloat) {
        rotateView.transform = CGAffineTransform(rotationAngle: CGFloat(x))
        self.rotateView.isHidden = false
    }
}
