/********************************************************************************************************
 * @file     FragmentFactory.java 
 *
 * @brief    for TLSR chips
 *
 * @author	 telink
 * @date     Sep. 30, 2010
 *
 * @par      Copyright (c) 2010, Telink Semiconductor (Shanghai) Co., Ltd.
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
package com.telink.bluetooth.light.util;

import android.app.Fragment;

import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.fragments.DeviceListFragment;
import com.telink.bluetooth.light.fragments.GroupListFragment;
import com.telink.bluetooth.light.fragments.MainTestFragment;

public abstract class FragmentFactory {

    public static Fragment createFragment(int id) {

        Fragment fragment = null;

        if (id == R.id.tab_devices) {
            fragment = new DeviceListFragment();
        } else if (id == R.id.tab_groups) {
            fragment = new GroupListFragment();
        } else if (id == R.id.tab_account) {
            // todo me fragment
        } else if (id == R.id.tab_test) {
            fragment = new MainTestFragment();
        }

        return fragment;
    }
}
