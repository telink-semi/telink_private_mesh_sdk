/********************************************************************************************************
 * @file LogInfoActivity.java
 *
 * @brief for TLSR chips
 *
 * @author telink
 * @date Sep. 30, 2010
 *
 * @par Copyright (c) 2010, Telink Semiconductor (Shanghai) Co., Ltd.
 *           All rights reserved.
 *
 *			 The information contained herein is confidential and proprietary property of Telink 
 * 		     Semiconductor (Shanghai) Co., Ltd. and is available under the terms 
 *			 of Commercial License Agreement between Telink Semiconductor (Shanghai) 
 *			 Co., Ltd. and the licensee in separate contract or the terms described here-in. 
 *           This heading MUST NOT be removed from this file.
 *
 * 			 Licensees are granted free, non-transferable use of the information in this 
 *			 file under Mutual Non-Disclosure Agreement. NO WARRENTY of ANY KIND is provided. 
 *
 *******************************************************************************************************/
package com.telink.bluetooth.light.activity;

import android.app.AlertDialog;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.telink.bluetooth.event.LogEvent;
import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;
import com.telink.bluetooth.light.TelinkLightApplication;
import com.telink.util.Event;
import com.telink.util.EventListener;

import java.util.List;

/**
 * Created by Administrator on 2017/3/22.
 */

public class LogInfoActivity extends TelinkBaseActivity implements EventListener<String> {
    TextView tv_info;
    ScrollView sv_log;
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == 0) {
                sv_log.fullScroll(View.FOCUS_DOWN);
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_log_info);
        tv_info = (TextView) findViewById(R.id.info);
        sv_log = findViewById(R.id.sv_log);

//        tv_info.setMovementMethod(new ScrollingMovementMethod());
        String info = TelinkLightApplication.getApp().getLogInfo();
        tv_info.setText(info);
        TelinkLightApplication.getApp().addEventListener(LogEvent.LOG_REPORT, this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        TelinkLightApplication.getApp().removeEventListener(this);
    }

    public void clear(View view) {
        TelinkLightApplication.getApp().clearLogInfo();
        String info = TelinkLightApplication.getApp().getLogInfo();
        tv_info.setText(info);
    }

    boolean refreshEnable = false;

    public void refresh(View view) {
        refreshEnable = !refreshEnable;
        ((Button) view).setText(refreshEnable ? "refresh(enabled)" : "refresh(disabled)");
        
    }

    AlertDialog dialog;

    public void save(View view) {
        if (dialog == null) {
            AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(this);
            final EditText editText = new EditText(this);
            dialogBuilder.setView(editText);
            dialogBuilder.setNegativeButton("cancel", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            }).setPositiveButton("confirm", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (TextUtils.isEmpty(editText.getText().toString())) {
                        Toast.makeText(LogInfoActivity.this, "fileName cannot be null", Toast.LENGTH_SHORT).show();
                    } else {

                        TelinkLightApplication.getApp().saveLogInFile(editText.getText().toString().trim(), tv_info.getText().toString());
                    }
                }
            });
            dialog = dialogBuilder.create();
        }
        dialog.show();
    }

    public void checkConnectDevices(View view) {
        BluetoothManager manager = (BluetoothManager) this.getSystemService(Context.BLUETOOTH_SERVICE);
        List<BluetoothDevice> devices = manager.getConnectedDevices(BluetoothProfile.GATT);
//        Toast.makeText(this, "当前连接设备个数" + devices.size(), Toast.LENGTH_SHORT).showToast();
        TelinkLightApplication.getApp().saveLog("The connected device count: " + devices.size());
        for (BluetoothDevice device : devices) {
            TelinkLightApplication.getApp().saveLog("\tThe connected device: " + device.getName() + "--" + device.getAddress());
        }
    }

    @Override
    public void performed(Event<String> event) {
        if (event.getType().equals(LogEvent.LOG_REPORT)) {
            String info = TelinkLightApplication.getApp().getLogInfo();
            tv_info.setText(info);
            handler.obtainMessage(0).sendToTarget();
        }
    }
}
