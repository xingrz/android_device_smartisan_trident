/*
 * Copyright (C) 2019 The Android Open Source Project
 * Copyright (C) 2019 The MoKee Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "VibratorService"

#include <log/log.h>

#include "Vibrator.h"

namespace android {
namespace hardware {
namespace vibrator {
namespace V1_0 {
namespace implementation {

Vibrator::Vibrator(std::ofstream&& vibrator_state,
                   std::ofstream&& vibrator_duration,
                   std::ofstream&& vibrator_activate)
    : mVibratorState(std::move(vibrator_state))
    , mVibratorDuration(std::move(vibrator_duration))
    , mVibratorActivate(std::move(vibrator_activate))
    {
}

// Methods from ::android::hardware::vibrator::V1_0::IVibrator follow.

Return<Status> Vibrator::on(uint32_t timeoutMs) {
    if (!mVibratorState || !mVibratorDuration || !mVibratorActivate) {
        return Status::UNKNOWN_ERROR;
    }

    mVibratorState << 1 << std::endl;
    mVibratorDuration << timeoutMs << std::endl;
    mVibratorActivate << 1 << std::endl;

    return Status::OK;
}

Return<Status> Vibrator::off() {
    if (!mVibratorActivate) {
        return Status::UNKNOWN_ERROR;
    }

    mVibratorActivate << 0 << std::endl;

    return Status::OK;
}

Return<bool> Vibrator::supportsAmplitudeControl() {
    return false;
}

Return<Status> Vibrator::setAmplitude(uint8_t) {
    return Status::UNSUPPORTED_OPERATION;
}

Return<void> Vibrator::perform(V1_0::Effect, EffectStrength, perform_cb _hidl_cb) {
    _hidl_cb(Status::UNSUPPORTED_OPERATION, 0);
    return Void();
}

}  // namespace implementation
}  // namespace V1_0
}  // namespace vibrator
}  // namespace hardware
}  // namespace android
