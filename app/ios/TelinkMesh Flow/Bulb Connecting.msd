#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------
# Switch Connection

# Methods that can be referenced
# in the diagam include:
# [BTCentralManager exeCmd:len:]
# [BTCentralManager readValue:Buffer:]
# [BTCentralManager writeValue:Buffer:Len:response]
# Any methods from CryptoAction.h
# Any Core Bluetooth methods


title "iOS Switch BLE Connection Process"

participant "BLE Central\n(Phone)" as Phone
participant "BLE Peripheral\n(Bulb)" as Bulb

*-->Phone: Launch
note over Phone
"""
Phone begins scanning for peripheral.\n[CBCentralManager scanForPeripheralsWithServices:options]
"""
end note
activate Phone

activate Bulb
Bulb->Phone: Device Peripheral Advertistment data

Phone->Bulb: - [CBCentralManager connectPeripheral:options:]

alt [Successfully Connected]

Bulb->Phone: [CBCentralManagerDelegate centralManager:didConnectPeripheral:]
Phone->Bulb: [CBPeripheral discoverServices:]
Bulb->Phone: -[CBPeripheralDelegate didDiscoverServices:]
Phone->Bulb: -[CBPeripheral discoverCharacteristics:forService]
Bulb->Phone: -[CBPeripheralDelegate didDiscoverCharacteristicsForService:error]

alt [Pair Characteristic]

Phone->Bulb: Continued Switch Pairing.msd

note right of Phone
"See Switch Pairing.msd"
end note

else [Notification Characteristic]
Phone->Bulb:[peripheral setNotifyValue:YES forCharacteristic:NotificationCharacteristic]
 
end

else [Failed Connection]
*->Phone: [CBCentralManager didFailToConnectPeripheral:error]
Phone->**: Exit


end
deactivate Bulb
deactivate Phone