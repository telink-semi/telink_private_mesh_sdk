#//# --------------------------------------------------------------------------------------
#//# Created using Sequence Diagram for Mac
#//# https://www.macsequencediagram.com
#//# https://itunes.apple.com/gb/app/sequence-diagram/id1195426709?mt=12
#//# --------------------------------------------------------------------------------------

title "iOS Switch BLE Pairing Process"

participant "BLE Central\n(Phone)" as Phone
participant "BLE Peripheral\n(Bulb)" as Bulb

*-->Phone: Phone has discovered the Pairing characteristic
note over Phone
"""
Phone has just received the delegate callback
-[CBPeripheralDelegate didDiscoverCharacteristicsForService:error] with
the Pairing Characteristic
"""
end note
activate Phone
note left of Phone
"The Phone must configure encryption parameters
end note
Phone->Phone: loginRand = Generate random 8 bytes
Phone->Phone: username = "telink_mesh1
Phone->Phone: password = "123"
Phone->Phone: uint8_t buffer[17]
note right of Phone
"BLE_GATT_OPCODE_ENC_REQ"
end note
Phone->Phone:  
"""
[CryptoAction getEncryptRequestPacketForNetwork:username  
password:password
rm:loginRand
result:buffer+1];                                     
"""

activate Bulb
Phone->Bulb:
"""
[BTCentralManager writeValue:PairCharacteristic
Buffer:buffer Len:17
response:CBCharacteristicWriteWithResponse];
"""
Bulb->Phone: [CBPeripheralDelegate didWriteValueForCharacteristic:error]
Phone->Bulb: [CBPeripheral readValueForCharacteristic:PairCharacteristic]
note left of Bulb
"BLE_GATT_OPCODE_ENC_RES"
end note

Bulb->Phone: [CBPeripheralDelegate peripheral:didUpdateValueForCharacteristic:error:]
Phone->Phone: payload = Characteristic.value; uint8_t buffer[16];

Phone->Phone:
"""
[CryptoAction getSessionKey:buffer networkName:username
password:password rm:loginRand rs:payload + 1];  
"""
note right of Phone
"The sessionKey is copied into buffer"
end note

deactivate Phone
deactivate Bulb