/********************************************************************************************************
 * @file     CryptoUtil.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/11/15
 *
 * @par     Copyright (c) [2017], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
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

#ifndef __TelinkBlue__CryptoUtil__
#define __TelinkBlue__CryptoUtil__

#include <stdio.h>


void _rijndaelSetKey (unsigned char *k, unsigned char aes_sw_k0[4][4], unsigned char aes_sw_k10[4][4]);
void _rijndaelEncrypt(unsigned char *a, unsigned char aes_sw_k0[4][4]);
void _rijndaelDecrypt (unsigned char *a, unsigned char aes_sw_k10[4][4]);

void aes_att_encryption (unsigned char *key, unsigned char *plaintext, unsigned char *result);
void aes_att_decryption (unsigned char *key, unsigned char *plaintext, unsigned char *result);


int		aes_att_er (unsigned char *pNetworkName, unsigned char *pPassword, unsigned char *prand, unsigned char *presult);
#endif /* defined(__TelinkBlue__CryptoUtil__) */
