//
//  ViewController.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/16.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MWMDelegate {
    
    let mwm = MWMDevice.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mwm?.delegate = self
    }
    
    func deviceFound(_ devName: String!, mfgID: String!, deviceID: String!) {
        print("devName = "+devName)
        print("mfgID = "+mfgID)
        print("deviceID = "+deviceID)
        //choose the correct device and connect
        mwm?.connect(deviceID)
    }
    
    func didConnect() {
        print("didconnect")
    }
    
    func didDisconnect() {
        print("didDisconnect");
    }
    @IBAction func ScanButton(_ sender: Any) {
        print("scanBtnClick")
        mwm?.scanDevice()
    }
    
    @IBAction func disConnectButton(_ sender: Any) {
        print("disConnectBtnClick")
        mwm?.disconnectDevice()
    }
    
    func eegPowerDelta(_ delta: Int32, theta: Int32, lowAlpha: Int32, highAlpha: Int32) {
        print("delta = " ,delta)
        print("theta = " ,theta)
        print("lowAlpha = " ,lowAlpha)
        print("highAlpha = " ,highAlpha)
    }


}

