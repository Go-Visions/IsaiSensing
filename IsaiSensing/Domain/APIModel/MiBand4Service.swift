//
//  MiBand4Service.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/24.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import Foundation
import CoreBluetooth

struct MiBand4Service{
    
    //
    
    public static let UUID_SERVICE_MIBAND2_SERVICE: CBUUID = CBUUID(string: "FEE0")
    public static let UUID_SERVICE_HEART_RATE: CBUUID = CBUUID(string: "180D")
    public static let UUID_SERVICE_ALERT: CBUUID = CBUUID(string: "1802")
    
    
    public static let UUID_CHARACTERISTIC_FIRMWARE: CBUUID = CBUUID(string: "00001531-0000-3512-2118-0009af100700")
    public static let UUID_CHARACTERISTIC_FIRMWARE_DATA: CBUUID = CBUUID(string: "00001532-0000-3512-2118-0009af100700")
    
    public static let UUID_CHARACTERISTIC_HEART_RATE_CONTROL: CBUUID = CBUUID(string: "2A39")
    public static let UUID_CHARACTERISTIC_HEART_RATE_DATA: CBUUID = CBUUID(string: "2A37")
    
    public static let UUID_CHARACTERISTIC_VIBRATION_CONTROL: CBUUID = CBUUID(string: "2A06")
    
    /**
     * Alarms, Display and other configuration.
     */
    public static let UUID_CHARACTERISTIC_3_CONFIGURATION: CBUUID = CBUUID(string: "00000003-0000-3512-2118-0009af100700");
    public static let UUID_CHARACTERISTIC_5_ACTIVITY_DATA: CBUUID = CBUUID(string: "00000005-0000-3512-2118-0009af100700");
    public static let UUID_CHARACTERISTIC_6_BATTERY_INFO: CBUUID = CBUUID(string: "00000006-0000-3512-2118-0009af100700");
    public static let UUID_CHARACTERISTIC_7_REALTIME_STEPS: CBUUID = CBUUID(string: "00000007-0000-3512-2118-0009af100700");
    
    // service uuid fee1
    public static let UUID_CHARACTERISTIC_AUTH: CBUUID = CBUUID(string: "00000009-0000-3512-2118-0009af100700");
    public static let UUID_CHARACTERISTIC_10_BUTTON: CBUUID = CBUUID(string: "00000010-0000-3512-2118-0009af100700");
    
    // for vibration characvteristic
    public static let ALERT_LEVEL_CUSTOM:[Int8] = [-1, 2, 2, 1, 1, 3]; //[Custom Flag, Duration, Duration, Break, Break, Repetitions]
    public static let ALERT_LEVEL_NONE:[Int8] = [0];
    public static let ALERT_LEVEL_MESSAGE:[Int8] = [1];
    public static let ALERT_LEVEL_PHONE_CALL:[Int8] = [2];
    public static let ALERT_LEVEL_VIBRATE_ONLY:[Int8] = [3];
    
    public static let COMMAND_START_HEART_RATE_MEASUREMENT:[UInt8] = [21, 2, 1];
    
    
    
}

enum MiCharacteristicID: String {
    case dateTime = "2A2B"
    case alert = "2A06"
    case heartRateMeasurement = "2A37"
    case heartRateControlPoint = "2A39"
    case battery = "00000006-0000-3512-2118-0009AF100700"
    case activity = "00000007-0000-3512-2118-0009AF100700"
    case deviceEvent = "00000010-0000-3512-2118-0009AF100700"
}

struct Toggle {
    static let off: UInt8 = 0x0
    static let on: UInt8 = 0x1

    private init() {}
}

struct HeartRateReadingMode {
    static let sleep: UInt8 = 0x0
    static let continuous: UInt8 = 0x1
    static let manual: UInt8 = 0x2

    private init() {}
}

struct MiCommand {
    static let startHeartRateMonitoring: [UInt8] = [0x15, HeartRateReadingMode.continuous, Toggle.on]
    static let stopHeartRateMonitoring: [UInt8] = [0x15, HeartRateReadingMode.continuous, Toggle.off]
    static let startHeartRateMeasurement: [UInt8] = [0x15, HeartRateReadingMode.manual, Toggle.on]
    static let stopHeartRateMeasurement: [UInt8] = [0x15, HeartRateReadingMode.manual, Toggle.off]
}
