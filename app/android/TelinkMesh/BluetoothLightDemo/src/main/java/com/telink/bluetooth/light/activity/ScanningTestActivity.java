/********************************************************************************************************
 * @file DeviceScanningActivity.java
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

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.telink.bluetooth.event.LeScanEvent;
import com.telink.bluetooth.event.MeshEvent;
import com.telink.bluetooth.light.DeviceInfo;
import com.telink.bluetooth.light.LeScanParameters;
import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;
import com.telink.bluetooth.light.TelinkLightApplication;
import com.telink.bluetooth.light.TelinkLightService;
import com.telink.bluetooth.light.adapter.ScanningDevicesAdapter;
import com.telink.util.Event;
import com.telink.util.EventListener;

import java.util.ArrayList;
import java.util.List;

public final class ScanningTestActivity extends TelinkBaseActivity implements EventListener<String>, OnClickListener {

    private Button btn_scan;
    private EditText et_mesh_name, et_device_type;

    private ScanningDevicesAdapter mListAdapter;

    private TelinkLightApplication mApplication;

    private boolean scanStopped = false;

    private List<DeviceInfo> devices;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.setContentView(R.layout.activity_device_scanning_test);
        enableBackNav(true);
        setTitle("Scanning Test");
        //监听事件
        this.mApplication = (TelinkLightApplication) this.getApplication();
        this.mApplication.addEventListener(LeScanEvent.LE_SCAN, this);
        this.mApplication.addEventListener(LeScanEvent.LE_SCAN_TIMEOUT, this);
        this.mApplication.addEventListener(LeScanEvent.LE_SCAN_COMPLETED, this);

        this.mApplication.addEventListener(MeshEvent.ERROR, this);

        et_mesh_name = findViewById(R.id.et_mesh_name);
        et_device_type = findViewById(R.id.et_device_type);
        btn_scan = findViewById(R.id.btn_scan);
        btn_scan.setOnClickListener(this);
        devices = new ArrayList<>();
        mListAdapter = new ScanningDevicesAdapter(this, devices);

        RecyclerView rv_devices = findViewById(R.id.rv_devices);
        rv_devices.setLayoutManager(new LinearLayoutManager(this));
        rv_devices.setAdapter(mListAdapter);
        TelinkLightService.Instance().idleMode(true);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        this.mApplication.removeEventListener(this);
    }


    /**
     * 开始扫描
     */
    private void startScan(String name, int type) {
        scanStopped = false;
        updateScanState();
        TelinkLightService.Instance().idleMode(true);

        //扫描参数
        LeScanParameters params = LeScanParameters.create();
        params.setMeshName(name);
//        params.setOutOfMeshName("out_of_mesh");
        params.setTimeoutSeconds(15);
        params.setScanMode(false);
        if (type != -1) {
            params.setScanTypeFilter(type);
        }
//                params.setScanTypeFilter(0xFF);
//                params.setScanTypeFilter(0x00);
//                params.setScanMac("FF:FF:7A:68:6B:7F");
        TelinkLightService.Instance().startScan(params);
    }

    /**
     * 处理扫描事件
     *
     * @param event
     */
    private void onLeScan(final LeScanEvent event) {
        DeviceInfo deviceInfo = event.getArgs();

        devices.add(deviceInfo);
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mListAdapter.notifyDataSetChanged();
            }
        });
    }

    /**
     * 扫描不到任何设备了
     *
     * @param event
     */
    private void onLeScanTimeout(LeScanEvent event) {
        scanStopped = true;
        updateScanState();
    }

    private void updateScanState() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                btn_scan.setEnabled(scanStopped);
            }
        });
    }


    /**
     * 事件处理方法
     *
     * @param event
     */
    @Override
    public void performed(Event<String> event) {

        switch (event.getType()) {
            case LeScanEvent.LE_SCAN:
                this.onLeScan((LeScanEvent) event);
                break;
            case LeScanEvent.LE_SCAN_TIMEOUT:
            case LeScanEvent.LE_SCAN_COMPLETED:
                this.onLeScanTimeout((LeScanEvent) event);
                break;
        }
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btn_scan) {
            String name = et_mesh_name.getText().toString();
            if (TextUtils.isEmpty(name)) {
                showToast("input mesh name");
                return;
            }
            int deviceType = -1;
            String idInput = et_device_type.getText().toString();
            if (!TextUtils.isEmpty(idInput)) {
                deviceType = Integer.parseInt(idInput, 16);
                if (deviceType > 0xFF || deviceType < 0) {
                    showToast("input valid device type");
                    return;
                }
            }
            devices.clear();
            mListAdapter.notifyDataSetChanged();
            startScan(name, deviceType);
        }
    }
}
