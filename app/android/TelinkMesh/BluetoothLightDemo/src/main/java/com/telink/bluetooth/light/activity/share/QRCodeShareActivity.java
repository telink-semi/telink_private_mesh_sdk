/********************************************************************************************************
 * @file QRCodeShareActivity.java
 *
 * @brief for TLSR chips
 *
 * @author telink
 * @date Sep. 30, 2010
 *
 * @par Copyright (c) 2010, Telink Semiconductor (Shanghai) Co., Ltd.
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
package com.telink.bluetooth.light.activity.share;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.ImageView;

import com.telink.bluetooth.light.R;
import com.telink.bluetooth.light.TelinkBaseActivity;


public final class QRCodeShareActivity extends TelinkBaseActivity {

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
                startActivityForResult(new Intent(QRCodeShareActivity.this, ZXingQRScanActivity.class), Request_Code_Scan);
            }
        });


        mQrCodeGenerator = new QRCodeGenerator(this, mGeneratorHandler);
        mQrCodeGenerator.execute();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Request_Code_Scan && resultCode == RESULT_OK) {
            finish();
        }
    }
}
