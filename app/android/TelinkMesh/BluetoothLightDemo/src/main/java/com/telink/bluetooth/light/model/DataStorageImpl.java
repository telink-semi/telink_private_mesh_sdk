/********************************************************************************************************
 * @file DataStorageImpl.java
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

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public abstract class DataStorageImpl<E> implements DataStorage<E> {

    protected List<E> data;

    public DataStorageImpl() {
        this.data = new ArrayList<>();
    }

    @Override
    public void add(E e) {

        if (!this.contains(e)) {
            this.data.add(e);
        }
    }

    public void add(E e, int location) {
        if (!this.contains(e)) {
            this.data.add(0, e);
        }
    }

    @Override
    public void add(List<E> e) {
        this.data.addAll(e);
    }

    @Override
    public boolean contains(E e) {
        return this.data.contains(e);
    }

    @Override
    public boolean contains(String attributeName, Object attributeValue) {

        for (E e : this.data) {

            try {
                Field field = e.getClass().getField(attributeName);
                Object fieldValue = field.get(e);
                if (fieldValue.equals(attributeValue))
                    return true;
            } catch (NoSuchFieldException | IllegalAccessException
                    | IllegalArgumentException e1) {
            }

        }
        return false;
    }

    @Override
    public E get(String attributeName, Object attributeValue) {

        for (E e : this.data) {

            try {
                Field field = e.getClass().getField(attributeName);
                Object fieldValue = field.get(e);
                if (fieldValue.equals(attributeValue))
                    return e;

            } catch (NoSuchFieldException | IllegalAccessException
                    | IllegalArgumentException e1) {
                // e1.printStackTrace();
            }

        }
        return null;
    }

    @Override
    public List<E> get() {
        return this.data;
    }

    @Override
    public E get(int location) {
        return this.data.get(location);
    }

    @Override
    public void remove(int location) {

        if (location >= 0 && location < this.data.size()) {
            this.data.remove(location);
        }
    }

    @Override
    public void remove(E e) {
        this.data.remove(e);
    }

    @Override
    public int size() {
        return this.data.size();
    }

    @Override
    public boolean isEmpty() {
        return this.data.isEmpty();
    }

    @Override
    public void clear() {
        this.data.clear();
    }
}
