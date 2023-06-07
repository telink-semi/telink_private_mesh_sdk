/********************************************************************************************************
 * @file GroupSettingActivity.java
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
import android.view.Window;

import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;
import com.telink.bluetooth.light.fragments.GroupSettingFragment;

public final class GroupSettingActivity extends TelinkBaseActivity {

    private GroupSettingFragment settingFragment;

    private int groupAddress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.setContentView(R.layout.activity_group_setting);
        enableBackNav(true);
        setTitle("Group Setting");
        this.groupAddress = this.getIntent().getIntExtra("groupAddress", 0);

        this.settingFragment = (GroupSettingFragment) this.getSupportFragmentManager()
                .findFragmentById(R.id.group_setting_fragment);

        this.settingFragment.groupAddress = groupAddress;
    }

}
