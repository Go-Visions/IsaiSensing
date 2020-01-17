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
    /// 脳波データ取得時のメソッド(delta, theta Alpha(low, high))
    /// - Parameters:
    ///   - delta: delta value
    ///   - theta: theta value
    ///   - lowAlpha: lowAlpha value
    ///   - highAlpha: highAlpah value
    func eegPowerDelta(_ delta: Int32, theta: Int32, lowAlpha: Int32, highAlpha: Int32) {
        print("delta = " ,delta)
        print("theta = " ,theta)
        print("lowAlpha = " ,lowAlpha)
        print("highAlpha = " ,highAlpha)
    }
    
    /// 脳波データ取得時のメソッド(Beta(low, high), Gamma(low, high)
    /// - Parameters:
    ///   - lowBeta: lowBeta value
    ///   - highBeta: highBeta value
    ///   - lowGamma: lowGamma value
    ///   - midGamma:  midGamma value
    func eegPowerLowBeta(_ lowBeta: Int32, highBeta: Int32, lowGamma: Int32, midGamma: Int32) {
        print("lowBeta = " ,lowBeta)
        print("highBeta = " ,highBeta)
        print("lowGamma = " ,lowGamma)
        print("lowGamma = " ,midGamma)
    }
    
    /// 脳波データ取得時のメソッド(poorSignal, attention meditation)
    /// - Parameters:
    ///   - poorSignal: 繋がっていれば0 ずれたりすると数値が上がる
    ///   - attention: 集中度(NeuroSky独自ロジック)
    ///   - meditation: 瞑想度(NeuroSky独自ロジック)
    func eSense(_ poorSignal: Int32, attention: Int32, meditation: Int32) {
        print("poorSignal = " ,poorSignal)
        print("attention = " ,attention)
        print("meditation = " ,meditation)
    }

}

