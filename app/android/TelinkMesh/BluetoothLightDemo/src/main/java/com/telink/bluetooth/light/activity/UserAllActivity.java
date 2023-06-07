/********************************************************************************************************
 * @file UserAllActivity.java
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
package com.telink.bluetooth.light.activity;

import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;

import com.telink.bluetooth.event.NotificationEvent;
import com.telink.bluetooth.light.NotificationInfo;
import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;
import com.telink.bluetooth.light.TelinkLightApplication;
import com.telink.bluetooth.light.TelinkLightService;
import com.telink.util.Arrays;
import com.telink.util.Event;
import com.telink.util.EventListener;

import java.text.SimpleDateFormat;

/**
 * Created by Administrator on 2017/3/22.
 */

public class UserAllActivity extends TelinkBaseActivity implements EventListener<String> {
    TextView tv_info;
    SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_all);
        tv_info = (TextView) findViewById(R.id.info);
        tv_info.setText("log:");
//        TelinkLightApplication.getApp().addEventListener(NotificationEvent.ONLINE_STATUS, this);
        TelinkLightApplication.getApp().addEventListener(NotificationEvent.USER_ALL_NOTIFY, this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        TelinkLightApplication.getApp().removeEventListener(this);
        if (this.handler != null) {
            handler.removeCallbacksAndMessages(null);
        }
    }

    private Handler handler = new Handler();
    //    private boolean userAllRunning = false;
    private final static long PERIOD = 5 * 1000;
    private Runnable notifyTask = new Runnable() {
        @Override
        public void run() {
            userAll();
            tv_info.append("\n");
            handler.postDelayed(this, PERIOD);
        }
    };

    private long lastTime = 0;

    public void get(View view) {
        /*if (userAllRunning) {
            handler.removeCallbacks(notifyTask);
            ((Button) view).setText("Stopped");
        } else {
            handler.post(notifyTask);
            ((Button) view).setText("Started");
        }
        userAllRunning = !userAllRunning;*/
        lastTime = System.currentTimeMillis();
        userAll();
        index = 0;
    }


    private void userAll() {
        byte opcode = (byte) 0xEA;
        byte params[] = new byte[]{0x10};
        int address = 0xFFFF;
        TelinkLightService.Instance().sendCommandNoResponse(opcode, address, params);
    }

    private int index = 0;

    @Override
    public void performed(Event<String> event) {
        if (event.getType().equals(NotificationEvent.USER_ALL_NOTIFY)) {
            NotificationInfo info = ((NotificationEvent) event).getArgs();
            final String msg = Arrays.bytesToHexString(info.params, ":");
            index++;
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    tv_info.append("\n" + (System.currentTimeMillis() - lastTime) + "ms   " + index + ":\t  " + msg);
//                    tv_info.append("\n" + format.format(Calendar.getInstance().getTimeInMillis())  + ":\t  " + msg);
//                    tv_info.append("\n" + format.format(Calendar.getInstance().getTimeInMillis()) + index + ":\t  " + msg);

                }
            });
        }
    }

    public void clear(View view) {
        index = 0;
        tv_info.setText("log:");
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
                        Toast.makeText(UserAllActivity.this, "fileName cannot be null", Toast.LENGTH_SHORT).show();
                    } else {
                        TelinkLightApplication.getApp().saveLogInFile(editText.getText().toString().trim(), tv_info.getText().toString());
                    }
                }
            });
            dialog = dialogBuilder.create();
        }
        dialog.show();


    }
}
