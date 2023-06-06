/********************************************************************************************************
 * @file TypeSelectAdapter.java
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
package com.telink.bluetooth.light.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.telink.bluetooth.light.DeviceInfo;
import com.telink.bluetooth.light.R;

import java.util.List;

/**
 * Created by kee on 2017/12/19.
 */

public class ScanningDevicesAdapter extends BaseRecyclerViewAdapter<ScanningDevicesAdapter.ViewHolder> {
    private List<DeviceInfo> devices;
    private Context context;

    public ScanningDevicesAdapter(Context context, List<DeviceInfo> devices) {
        this.context = context;
        this.devices = devices;
    }


    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(context).inflate(R.layout.item_scanning_device, parent, false);
        ViewHolder holder = new ViewHolder(itemView);
        holder.tv_info = (TextView) itemView.findViewById(R.id.tv_info);
        return holder;
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, final int position) {
        super.onBindViewHolder(holder, position);
        DeviceInfo deviceInfo = devices.get(position);
        String info = "Mac: " + deviceInfo.macAddress
                + " Type: 0x" + String.format("%02X", deviceInfo.productUUID)
                + " Rssi: " + deviceInfo.rssi;
        holder.tv_info.setText(info);
    }

    @Override
    public int getItemCount() {
        return devices == null ? 0 : devices.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        TextView tv_info;

        public ViewHolder(View itemView) {
            super(itemView);
        }
    }

}
