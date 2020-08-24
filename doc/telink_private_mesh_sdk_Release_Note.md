##V1.Q.0

### Bug Fixes

* (IOS APP) �����ֻ� 1 ɾ��һ���������豸��Ȼ�����ֻ� 2 ʹ����ͬ�� mesh ��ַ�ٴ��������豸����ʱ�ֻ� 1 û����ʾ���豸��
* (IOS APP) device can't be displayed in UI of Phone1's app, when this device was kicked out by Phone1's app and then added by Phone2's app with the same mesh address.

### Features

* ���ӱ���ѡ��֧��8278 A1��
* support 8278 A1 via adding compile option.

### Performance Improvements

* (android APP) ��ĳ���豸���� GATT OTA ʱ���޸�ʶ���豸�㲥�����ж����������ж� MAC ��ַ��ͬ��Ϊ�ж� mesh ��ַ��ͬ������ andriod/IOS ��Ϊһ�¡�
* (android APP) GATT OTA: identify the device by comparing the mesh address in ADV packet instead of MAC address,keep andriod/IOS behavior consistent.

### BREAKING CHANGES

* N/A

### Notes

* Ϊ�����������Լ����ܶ�ʧ������SDKʱ����ȷ���Ѿ�����ȫ�����ļ�������������library��
* to avoid compilation errors or loss of functionality, please update all files when upgrading the SDK.


##V1.P.0
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
* update float point library ��libsoft-fp.a��, some functions run in ram.Renamed the old library to ��libsoft-fp_no_ramcode.a�� as backup.
* (android APP) update request flow of camera permission.
* (android APP) update button and icon style.


##V1.O.0_patch_001

### Bug Fixs
* �޸� bug�����û�ѡ�� 16M clock ��ʱ��sdk ȱʡ 32M �������� master ���Ӳ��������woffset=0�����ӻ�ʧ��
* Bug fix:when choose 16M clock(default is 32M),and if woffset(one of master's connect parameters) is 0,the connection will failed

#V1.O.0

### Bug Fixs
* ȡ�� DEVICE_NAME �� memcpy ��������ֹ�û�ʹ�ò���������Խ�硣
* Cancel memcpy DEVICE_NAME to avoid memory overflow by incorrect coding.
* 8258:�� ic_tag ��ش�����ǰ����ֹ�͹��Ĳ�Ʒ�����쳣��
* 8258:Fixed ic_tag in cstartup,preventing wakeup fail from deep sleep.

