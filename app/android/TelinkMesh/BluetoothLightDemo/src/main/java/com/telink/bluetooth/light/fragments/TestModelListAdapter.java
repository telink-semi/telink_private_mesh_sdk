/********************************************************************************************************
 * @file TestModelListAdapter.java
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
package com.telink.bluetooth.light.fragments;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.adapter.BaseRecyclerViewAdapter;
import com.telink.bluetooth.light.model.TestModel;

import java.util.List;

/**
 * Created by kee on 2017/12/19.
 */

public class TestModelListAdapter extends BaseRecyclerViewAdapter<TestModelListAdapter.ViewHolder> {
    private List<TestModel> models;
    private int selectPosition = 0;
    private Context context;
    private boolean isSettingMode = false;

    public TestModelListAdapter(Context context, List<TestModel> models) {
        this.context = context;
        this.models = models;
    }


    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(context).inflate(R.layout.item_test_model, null);
        ViewHolder holder = new ViewHolder(itemView);
        holder.tv_name = (TextView) itemView.findViewById(R.id.tv_model_name);
        return holder;
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        super.onBindViewHolder(holder, position);
//        holder.tv_name.setText(models.get(position).getOpCode() + "");
        if (isSettingMode && position == selectPosition) {
            holder.itemView.setBackgroundResource(R.color.theme_positive_color);
        } else {
            holder.itemView.setBackgroundResource(0);
        }


        if (!isSettingMode) {
            if (models.get(position).isHolder()) {
                holder.itemView.setVisibility(View.INVISIBLE);
            } else {
                holder.itemView.setVisibility(View.VISIBLE);
            }
        }

        holder.tv_name.setText(models.get(position).getName());
    }

    @Override
    public int getItemCount() {
        return models == null ? 0 : models.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        TextView tv_name;

        public ViewHolder(View itemView) {
            super(itemView);
        }
    }

    public int getSelectPosition() {
        return selectPosition;
    }

    public void setSelectPosition(int selectPosition) {
        this.selectPosition = selectPosition;
        notifyDataSetChanged();
    }

    public void setSettingMode(boolean settingMode) {
        isSettingMode = settingMode;
    }
}
