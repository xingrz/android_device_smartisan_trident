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
#define LOG_TAG "android.hardware.vibrator@1.3-service.trident"

#include <android-base/logging.h>
#include <android/hardware/vibrator/1.3/IVibrator.h>
#include <hidl/HidlTransportSupport.h>

#include "Vibrator.h"

using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;
using android::hardware::vibrator::V1_3::IVibrator;
using android::hardware::vibrator::V1_3::implementation::Vibrator;
using namespace android;

const static std::string kVibratorStatePath = "/sys/class/leds/vibrator/state";
const static std::string kVibratorDurationPath = "/sys/class/leds/vibrator/duration";
const static std::string kVibratorActivatePath = "/sys/class/leds/vibrator/activate";

const static std::string kVibratorEffectLoadPath = "/sys/class/haptic/player/load_bin";
const static std::string kVibratorEffectNamePath = "/sys/class/haptic/player/phe_name";
const static std::string kVibratorEffectPlayPath = "/sys/class/haptic/player/play_phe";

status_t registerVibratorService() {
    std::string tmp;

    std::ofstream vibratorState(kVibratorStatePath);
    if (!vibratorState) {
        LOG(ERROR) << "Failed to open " << kVibratorStatePath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
    }

    std::ofstream vibratorDuration(kVibratorDurationPath);
    if (!vibratorDuration) {
        LOG(ERROR) << "Failed to open " << kVibratorDurationPath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
    }

    std::ofstream vibratorActivate(kVibratorActivatePath);
    if (!vibratorActivate) {
        LOG(ERROR) << "Failed to open " << kVibratorActivatePath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
    }

    std::ifstream vibratorEffectLoad(kVibratorEffectLoadPath);
    if (!vibratorEffectLoad) {
        LOG(ERROR) << "Failed to open " << kVibratorEffectLoadPath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
    } else {
        vibratorEffectLoad >> tmp;
        vibratorEffectLoad.close();
    }

    std::ofstream vibratorEffectName(kVibratorEffectNamePath);
    if (!vibratorEffectName) {
        LOG(ERROR) << "Failed to open " << kVibratorEffectNamePath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
    }

    std::ifstream vibratorEffectPlay(kVibratorEffectPlayPath);
    if (!vibratorEffectPlay) {
        LOG(ERROR) << "Failed to open " << kVibratorEffectPlayPath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
    }

    sp<IVibrator> vibrator = new Vibrator(
            std::move(vibratorState),
            std::move(vibratorDuration),
            std::move(vibratorActivate),
            std::move(vibratorEffectName),
            std::move(vibratorEffectPlay));

    return vibrator->registerAsService();
}

int main() {
    configureRpcThreadpool(1, true);
    status_t status = registerVibratorService();

    if (status != OK) {
        return status;
    }

    joinRpcThreadpool();

    return 1;
}
