//
//  DetailViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 4/3/21.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON
import CoreBluetooth

class SeedlingPeripheral: NSObject {
    
    public static let seedlingDataSensorUUID = CBUUID.init(string: "FFE0")
    public static let characterCharacteristicCBUUID = CBUUID(string: "FFE0")
}


class DetailViewModel : NSObject, ObservableObject, CBPeripheralDelegate, CBCentralManagerDelegate {
        
    @Published var plantMoistureLevel = ""
    
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    let plant: Plant
    var hasBLEDevice = false
    
    
    init(plant: Plant) {
        self.plant = plant;
        if(self.plant.name == "Ivy") {
            hasBLEDevice = true
        }
        super.init()
        if(self.hasBLEDevice) {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    func getPlantName() -> String {
        return plant.name!
    }
    
    func getPlantWaterAt() -> String {
        return plant.waterAt!
    }
    
    func getPlantMoistureLevel() -> String {
        return self.plantMoistureLevel
    }
    
    
    
    func getPlantInformation() {
        let treflePlantId = plant.treflePlantId
        let par = ["q" : treflePlantId]
        
        //var name: String? = plant.treflePlantId
        if let unwrapped = treflePlantId {
            print("\(unwrapped) letters")
            AF.request("https://trefle.io/api/v1/plants/\(unwrapped)?token=_SsZd0R46iCZ5QF9zHP9eyeONarcvEvU5CsO-fOfRIg",
                       method: .get,
                       parameters: par,
                       encoder: URLEncodedFormParameterEncoder.default)
                .cURLDescription { description in
                    //print(description)
                }.responseJSON { response in
                    //print(response)
                    //to get status code
                    if let status = response.response?.statusCode {
                        switch(status){
                            case 200:
                                print("example success")
                            default:
                                print("Trefle error with response status: \(status)")
                        }
                    }
                    switch response.result {
                        case .success(let value) :
                            //print(JSON(value))
                            let json = JSON(value)
                            self.parsePlantInformation(json: json)
                            
                        case .failure(_):
                            print("failure")
                    }
                }
        } else {
            print("Missing name.")
        }
    }
    
    func parsePlantInformation(json: JSON) {
        print(json);
        
    }
    
    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", SeedlingPeripheral.seedlingDataSensorUUID);
            centralManager.scanForPeripherals(withServices: [SeedlingPeripheral.seedlingDataSensorUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // We've found it so stop scan
        self.centralManager.stopScan()
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
        
    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Seedling Device")
            peripheral.discoverServices([SeedlingPeripheral.seedlingDataSensorUUID]);
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            print("Disconnected")
            
            
            self.peripheral = nil
            
            // Start scanning again
            print("Central scanning for", SeedlingPeripheral.seedlingDataSensorUUID);
            centralManager.scanForPeripherals(withServices: [SeedlingPeripheral.seedlingDataSensorUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == SeedlingPeripheral.seedlingDataSensorUUID {
                    print("Seedling Device Connected")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([], for: service)
                }
            }
        }
    }
    
    // Gets Properties for HM-10 and if it contains notify will asynchronously the next function
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print(characteristic)
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    // Called Asynchrounously
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        switch characteristic.uuid {
            case SeedlingPeripheral.characterCharacteristicCBUUID:
                let moistureLevel = moistureReading(from: characteristic)
                print(moistureLevel)
                self.plantMoistureLevel = moistureLevel
            default:
                print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    // Parse data from HM-10
    private func moistureReading(from characteristic: CBCharacteristic) -> String {
        guard let characteristicData = characteristic.value else { return "-1" }
        let byteArray = [UInt8](characteristicData)
        
        var val = ""
        for i in byteArray {
            val.append((Character(Unicode.Scalar(i))))
        }
        
        return val
    }
    
}
    

