## V1.S.0

### Features

* Support ZBit flash.
* Calibrate the flash vref according to the reading value from flash. 
* Improve the efficiency of ota when using ZBit flash. if customer has added your own OTA process,you need to call check_and_set_1p95v_to_zbit_flash() when OTA start.
* add low voltage detection function: if low voltage is detected, the chip will enter sleep state. for more details, please refer to the codes of 'BATT_CHECK_ENABLE'.
* add calibration for RTC in deep retention and suspend mode to improve timing accuracy.please refer to the codes of 'RTC_USE_32K_RC_ENABLE'.disabled by default.

### Bug Fixes

  * N/A

### BREAKING CHANGES

* Flash: Modify some Flash API usage for compitible.
* void flash_read_mid(unsigned char* mid) change to unsigned int flash_read_mid(void),the mid from 3byte change to 4byte.
* The API of flash_read_status、flash_write_status not provide to external use,you need use the API in the directory of flash depend on mid(eg:flash_write_status_midxxxxxx).
* The first argument of API int flash_read_mid_uid_with_check( unsigned int *flash_mid ,unsigned char *flash_uid),flash_mid need 4byte space.The second argument need 16byte,has two case,8byte or 16byte,if the flash only has 8byte uid,flash_uid[8:15] will be clear to zero.
* The API of flash_lock,flash_unlock will be instead of flash_lock_midxxxxxx and flash_unlock_midxxxxxx.

### Notes

* to avoid compilation errors or loss of functionality, please update all files when upgrading the SDK.

### Features

* 支持ZBit flash。
* 根据校准值校准Flash电压。
* 当使用ZBit Flash时提升OTA效率。假如客户有增加了自己的OTA 流程，在 OTA start 的时候，则需要调用check_and_set_1p95v_to_zbit_flash()。
* 增加低电压检测功能：如果检测到低电压，芯片进入休眠状态。具体请参考BATT_CHECK_ENABLE对应的代码。
* 增加 deep retention 和 suspend 模式下 的 RTC 校准，提高计时精度。具体请参考RTC_USE_32K_RC_ENABLE对应的代码。默认关闭。

### Bug fixs

* N/A

### BREAKING CHANGES

* Flash:为兼容不同的Flash型号，Flash驱动结构做了调整，修改了部分Flash接口调用方式。
* void flash_read_mid(unsigned char* mid) 改为 unsigned int flash_read_mid(void),mid由3byte改为4byte,最高byte用于区分mid相同但是功能存在差异的flash。
* 为兼容不同型号的Flash,flash_read_status、flash_write_status不提供给外部使用，需要使用对应接口时，需要根据mid去选择flash目录下的接口(例如：flash_write_status_midxxxxxx)。
* 接口int flash_read_mid_uid_with_check( unsigned int *flash_mid ,unsigned char *flash_uid)的第一个参数flash_mid需要4个字节空间，第二个参数需要16byte空间，
现有flash的uid有两种情况，一种16byte，一种8byte，如果是8byte，flash_uid[8:15]会被清零。
* 接口flash_lock、flash_unlock由flash_lock_midxxxxxx和flash_unlock_midxxxxxx替代。

### Notes

* 为避免编译错误以及功能丢失，升级SDK时，请确认已经更新全部的文件，而不仅仅是library。

## V1.R.0

### Bug Fixes

* (Firmware) fix bug: In V1.Q version, Specific Mac Address can cause 825x project failed to enter sleep status. 
* (android APP) fix bug: OTA progress information will not be updated if killing and restarting the app during the mesh OTA process.
* (iOS APP) fix bug: if sum of new firmware sizes + 12 is exactly a multiple of 128, app will crash in mesh OTA function.

### Features

* (Firmware) add sleep function for 827x.

### Performance Improvements

* N/A

### BREAKING CHANGES

* N/A

### Notes

* to avoid compilation errors or loss of functionality, please update all files when upgrading the SDK.


### Bug Fixes

* (Firmware) 修复V1.Q版本某些Mac Address会导致825x不能正常进入retention sleep的问题。V1.Q之前的版本无此问题。
* (android APP) 修复Mesh OTA过程中从后台关闭程序再重新进入app后，没有更新OTA进度信息的问题。
* (IOS APP) 修复如果(new firmware size + 12)刚好是128的整数倍，比如65524，会导致mesh OTA崩溃的问题。

### Features

* (Firmware) 增加827x睡眠处理函数。

### Performance Improvements

* N/A

### BREAKING CHANGES

* N/A

### Notes

* 为避免编译错误以及功能丢失，升级SDK时，请确认已经更新全部的文件，而不仅仅是library。

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

