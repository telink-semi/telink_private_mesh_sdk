/********************************************************************************************************
 * @file TelinkMeshErrorDealActivity.java
 *
 * @brief for TLSR chips
 *
 * @author telink
 * @date Sep. 30, 2017
 *
 * @par Copyright (c) 2017, Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
 *
 *          Licensed under the Apache License, Version 2.0 (the "License");
 *          you may not use this file except in compliance with the License.
 *          You may obtain a copy of the License at
 *
 *              http://www.apache.org/licenses/LICENSE-2.0
 *
 *          Unless required by applicable law or agreed to in writing, software
 *          distributed under the License is distributed on an "AS IS" BASIS,
 *          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *          See the License for the specific language governing permissions and
 *          limitations under the License.
 *******************************************************************************************************/
package com.telink.bluetooth.light;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.provider.Settings;

import androidx.appcompat.app.AlertDialog;

import com.telink.bluetooth.LeBluetooth;
import com.telink.bluetooth.event.MeshEvent;
import com.telink.util.ContextUtil;
import com.telink.util.Event;
import com.telink.util.EventListener;


// 添加 扫描过程中出现的因定位未开启而导致的扫描不成功问题
public abstract class TelinkMeshErrorDealActivity extends TelinkBaseActivity implements EventListener<String> {

    protected final static int ACTIVITY_REQUEST_CODE_LOCATION = 0x11;
    private AlertDialog mErrorDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ((TelinkLightApplication) getApplication()).addEventListener(MeshEvent.ERROR, this);
    }

    @Override
    public void performed(Event<String> event) {
        switch (event.getType()) {
            case MeshEvent.ERROR:
                onMeshError((MeshEvent) event);
                break;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ((TelinkLightApplication) getApplication()).removeEventListener(this);
    }

    private void dismissDialog() {

        if (mErrorDialog != null && mErrorDialog.isShowing()) {
            mErrorDialog.dismiss();
        }
    }

    protected void onMeshError(MeshEvent event) {
        if (event.getArgs() == LeBluetooth.SCAN_FAILED_LOCATION_DISABLE) {
            if (mErrorDialog == null) {
                TelinkLightService.Instance().idleMode(true);
                AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(this);
                dialogBuilder.setTitle("Error")
                        .setMessage("Location not enabled, bluetooth searching may require this")
                        .setNegativeButton("Ignore", null)
                        .setPositiveButton("Go Settings", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                Intent enableLocationIntent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                                startActivityForResult(enableLocationIntent, ACTIVITY_REQUEST_CODE_LOCATION);
                            }
                        });
                mErrorDialog = dialogBuilder.create();
            }
            mErrorDialog.show();
        } else {
            new AlertDialog.Builder(this).setMessage("Bluetooth ERR").show();
        }
    }

    protected abstract void onLocationEnable();

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == ACTIVITY_REQUEST_CODE_LOCATION) {
            if (ContextUtil.isLocationEnable(this)) {
                dismissDialog();
                onLocationEnable();
            }
        }
    }
}
