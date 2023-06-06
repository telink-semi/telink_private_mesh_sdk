/********************************************************************************************************
 * @file AES.java
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

package com.telink.crypto;

import com.telink.bluetooth.TelinkLog;
import com.telink.util.Arrays;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

public abstract class AES {

    public static boolean Security = true;


    private AES() {
    }

    public static byte[] encrypt(byte[] key, byte[] content)
            throws NoSuchAlgorithmException, NoSuchPaddingException,
            UnsupportedEncodingException, InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException,
            NoSuchProviderException {

        if (!AES.Security)
            return content;

        key = Arrays.reverse(key);
        content = Arrays.reverse(content);

        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");
        Cipher cipher = Cipher.getInstance("AES/ECB/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
        return cipher.doFinal(content);
    }

    public static byte[] decrypt(byte[] key, byte[] content)
            throws IllegalBlockSizeException, BadPaddingException,
            NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidKeyException, NoSuchProviderException {

        if (!AES.Security)
            return content;

        SecretKeySpec secretKeySpec = new SecretKeySpec(key, "AES");
        Cipher cipher = Cipher.getInstance("AES/ECB/NoPadding");
        cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
        return cipher.doFinal(content);
    }

    public static byte[] aes_att_encryption(byte[] key, byte[] content) {
        try {
            byte[] re = encrypt(key, content);
            return Arrays.reverse(re);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (NoSuchPaddingException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (IllegalBlockSizeException e) {
            e.printStackTrace();
        } catch (BadPaddingException e) {
            e.printStackTrace();
        } catch (NoSuchProviderException e) {
            e.printStackTrace();
        }
        return null;
    }

    // session key 16
    // iv 8
    // data 20 (3 seqNo, 2 mic, 15 ps)
    public static byte[] encrypt(byte[] key, byte[] iv, byte[] data) {

        if (!AES.Security)
            return data;

//        byte[] result = data.clone();
        final int micLen = 2;
//        byte[] mic = new byte[2];
        final int micIndex = 3;

        final int len = 15;
//        byte[] ps = new byte[len];
        final int psIndex = 5;


        byte[] r = new byte[16];
        byte[] e = new byte[16];
        System.arraycopy(iv, 0, r, 0, 8);
        r[8] = (byte) len;
        r = aes_att_encryption(key, r);

        for (int i = 0; i < 15; i++) {
            if (r != null) {
                r[i & 15] ^= data[i + psIndex];
            }

            if (i == len - 1) {
                r = aes_att_encryption(key, r);
            }
        }

        for (int i = 0; i < micLen; i++) {
            if (r != null) {
                data[i + micIndex] = r[i];
            }
            TelinkLog.d("data -> : " + (i + micIndex) + " -- " + data[i + micIndex]);
        }

        if (r != null) {
            for (int i = 0; i < r.length; i++) {
                r[i] = 0;
            }
        }

        if (r != null) {
            System.arraycopy(iv, 0, r, 1, 8);
        }

        for (int i = 0; i < len; i++) {
            if ((i & 15) == 0) {
                e = aes_att_encryption(key, r);
                if (r != null) {
                    r[0]++;
                }
            }
            if (e != null) {
                data[i + psIndex] ^= e[i & 15];
            }
        }
        return data;
    }

    public static byte[] decrypt(byte[] key, byte[] iv, byte[] data) {
        if (!AES.Security)
            return data;

//        byte[] result = data.clone();

        byte[] r = new byte[16];
        byte[] e = new byte[16];

        final int micIndex = 5;
        int micLen = 2;
        final int psIndex = 7;
        int len = 13;

        int i;

        System.arraycopy(iv, 0, r, 1, 8);

        for (i = 0; i < len; i++) {
            if ((i & 15) == 0) {
                e = aes_att_encryption(key, r);
                r[0]++;
            }
            if (e != null) {
                data[i + psIndex] ^= e[i & 15];
            }
        }

        for (i = 0; i < r.length; i++) {
            r[i] = 0;
        }
        System.arraycopy(iv, 0, r, 0, 8);

        r[8] = (byte) (len & 0xFF);

        r = aes_att_encryption(key, r);

        for (i = 0; i < len; i++) {
            if (r != null) {
                r[i & 15] ^= data[i + psIndex];
            }

            if ((i & 15) == 15 || i == len - 1) {
                r = aes_att_encryption(key, r);
            }
        }

        for (i = 0; i < micLen; i++) {
            if (r != null && data[i + micIndex] != r[i]) {
                return null;            //Failed
            }
        }
        return data;

    }
}