/********************************************************************************************************
 * @file QRCodeShareActivity.java
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
package com.telink.bluetooth.light.activity.share;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;


public final class QRCodeShareActivity extends TelinkBaseActivity {
    private static final int PERMISSION_REQUEST_CODE_CAMERA = 0x01;
    private ImageView qr_image;
    QRCodeGenerator mQrCodeGenerator;
    private final static int Request_Code_Scan = 1;

    @SuppressLint("HandlerLeak")
    Handler mGeneratorHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == QRCodeGenerator.RESULT_GENERATE_SUCCESS) {
                if (mQrCodeGenerator.getResult() != null)
                    qr_image.setImageBitmap(mQrCodeGenerator.getResult());
            } else {
                showToast("qr code data error!");
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_place_share);
        enableBackNav(true);
        setTitle("Share");
        qr_image = (ImageView) this.findViewById(R.id.qr_image);
        findViewById(R.id.act_share_other).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                checkPermissionAndStart();
            }
        });


        mQrCodeGenerator = new QRCodeGenerator(this, mGeneratorHandler);
        mQrCodeGenerator.execute();
    }

    private void startScanActivity() {
        startActivityForResult(new Intent(QRCodeShareActivity.this, ZXingQRScanActivity.class), Request_Code_Scan);
    }

    private void checkPermissionAndStart() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            startScanActivity();
        } else {
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                    == PackageManager.PERMISSION_GRANTED) {
                startScanActivity();
            } else {
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.CAMERA}, PERMISSION_REQUEST_CODE_CAMERA);
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQUEST_CODE_CAMERA) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                startScanActivity();
            } else {
                Toast.makeText(getApplicationContext(), "camera permission denied", Toast.LENGTH_SHORT).show();
            }
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Request_Code_Scan && resultCode == RESULT_OK) {
            setResult(RESULT_OK);
            finish();
        }
    }
}
