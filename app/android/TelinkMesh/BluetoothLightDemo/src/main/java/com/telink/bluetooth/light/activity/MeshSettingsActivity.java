/********************************************************************************************************
 * @file MeshSettingsActivity.java
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

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;
import com.telink.bluetooth.light.TelinkLightApplication;
import com.telink.bluetooth.light.TelinkLightService;
import com.telink.bluetooth.light.activity.share.QRCodeShareActivity;
import com.telink.bluetooth.light.model.Mesh;
import com.telink.bluetooth.light.model.SharedPreferencesHelper;
import com.telink.bluetooth.light.util.FileSystem;

public final class MeshSettingsActivity extends TelinkBaseActivity {
    private Button btnSave;
    private Button btnShare, btnClear;
    private TextView tv_version;
    private static final int REQUEST_CODE_SHARE = 0x01;

    private TelinkLightApplication mApplication;
    private OnClickListener clickListener = new OnClickListener() {

        @Override
        public void onClick(View v) {
            if (v == btnSave) {
                saveMesh();
            } else if (v == btnShare) {
                startActivityForResult(new Intent(MeshSettingsActivity.this, QRCodeShareActivity.class), REQUEST_CODE_SHARE);
            } else if (v == btnClear) {
                if (mApplication.getMesh().devices != null) {
                    mApplication.getMesh().devices.clear();
                    showToast("mesh devices cleared");
                }
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.setContentView(R.layout.activity_add_mesh);

        this.mApplication = (TelinkLightApplication) this.getApplication();

        setTitle("Mesh Settings");
        enableBackNav(true);

        this.btnSave = (Button) this.findViewById(R.id.btn_save);
        this.btnSave.setOnClickListener(this.clickListener);

        this.btnShare = (Button) findViewById(R.id.btn_share);
        this.btnShare.setOnClickListener(this.clickListener);

        this.btnClear = (Button) findViewById(R.id.btn_clear);
        this.btnClear.setOnClickListener(this.clickListener);
        tv_version = findViewById(R.id.tv_version);
        tv_version.setText(getVersion());

        TelinkLightService.Instance().idleMode(true);
        updateGUI();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    private void updateGUI() {

        if (this.mApplication.isEmptyMesh())
            return;

        EditText txtMeshName = (EditText) this.findViewById(R.id.txt_mesh_name);
        EditText txtPassword = (EditText) this
                .findViewById(R.id.txt_mesh_password);

        EditText txtFactoryMeshName = (EditText) this
                .findViewById(R.id.txt_factory_name);
        EditText txtFactoryPassword = (EditText) this
                .findViewById(R.id.txt_factory_password);

        Mesh mesh = this.mApplication.getMesh();

        txtMeshName.setText(mesh.name);
        txtPassword.setText(mesh.password);
        txtFactoryMeshName.setText(mesh.factoryName);
        txtFactoryPassword.setText(mesh.factoryPassword);
    }

    @SuppressLint("ShowToast")
    private void saveMesh() {

        EditText txtMeshName = (EditText) this.findViewById(R.id.txt_mesh_name);
        EditText txtPassword = (EditText) this
                .findViewById(R.id.txt_mesh_password);

        EditText txtFactoryMeshName = (EditText) this
                .findViewById(R.id.txt_factory_name);
        EditText txtFactoryPassword = (EditText) this
                .findViewById(R.id.txt_factory_password);
        //EditText otaText = (EditText) this.findViewById(R.id.ota_device);

        String newfactoryName = txtMeshName.getText().toString().trim();
        String newfactoryPwd = txtPassword.getText().toString().trim();

        String factoryName = txtFactoryMeshName.getText().toString().trim();
        String factoryPwd = txtFactoryPassword.getText().toString().trim();

        if (newfactoryName.equals(newfactoryPwd)) {
            showToast("invalid! name should not equals with pwd");
            return;
        }

        if (factoryName.equals(newfactoryName)) {
            showToast("invalid! name should not equals with factory name");
            return;
        }

        if (newfactoryName.length() > 16 || newfactoryPwd.length() > 16 || factoryName.length() > 16 || factoryPwd.length() > 16) {
            showToast("invalid! input max length: 16");
            return;
        }
        if (newfactoryName.contains(".") || newfactoryPwd.contains(".")) {
            showToast("invalid! input should not contains '.' ");
            return;
        }


//        if (mesh == null)
//            mesh = new Mesh();


        Mesh mesh = (Mesh) FileSystem.readAsObject(this, newfactoryName + "." + newfactoryPwd);

        if (mesh == null) {
            mesh = new Mesh();
            mesh.name = newfactoryName;
            mesh.password = newfactoryPwd;
        }

        mesh.factoryName = factoryName;
        mesh.factoryPassword = factoryPwd;

        /*if (!factoryName.equals(mesh.factoryName) || !factoryPwd.equals(mesh.factoryPassword)) {
            mesh.allocDeviceAddress = null;
            mesh.devices.clear();
        }*/

        /*if (newfactoryName.equals(mesh.name) || newfactoryPwd.equals(mesh.password)) {
            mesh.allocDeviceAddress = null;
            mesh.devices.clear();
        }*/

        //mesh.otaDevice = otaText.getText().toString().trim();

        if (mesh.saveOrUpdate(this)) {
            this.mApplication.setupMesh(mesh);
            SharedPreferencesHelper.saveMeshName(this, mesh.name);
            SharedPreferencesHelper.saveMeshPassword(this, mesh.password);
            this.showToast("Save Mesh Success");
        } else {
            this.showToast("Save Mesh Failed");
        }
    }

    private String getVersion() {
        try {
            PackageManager manager = this.getPackageManager();
            PackageInfo info = manager.getPackageInfo(this.getPackageName(), 0);
            String version = info.versionName;
            return "V" + version;
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == REQUEST_CODE_SHARE) {
            updateGUI();
        }
    }
}
