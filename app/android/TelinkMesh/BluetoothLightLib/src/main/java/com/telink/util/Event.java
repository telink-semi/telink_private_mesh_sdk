/********************************************************************************************************
 * @file Event.java
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

package com.telink.util;

public class Event<T> {

    protected Object sender;
    protected T type;
    protected ThreadMode threadMode = ThreadMode.Default;

    public Event(Object sender, T type) {
        this(sender, type, ThreadMode.Default);
    }

    public Event(Object sender, T type, ThreadMode threadMode) {
        this.sender = sender;
        this.type = type;
        this.threadMode = threadMode;
    }

    public Object getSender() {
        return sender;
    }

    public T getType() {
        return type;
    }

    public ThreadMode getThreadMode() {
        return this.threadMode;
    }

    public Event<T> setThreadMode(ThreadMode mode) {
        this.threadMode = mode;
        return this;
    }

    public enum ThreadMode {
        Background, Main, Default,
        ;
    }
}