/********************************************************************************************************
 * @file DeviceSettingActivity.java
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

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.MenuItem;
import android.view.Window;

import androidx.appcompat.widget.Toolbar;

import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;
import com.telink.bluetooth.light.fragments.DeviceSettingFragment;
import com.telink.bluetooth.light.model.Light;
import com.telink.bluetooth.light.model.Lights;

public final class DeviceSettingActivity extends TelinkBaseActivity {
    private DeviceSettingFragment settingFragment;

    private int meshAddress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.setContentView(R.layout.activity_device_setting);

        enableBackNav(true);
        setTitle("Light Setting");
        Toolbar toolbar = findViewById(R.id.title_bar);
        toolbar.inflateMenu(R.menu.device_setting);
        toolbar.setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                if (item.getItemId() == R.id.item_grouping) {
                    Light light = Lights.getInstance().getByMeshAddress(meshAddress);
                    if (light == null || TextUtils.isEmpty(light.macAddress)) {
                        showToast("error! Lack of mac");
                        return false;
                    }
                    Intent intent = new Intent(DeviceSettingActivity.this,
                            DeviceGroupingActivity.class);
                    intent.putExtra("meshAddress", meshAddress);
                    startActivity(intent);
                }
                return false;
            }
        });
        this.meshAddress = this.getIntent().getIntExtra("meshAddress", 0);
        this.settingFragment = (DeviceSettingFragment) this
                .getFragmentManager().findFragmentById(
                        R.id.device_setting_fragment);
        this.settingFragment.meshAddress = meshAddress;
    }
}
