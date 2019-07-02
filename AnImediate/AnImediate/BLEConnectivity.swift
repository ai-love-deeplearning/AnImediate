//
//  BLEConnectivity.swift
//  surechigaiApp
//
//  Created by 川村周也 on 2019/02/15.
//  Copyright © 2019 川村周也. All rights reserved.
//

import UIKit
import CoreBluetooth
import UserNotifications

// なぜかボタンを二回押さないとできない。

class BLEConnectivity: NSObject {
    
    static let manager = BLEConnectivity()
    
    private var notificationRecieveHandler: ((Data) -> Void)? = nil
    
    // プロパティ定義
    var peripheralManager: CBPeripheralManager!
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var serviceUUID = CBUUID(string: "0011")
    let charactericUUID = CBUUID(string: "0012")
    var characteristic: CBMutableCharacteristic!
    
    var notification = ["none"]
    
    // 送るデータ
    var sendData: Data = Data()
    
    var backgroundTaskID : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    private override init() {
        super.init()
        
        let centralOptions: Dictionary = [CBCentralManagerOptionRestoreIdentifierKey: "myKey"]
        let peripheralOptions: Dictionary = [CBPeripheralManagerOptionRestoreIdentifierKey: "myKey",]
        // 初期化
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: centralOptions)
        centralManager = CBCentralManager(delegate: self, queue: nil, options: peripheralOptions)
    }
    
    func start(notificationRecieveHandler: ((Data) -> Void)? = nil) {
        
        self.notificationRecieveHandler = notificationRecieveHandler
        
        stopAdvertise()
        startScan()
        
    }
    
    func startAdvertise() {
        
        let advertisementData = [CBAdvertisementDataLocalNameKey: "Test Device",
                                 CBAdvertisementDataServiceUUIDsKey: [serviceUUID]] as [String : Any]
        
        self.publishservice()
        self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func stopAdvertise() {
        peripheralManager.stopAdvertising()
        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
    }
    
    func startScan(notificationRecieveHandler: ((Data) -> Void)? = nil) {
        
        self.notificationRecieveHandler = notificationRecieveHandler
        
        // スキャン開始
        print("スキャン開始")
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        // 5秒後スキャン停止
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) {_ in
            print("スキャン停止")
            self.centralManager.stopScan()
        }
    }
    
    func stopScan() {
        self.centralManager.stopScan()
    }
    
    // サービスの登録
    func publishservice () {
        self.serviceUUID = CBUUID(string: "0011")
        // サービスを作成
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        // キャラクタリスティックを作成
        let characteristicUUID = CBUUID(string: "0012")
        
        let properties = (
            CBCharacteristicProperties.notify.rawValue |
                CBCharacteristicProperties.read.rawValue |
                CBCharacteristicProperties.write.rawValue)
        
        let permissions = (
            CBAttributePermissions.readable.rawValue |
                CBAttributePermissions.writeable.rawValue)
        
        self.characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: CBCharacteristicProperties(rawValue: properties),
            value: nil,
            permissions: CBAttributePermissions(rawValue: permissions))
        
        // キャラクタリスティックをサービスにセット
        service.characteristics = [self.characteristic]
        
        // サービスを Peripheral Manager にセット
        self.peripheralManager.add(service)
    }
    
    func setSendData(data: Data) -> Bool {
        guard case .poweredOn = peripheralManager.state else { return false }
        sendData = data
        return true
    }
    
    // push通知の設定
    func setupNotice() {
        let center = UNUserNotificationCenter.current()
        // 通知内容の設定
        let content = UNMutableNotificationContent()
        
        content.title = "surechigaiApp"
        content.body = "新規の広告を受信しました。"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: " Identifier", content: content, trigger: trigger)
        
        // 通知を登録
        center.add(request) { (error : Error?) in
            if error != nil {
                // エラー処理
            }
        }
        // 通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}

extension BLEConnectivity: CBPeripheralManagerDelegate {
    
    // 状態変化を取得
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("periState: \(peripheral.state)")
        
        switch peripheral.state {
            
        case .poweredOn:
            // サービス登録開始
            self.publishservice()
            break
            
        default:
            break
        }
    }
    
    // サービス追加結果を取得
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
            print("Service Add Failed...")
            return
        }
        print("Service Add Success!")
    }
    
    // アドバタイズ結果を取得
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error != nil {
            print("***Advertising ERROR")
            return
        }
        print("Advertising success")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        
        if request.characteristic.uuid.isEqual(characteristic.uuid) {
            // CBMutableCharacteristicのvalueをCBATTRequestのvalueにセット
            let data: Data = sendData
            print("data: \(String(describing: data))")
            self.characteristic.value = data
            request.value = self.characteristic.value
            
            // リクエストに応答
            peripheralManager.respond(to: request, withResult: .success)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: dict)
    }
    
}

extension BLEConnectivity: CBPeripheralDelegate {
    
    // サービス検索結果の取得
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else{
            print("error")
            return
        }
        print("\(services.count)個のサービスを発見。\(services)")
        
        //  サービスを見つけたらすぐにキャラクタリスティックを取得
        for obj in services {
            peripheral.discoverCharacteristics([charactericUUID], for: obj)
        }
    }
    
    // キャラクタリスティック検索結果の取得
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            print("\(characteristics.count)個のキャラクタリスティックを発見。\(characteristics)")
            
            peripheral.readValue(for: characteristics[0])
        }
    }
    
    // Read
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Failed... error: \(error)")
            return
        }
        print("Succeeded! service uuid: \(characteristic.service.uuid), characteristic uuid: \(characteristic.uuid), value: \(String(describing: characteristic.value))")
        
        // バッテリーレベルのキャラクタリスティックかどうかを判定
        if characteristic.uuid.isEqual(CBUUID(string: "0012")) {
            notificationRecieveHandler?(characteristic.value!)
            let text = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue)
            print(text!)
            
            // 通知
            setupNotice()
        }
    }
    
}

extension BLEConnectivity: CBCentralManagerDelegate {
    
    // 状態変化を取得
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print ("state: \(central.state)")
    }
    
    // スキャン結果取得
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("peripheral: \(peripheral)")
        self.peripheral = peripheral
        // 見つけたペリフェラルへの接続開始
        self.centralManager.connect(self.peripheral, options: nil)
    }
    
    //  ペリフェラルへの接続成功時
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connect success!")
        
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }
    
    //  ペリフェラルへの接続失敗時
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connect failed...")
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        centralManager = CBCentralManager(delegate: self, queue: nil, options: dict)
    }
    
}
