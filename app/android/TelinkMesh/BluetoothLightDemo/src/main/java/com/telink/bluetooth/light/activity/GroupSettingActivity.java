/********************************************************************************************************
 * @file     GroupSettingActivity.java 
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
package com.telink.bluetooth.light.activity;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.ImageView;
import android.widget.TextView;

import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;
import com.telink.bluetooth.light.fragments.GroupSettingFragment;
import com.telink.bluetooth.light.model.Group;
import com.telink.bluetooth.light.model.Groups;

public final class GroupSettingActivity extends TelinkBaseActivity {

	private ImageView backView;
	private GroupSettingFragment settingFragment;

	private int groupAddress;

	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);

		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		this.setContentView(R.layout.activity_group_setting);

		this.groupAddress = this.getIntent().getIntExtra("groupAddress", 0);

		Group group = Groups.getInstance().getByMeshAddress(groupAddress);

		if (group != null) {
			TextView txtTitle = (TextView) this
					.findViewById(R.id.txt_header_title);
			txtTitle.setText(group.name);
		}

		this.backView = (ImageView) this
				.findViewById(R.id.img_header_menu_left);
		this.backView.setOnClickListener(this.clickListener);

		this.settingFragment = (GroupSettingFragment) this.getFragmentManager()
				.findFragmentById(R.id.group_setting_fragment);

		this.settingFragment.groupAddress = groupAddress;
	}

	private OnClickListener clickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			if (v == backView) {
				finish();
			}
		}
	};
}
