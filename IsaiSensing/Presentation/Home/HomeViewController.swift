//
//  HomeViewController.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/16.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class HomeViewController: UIViewController, MWMDelegate, UITableViewDelegate, UITableViewDataSource, CBPeripheralDelegate, CBCentralManagerDelegate, UITextFieldDelegate {
    
    let mwm = MWMDevice.sharedInstance()
    let userId:Int = 1
    
    @IBOutlet weak var mindWaveMobileDeviceListTable: UITableView!
    @IBOutlet weak var miBandDeviceListTable: UITableView!
    @IBOutlet weak var mwmConnectLevel: UIImageView!
    
    @IBOutlet weak var idTextField: UITextField!
    var mwmpoorSignal:[Int32] = []
    
    @IBOutlet weak var modeButton: UIButton!
    /// mindwavemobile2
    struct Device {
        let mfgID: String
        let deviceID: String
    }
    
    /// Mi band4
    struct MiBand {
        let id:String
        
    }
    
    let realm = try! Realm()
    
    enum SaveMode {
        case saving
        case unsave
    }
    
    var saveMode = SaveMode.unsave

    
    var devices: [Device] = []
    var miBandDevices: [MiBand] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mwm?.delegate = self
        setupBluetoothService()
        mindWaveMobileDeviceListTable.delegate = self
        mindWaveMobileDeviceListTable.dataSource = self
        mindWaveMobileDeviceListTable.register(UINib(nibName: "BluetoothDeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "bluetoothDeviceListCell")
        
        miBandDeviceListTable.delegate = self
        miBandDeviceListTable.dataSource = self
        miBandDeviceListTable.register(UINib(nibName: "BluetoothDeviceTableViewCell", bundle: nil), forCellReuseIdentifier: "bluetoothDeviceListCell")
        
        self.idTextField.delegate = self
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.idTextField.text == "" {
            self.showAlertDialog(message: "idを入力してください")
            return false
        }

        textField.resignFirstResponder()
        return true
        
    }
    
    
    func deviceFound(_ devName: String!, mfgID: String!, deviceID: String!) {
        print("devName = "+devName)
        print("mfgID = "+mfgID)
        print("deviceID = "+deviceID)
        let device = Device.init(mfgID: mfgID, deviceID: deviceID)
        let isDevice = devices.firstIndex(where: { $0.mfgID == device.mfgID}) ?? 0
        if isDevice == 0 {
            devices.append(device)
            mindWaveMobileDeviceListTable.reloadData()
        }
    }
    
    func didConnect() {
        /// TODO: 繋がったことをポップアップなどで通知
        
        print("didconnect")
        self.showAlertDialog(message: "脳波デバイスと接続完了しました。")
    }
    
    func didDisconnect() {
        /// TODO: 繋がっている場合にdisconnectを表示させる
        print("didDisconnect");
        self.showAlertDialog(message: "脳波デバイスと接続を切りました")
    }
    @IBAction func ScanButton(_ sender: Any) {
        print("scanBtnClick")
        self.devices.removeAll()
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
        let dateString = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        
        /// realm側で保存
        let realmEegPowerDeltaData = RealmEegPowerDelta()
        realmEegPowerDeltaData.delta = Int(delta)
        realmEegPowerDeltaData.theta = Int(theta)
        realmEegPowerDeltaData.lowAlpha = Int(lowAlpha)
        realmEegPowerDeltaData.highAlpha = Int(highAlpha)
        realmEegPowerDeltaData.userId = 0
        realmEegPowerDeltaData.mwmcreatedAt = dateString
        
        //保存モードか確認
        if saveMode == .unsave{
            print("unsave mode")
            return
        }
        try! realm.write {
            realm.add(realmEegPowerDeltaData)
        }
        
        /*
        /// APIでPOST
        let eegPowerDeltaData = EegPowerDelta(delta: Int(delta),
                                              theta: Int(theta),
                                              lowAlpha: Int(lowAlpha),
                                              highAlpha: Int(highAlpha),
                                              userId: Int(self.idTextField.text ?? 0)!,
                                              mwmcreatedAt: dateString)
        IsaiSensingAPI.PostMWMPowerDeltaData().request(eegPowerDelta: eegPowerDeltaData) { response in
            let json = response.json
            if json["code"].intValue == ApplicationConfig.API.responseSuccess {
                print("post success")
            } else {
                print("post fauilure")
            }
        }
         */
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
        let dateString = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
        /// realm側で保存
        let realmEegPowerLowBatta = RealmEegPowerLowBeta()
        realmEegPowerLowBatta.lowBeta = Int(lowBeta)
        realmEegPowerLowBatta.highBeta = Int(highBeta)
        realmEegPowerLowBatta.lowGamma = Int(lowGamma)
        realmEegPowerLowBatta.midGamma = Int(midGamma)
        realmEegPowerLowBatta.userId = 0
        realmEegPowerLowBatta.mwmcreatedAt = dateString
        
        //保存モードか確認
        if saveMode == .unsave{
           print("unsave mode")
           return
        }

        try! realm.write {
            realm.add(realmEegPowerLowBatta)
        }
        
        /*
        /// APIでPOST
        let eegPowerLowBeta = EegPowerLowBeta(lowBeta: Int(lowBeta), highBeta: Int(highBeta), lowGamma: Int(lowGamma), midGamma: Int(midGamma), userId: Int(self.idTextField.text ?? 0)!, mwmcreatedAt: dateString)
        IsaiSensingAPI.PostMWMPowerBetaData().request(eegPowerLowBeta: eegPowerLowBeta) { response in
            let json = response.json
            if json["code"].intValue == ApplicationConfig.API.responseSuccess {
                print("post success")
            } else {
                print("post fauilure")
            }
        }
        */
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
        checkPoorSignal(poorSignal: poorSignal)
        let dateString = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
//        let eegeSense = EegeSense(poorSignal: Int(poorSignal), attention: Int(attention), meditation: Int(meditation), userId: Int(self.idTextField.text ?? "0")!, mwmcreatedAt: dateString)
        /// realm側で保存
        let realmEeSense = RealmEeSense()
        realmEeSense.poorSignal = Int(poorSignal)
        realmEeSense.attention = Int(attention)
        realmEeSense.meditation = Int(meditation)
        realmEeSense.userId = 0
        realmEeSense.mwmcreatedAt = dateString
        //保存モードか確認
        if saveMode == .unsave{
           print("unsave mode")
           return
        }
        try! realm.write {
            realm.add(realmEeSense)
        }
        
        /*
        /// APIでPOST
        IsaiSensingAPI.PostMWMeSenseData().request(eegeSense: eegeSense) { response in
            let json = response.json
            if json["code"].intValue == ApplicationConfig.API.responseSuccess {
                print("post success")
            } else {
                print("post fauilure")
            }
        }
        */
    }
    
    func checkPoorSignal(poorSignal: Int32){
        mwmpoorSignal.append(poorSignal)
        let avePoorSignal =  Int(mwmpoorSignal.reduce(0, +)) / mwmpoorSignal.count
        switch avePoorSignal {
        case 0...5:
            self.mwmConnectLevel.image = UIImage(named: "greenbar.png")
        case 5...50:
            self.mwmConnectLevel.image = UIImage(named: "orangebar.png")
        case 50...1000:
            self.mwmConnectLevel.image = UIImage(named: "redbar.png")
        default:
            self.mwmConnectLevel.image = UIImage(named: "redbar.png")
        }
        print(mwmpoorSignal)
        if mwmpoorSignal.count > 5 {
            mwmpoorSignal.removeFirst()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.devices.count)
        if tableView.tag == 1 {
            return self.devices.count
        } else {
            return peripherals.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BluetoothDeviceTableViewCell = tableView.dequeueReusableCell(withIdentifier: "bluetoothDeviceListCell", for: indexPath) as! BluetoothDeviceTableViewCell
        print(tableView.tag)
        if tableView.tag == 1 {
            // セルに表示する値を設定する
            // mindwavemobile
            cell.setDeviceLabel(deviceId: devices[indexPath.row].mfgID)
        } else {
            // セルに表示する値を設定する
            // miband4
            
            let cellName = setCellName(uuid: peripherals[indexPath.row].identifier.uuidString)
            cell.setDeviceLabel(deviceId: cellName)
        }
            return cell
    }
    
    func setCellName(uuid: String) -> String{
        print(uuid)
        switch uuid {
        case "7EFF5824-B87A-A276-CC2C-A1287DEAC607" ,"A2754C44-1928-943A-B05F-1163AD6C4106","533DE7FE-7651-23CB-BF1A-2DF0C1EEA554","382EBE6C-D5DA-4B4A-5FDC-74A6F7E868FB","E8E1F004-8671-BEB2-60FD-93D8EA4D5A56":
            return "宇宙飛行士" + uuid
        case "10B30868-1123-6C38-F91C-BEBF1DC048F6","572BEF2E-E584-142A-C3A9-DB682CDC4861","082AF441-8F3D-A2F1-6021-8BC334DA7B5A","B10C3AA6-9DEE-45AA-2D88-A792399DEC34","A4B93E1F-0B13-F347-3F58-DC1AF2B13101","7E913763-301E-FB6E-71CD-83956AF58051":
            return "猫" + uuid
        case "D67FAAC2-B53E-DDAB-E82F-A9BC5021D9FB","46D00388-3C10-17BB-2F32-F4DF5DDB216F","D7497EAD-0564-FB4B-EFB1-28C45D48FF9E","64654E03-3B91-CFC3-3566-F5604D771FCF","1A7A57C2-211A-A469-9304-9F772D427EAC","28F94530-BA46-BC9D-EA03-7EE3BBA569EC":
            return "しろくま" + uuid
        case "194CF0A6-160E-2F5C-C372-F9A3AC68F982","81672B0F-C4CE-DDF6-723F-AC9C6A52B315","F42FDE51-8ED3-9D3F-488C-C0258AEFCA78","98B0CD5C-DC0B-A11F-D51B-4C4D171D8CF3","4EFC27C4-D239-F2A6-ECD3-2116F5289B4E","9AB89DDB-8F85-B9DE-1746-9A60D9FD48EF":
            return "ロケット" + uuid
        case "6362AB13-205D-D003-749E-97F1C5807A54","E7EE9111-A689-4D46-CCAB-92C7B541E9A4","87D345A4-F5DF-8872-7598-34B4F5FEC84B","A9DAC34B-6952-8D90-0B27-92D909E390E0","C44F179F-ECA0-0085-9336-6F067B883C95","4537BF9E-7E3E-B228-869F-F092C5AE0916":
            return "緑　お団子　恐竜" + uuid
        default:
            return "不明な" + uuid
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            mwm?.connect(self.devices[indexPath.row].deviceID)
        } else {
            self.connectMiBand(uuid: self.peripherals[indexPath.row].identifier.uuidString)
            
        }
    }
    
    
    @IBAction func miBandScanButton(_ sender: Any) {
        peripherals.removeAll()
        self.startBluetoothScan()
    }
    
    /// 保存モードの切り替え
    @IBAction func changeModeButton(_ sender: Any) {
        self.showConfirmDialog(message: "保存モードを切り替えますか？") { result in
            if case .ok = result {
                print("hey")
                /// これ以降はOKを押した時の処理
                if self.saveMode == .unsave {
                    self.saveMode = .saving
                    self.modeButton.setTitle("モード：保存する", for: .normal)
                } else {
                    self.saveMode = .unsave
                    self.modeButton.setTitle("モード：保存しない", for: .normal)
                }
            }
            
        }
    }
    
    
    
    /// MARK: CBCentralManagaer
    /// 接続先の機器
    private var connectPeripheral: CBPeripheral? = nil
    /// 対象のキャラクタリスティック
    private var writeCharacteristic: CBCharacteristic? = nil
    
    var centralManager: CBCentralManager?
    var peripherals: [CBPeripheral] = []
    
    private let monitoredIDs: [MiCharacteristicID] = [.heartRateMeasurement, .activity, .deviceEvent]
    
    private var hrControlPointCharacteristic: CBCharacteristic?
    
    /// Bluetoothのステータスを取得する(CBCentralManagerの状態が変わる度に呼び出される)
    ///
    /// - Parameter central: CBCentralManager
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth PoweredOff")
            break
        case .poweredOn:
            print("Bluetooth poweredOn")
            break
        case .resetting:
            print("Bluetooth resetting")
            break
        case .unauthorized:
            print("Bluetooth unauthorized")
            break
        case .unknown:
            print("Bluetooth unknown")
            break
        case .unsupported:
            print("Bluetooth unsupported")
            break
        }
    }

    // MARK: - Public Methods

    /// Bluetooth接続のセットアップ
    func setupBluetoothService() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    /// スキャン開始
    func startBluetoothScan() {
        print("スキャン開始")
        ///   サービスのUUIDを指定する
        let service: [CBUUID] = [MiBand4Service.UUID_SERVICE_MIBAND2_SERVICE]
        /// withServicesは[CBUUID]
        self.centralManager!.scanForPeripherals(withServices: service, options: nil)
    }
    
    /// ペリフェラルが見つかると下記が実行される 目的のペリフェラルはあとで選択する
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let isDevice = peripherals.firstIndex(where: { $0.identifier == peripheral.identifier}) ?? 0
        if isDevice == 0 {
            peripherals.append(peripheral)
            miBandDeviceListTable.reloadData()
        }
    }

    var cbPeripheral: CBPeripheral? = nil
    
    /// 機器に接続
    func connectMiBand(uuid: String) {
        for peripheral in peripherals {
            if peripheral.name != nil && peripheral.name == "Mi Smart Band 4" && peripheral.identifier.uuidString == uuid {
                print("connect:" + uuid)
                self.showAlertDialog(message: "Mi Bandと接続完了しました。")
                cbPeripheral = peripheral
                stopBluetoothScan()
                break;
            }
        }
        
        if cbPeripheral != nil {
            centralManager!.connect(cbPeripheral!, options: nil)
        }
    }
    
    /// スキャン停止
    func stopBluetoothScan() {
        self.centralManager?.stopScan()
    }
    
    
    // 接続が成功すると呼ばれるデリゲートメソッド
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        cbPeripheral?.delegate = self
        
        // 指定のサービスを探す
        let services: [CBUUID] = [MiBand4Service.UUID_SERVICE_HEART_RATE]
        cbPeripheral!.discoverServices(services)
    }
    
    // 接続が失敗すると呼ばれるデリゲートメソッド
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
       print("connection failed.")
    }
    
    
    /// サービスが見つかるとこのメソッドが走る
    /// サービスUUIDで探したperipheralのキャラクタリスティックUUIDを設定する
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in cbPeripheral!.services! {
            print("find serviceuuid: " + service.uuid.uuidString)
            if(service.uuid.uuidString == MiBand4Service.UUID_SERVICE_HEART_RATE.uuidString) {
                cbPeripheral?.discoverCharacteristics(nil, for: service)
             }
        }
    }
    
    /// キャラクタリスティックが見つかるとNotifyやWriteとなど動作がありそれぞれに対する動作が行われる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("\n\(service)")
        
//        service.characteristics?.forEach { characteristic in
//
//            guard let miCharacteristicID = MiCharacteristicID(rawValue: characteristic.uuid.uuidString) else { return }
//
//            if monitoredIDs.contains(miCharacteristicID) {
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//
        
//        }
        
        for characteristic in service.characteristics!{
            guard let miCharacteristicID = MiCharacteristicID(rawValue: characteristic.uuid.uuidString) else { return }
            switch miCharacteristicID {
            case .heartRateControlPoint:
                hrControlPointCharacteristic = characteristic
            default:
                break
            }

            if characteristic.uuid ==  MiBand4Service.UUID_CHARACTERISTIC_HEART_RATE_DATA {
                print("find heart rate data")
                //Notificationを受け取るハンドラ
                peripheral.setNotifyValue(true, for: characteristic)
                peripheral.readValue(for: characteristic)
                //peripheral.writeValue(Data(MiCommand.startHeartRateMeasurement), for: characteristic, type: .withResponse)
            }
//            if characteristic.uuid == MiBand4Service.UUID_CHARACTERISTIC_HEART_RATE_CONTROL {
//                print("find heart rate control")
//                peripheral.setNotifyValue(true, for: characteristic)
//                peripheral.readValue(for: characteristic)
//                print(characteristic)
//                //peripheral.writeValue(Data(MiCommand.startHeartRateMeasurement), for: characteristic, type: .withResponse)
//            }
            
        }
        
    }
    
    /// readValueだとこっちが動く
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        //guard let miCharacteristicID = MiCharacteristicID(rawValue: characteristic.uuid.uuidString),
          //  updatableIDs.contains(miCharacteristicID) || monitoredIDs.contains(miCharacteristicID) else { return }
        //コマンドから characteristicidを持ってくる 2A37
        let miCharacteristicID = "2A37"
        guard let value = characteristic.value else {
            print("New value: null for: \(characteristic)")
            return
        }
        
        let valueBytes = value.bytes()
        let hexValue = value.chunkedHexEncodedString()

        print("New value: \(hexValue) for: \(characteristic)")

        self.handleCharacteristicValueUpdate(characteristicID: miCharacteristicID, valueBytes: valueBytes)
    }
    
    func handleCharacteristicValueUpdate(characteristicID: String, valueBytes: [UInt8]) {
        if characteristicID == "2A37" {
            let heartRateData = valueBytes[1]
            print("❤️", "Heart rate:", "\(heartRateData) BPM")
            let dateString = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
            /// realm側で保存
            let realmHeartRate = RealmHeartRate()
            realmHeartRate.heartRate = Int(heartRateData)
            realmHeartRate.mbcreatedAt = dateString
            //保存モードか確認
            if saveMode == .unsave{
               print("unsave mode")
               return
            }
            try! realm.write {
                realm.add(realmHeartRate)
            }
            
            /// APIでPOST
            let heartRate = HeartRate(heartRate: Int(heartRateData), userId: 0, mbcreatedAt: dateString)
            IsaiSensingAPI.PostHeartRate().request(heartRate: heartRate) { response in
                let json = response.json
                if json["code"].intValue == ApplicationConfig.API.responseSuccess {
                    print("post heart rate success")
                } else {
                    print("post heart rate fauilure")
                }
            }
        }
       
    }
}
