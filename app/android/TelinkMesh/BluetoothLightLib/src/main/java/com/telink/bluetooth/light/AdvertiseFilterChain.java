/********************************************************************************************************
 * @file AdvertiseFilterChain.java
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

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * 广播过滤器链
 */
public final class AdvertiseFilterChain {

    private static final AdvertiseFilterChain DEFAULT_CHAIN = new AdvertiseFilterChain("Telink default filter chain");

    static {
        DEFAULT_CHAIN.add(DefaultAdvertiseDataFilter.create());
    }

    private String name;
    private List<AdvertiseDataFilter> mFilters;

    private AdvertiseFilterChain(String name) {
        this.name = name;
        this.mFilters = new ArrayList<>();
    }

    public static AdvertiseFilterChain getDefault() {
        return DEFAULT_CHAIN;
    }

    public String getName() {
        return name;
    }

    public AdvertiseFilterChain add(AdvertiseDataFilter filter) {
        synchronized (this) {
            this.mFilters.add(filter);
        }
        return this;
    }

    public AdvertiseFilterChain remove(AdvertiseDataFilter filter) {
        synchronized (this) {
            if (this.mFilters.contains(filter)) {
                this.mFilters.remove(filter);
            }
        }
        return this;
    }

    public AdvertiseFilterChain removeAll() {
        synchronized (this) {
            this.mFilters.clear();
        }
        return this;
    }

    public Iterator<AdvertiseDataFilter> iterator() {
        synchronized (this) {
            return this.mFilters.iterator();
        }
    }
}
