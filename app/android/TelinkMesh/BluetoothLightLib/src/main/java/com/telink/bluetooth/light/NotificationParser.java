/********************************************************************************************************
 * @file NotificationParser.java
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

package com.telink.bluetooth.light;

import android.util.SparseArray;

/**
 * Notification解析器接口
 * <p>继承NotificationParser编写自定义的解析器,通过{@link NotificationParser#register(NotificationParser)}来注册.
 *
 * @param <E>
 */
public abstract class NotificationParser<E> {

    private static final SparseArray<NotificationParser> PARSER_ARRAY = new SparseArray<>();

    /**
     * 注册解析器
     *
     * @param parser
     */
    public static void register(NotificationParser parser) {
        synchronized (NotificationParser.class) {
            PARSER_ARRAY.put(parser.opcode() & 0xFF, parser);
        }
    }

    /**
     * 获取解析器
     *
     * @param opcode 操作码
     * @return
     */
    public static NotificationParser get(int opcode) {
        synchronized (NotificationParser.class) {
            return PARSER_ARRAY.get(opcode & 0xFF);
        }
    }

    public static NotificationParser get(Opcode opcode) {
        return get(opcode.getValue());
    }

    /**
     * 操作码
     *
     * @return
     */
    abstract public byte opcode();

    /**
     * 将{@link NotificationInfo#params}转换成自定义的数据格式
     *
     * @param notifyInfo
     * @return
     */
    abstract public E parse(NotificationInfo notifyInfo);
}
