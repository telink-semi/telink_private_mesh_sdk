## V1.Q.0

### Bug Fixes

* (IOS APP) 先用手机 1 删除一个已组网设备，然后用手机 2 使用相同的 mesh 地址再次组网该设备，此时手机 1 没有显示该设备。
* (IOS APP) device can't be displayed in UI of Phone1's app, when this device was kicked out by Phone1's app and then added by Phone2's app with the same mesh address.

### Features

* 增加编译选项支持8278 A2。
* support 8278 A2 via adding compile option.

### Performance Improvements

* (android APP) 对某个设备进行 GATT OTA 时，修改识别设备广播包的判断条件，由判断 MAC 地址相同改为判断 mesh 地址相同，保持 andriod/IOS 行为一致。
* (android APP) GATT OTA: identify the device by comparing the mesh address in ADV packet instead of MAC address,keep andriod/IOS behavior consistent.

### BREAKING CHANGES

* N/A

### Notes

* 为避免编译错误以及功能丢失，升级SDK时，请确认已经更新全部的文件，而不仅仅是library。
* to avoid compilation errors or loss of functionality, please update all files when upgrading the SDK.


## V1.P.0
### Bug Fixes

* fix: when choose 16M clock(default is 32M),and if woffset(one of master's connect parameters) is 0,the connection will failed.
* (IOS APP) fix the bug that the encryption and decryption interface call at the same time.
* (IOS APP) fix the bug of creating QRcode failed if iOS system is newer than iOS 13.
* (IOS APP) fix the bug of meshOTA failed occasionally.

### Features

* update 8258 adc driver.
* add flash mapping for 8258 1M flash.
* support 32M clock for 8258.
* support external PA for 8258, disable by default.
* user can define max firmware size by setting FW_SIZE_MAX_K, default is 128K.
* add auto adapt flash size function.

### Performance Improvements

* when rebooting after OTA success, erase the old version firmware in user_init()->erase_ota_data() instead of cpu_wakeup_init()->erase_ota_data().
* mesh command of tl_ble_phone_mesh2.exe tool use write_no_response instead of write_request_response to sync APP.
* update float point library “libsoft-fp.a”, some functions run in ram.Renamed the old library to “libsoft-fp_no_ramcode.a” as backup.
* (android APP) update request flow of camera permission.
* (android APP) update button and icon style.


## V1.O.0_patch_001

### Bug Fixs
* 修复 bug：当用户选择 16M clock 的时候（sdk 缺省 32M ），而且 master 连接参数里面的woffset=0，连接会失败
* Bug fix:when choose 16M clock(default is 32M),and if woffset(one of master's connect parameters) is 0,the connection will failed

## V1.O.0

### Bug Fixs
* 取消 DEVICE_NAME 的 memcpy 动作，防止用户使用不当，导致越界。
* Cancel memcpy DEVICE_NAME to avoid memory overflow by incorrect coding.
* 8258:把 ic_tag 相关处理提前，防止低功耗产品唤醒异常。
* 8258:Fixed ic_tag in cstartup,preventing wakeup fail from deep sleep.

