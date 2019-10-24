#
# Copyright (C) 2019 The MoKee Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := slotswitcher
LOCAL_MODULE_CLASS := RECOVERY_EXECUTABLES
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin

LOCAL_HEADER_LIBRARIES := \
    libhardware_headers \
    libsystem_headers

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    liblog \
    libz \
    libhardware

LOCAL_STATIC_LIBRARIES := \
    libgptutils

LOCAL_C_INCLUDES += $(TARGET_OUT_HEADERS)/gpt-utils/inc

LOCAL_C_FLAGS := -Wall -Werror
LOCAL_LDFLAGS := -Wl,-dynamic-linker,/sbin/linker64

LOCAL_SRC_FILES := \
    boot_control.cpp \
    slotswitcher.cpp

include $(BUILD_EXECUTABLE)
