/********************************************************************************************************
 * @file OnlineStatusTestActivity.java
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

import android.app.Service;
import android.os.Bundle;
import android.os.Handler;
import android.os.Vibrator;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;

import com.telink.bluetooth.event.NotificationEvent;
import com.telink.bluetooth.light.ConnectionStatus;
import com.telink.bluetooth.light.OnlineStatusNotificationParser;
import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;
import com.telink.bluetooth.light.TelinkLightApplication;
import com.telink.bluetooth.light.TelinkLightService;
import com.telink.bluetooth.light.model.Light;
import com.telink.bluetooth.light.model.Lights;
import com.telink.util.Event;
import com.telink.util.EventListener;

import java.util.List;

/**
 * Created by Administrator on 2017/3/22.
 */

public class OnlineStatusTestActivity extends TelinkBaseActivity implements EventListener<String> {
    TextView tv_info;

    private EditText et_interval;
    private Button btn_start_test;
    private int interval = 0;
    private boolean testStarted;
    private int index = 0;

    private int rspCnt = 0;

    private ScrollView scroller;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_online_status);
        tv_info = (TextView) findViewById(R.id.info);

        et_interval = (EditText) findViewById(R.id.et_interval);
        btn_start_test = (Button) findViewById(R.id.btn_start_test);
        scroller = (ScrollView) findViewById(R.id.scroller);
        testStarted = false;
        btn_start_test.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!testStarted) {
                    startTest();
                } else {
                    stopTest();
                }
            }
        });
        tv_info.setText("log:");
        TelinkLightApplication.getApp().addEventListener(NotificationEvent.ONLINE_STATUS, this);
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
    private Runnable notifyTask = new Runnable() {
        @Override
        public void run() {
            if (!testStarted) return;
            if (index != 0) {
                check();
            }
            userAll();
            tv_info.append("\n");
            handler.postDelayed(this, interval);
        }
    };

    private void check() {
        int count = getOnlineCount();

        tv_info.append("\n" + index + ":\t  当前在线: " + count
                + "\t  获取到在线: " + rspCnt);
        if (rspCnt < count) {
            tv_info.append(" error");
            Vibrator vib = (Vibrator) OnlineStatusTestActivity.this.getSystemService(Service.VIBRATOR_SERVICE);
            if (vib != null) {
                vib.vibrate(2000);
            } else {
                tv_info.append("\n\n震动开启错误\n\n");
            }
        }

        scrollDown();
    }

    private void scrollDown() {
        handler.post(new Runnable() {
            @Override
            public void run() {
                scroller.fullScroll(ScrollView.FOCUS_DOWN);
            }
        });


    }

    public void startTest() {
        interval = Integer.parseInt(et_interval.getText().toString().trim());
        btn_start_test.setText("stop");
        testStarted = true;
        handler.post(notifyTask);
    }

    private void stopTest() {
        testStarted = false;
        btn_start_test.setText("start");
        handler.removeCallbacksAndMessages(null);
    }


    private void userAll() {
        index++;
        rspCnt = 0;
        TelinkLightService.Instance().updateNotification();
    }


    @Override
    public void performed(Event<String> event) {
        if (event.getType().equals(NotificationEvent.ONLINE_STATUS)) {
            final List<OnlineStatusNotificationParser.DeviceNotificationInfo> notificationInfoList = (List<OnlineStatusNotificationParser.DeviceNotificationInfo>) ((NotificationEvent) event).parse();

            int size = notificationInfoList == null ? 0 : notificationInfoList.size();
            rspCnt += size;

        }

    }

    private int getOnlineCount() {
        List<Light> lights = Lights.getInstance().get();
        int result = 0;
        if (lights == null) return result;
        for (Light light : lights) {
            if (light.connectionStatus != ConnectionStatus.OFFLINE) {
                result++;
            }
        }
        return result;
    }


}
