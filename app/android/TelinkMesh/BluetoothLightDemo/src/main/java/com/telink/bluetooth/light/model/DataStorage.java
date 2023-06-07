/********************************************************************************************************
 * @file DataStorage.java
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
package com.telink.bluetooth.light.model;

import java.util.List;

public interface DataStorage<E> {

    void add(E e);

    void add(E e, int location);

    void add(List<E> e);

    boolean contains(E e);

    boolean contains(String attributeName, Object attributeValue);

    E get(String attributeName, Object attributeValue);

    List<E> get();

    E get(int location);

    void remove(int location);

    void remove(E e);

    int size();

    boolean isEmpty();

    void clear();
}
