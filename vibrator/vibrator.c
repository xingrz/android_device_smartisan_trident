/*
 * Copyright (C) 2013 The Android Open Source Project
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

#include <hardware/hardware.h>
#include <hardware/vibrator.h>

#include <errno.h>
#include <fcntl.h>
#include <malloc.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <log/log.h>

#define TIMEOUT_STR_LEN         20

static int write_value(const char *file, const char *value)
{
    int to_write, written, ret, fd;

    fd = TEMP_FAILURE_RETRY(open(file, O_WRONLY));
    if (fd < 0) {
        return -errno;
    }

    to_write = strlen(value) + 1;
    written = TEMP_FAILURE_RETRY(write(fd, value, to_write));
    if (written == -1) {
        ret = -errno;
    } else if (written != to_write) {
        /* even though EAGAIN is an errno value that could be set
           by write() in some cases, none of them apply here.  So, this return
           value can be clearly identified when debugging and suggests the
           caller that it may try to call vibrator_on() again */
        ret = -EAGAIN;
    } else {
        ret = 0;
    }

    errno = 0;
    close(fd);

    return ret;
}

static const char LED_DEVICE[] = "/sys/class/haptic/vibrator";

static int write_led_file(const char *file, const char *value)
{
    char file_str[50];

    snprintf(file_str, sizeof(file_str), "%s/%s", LED_DEVICE, file);
    return write_value(file_str, value);
}

static int vibra_led_on(vibrator_device_t* vibradev __unused, unsigned int timeout_ms)
{
    int ret;
    char value[TIMEOUT_STR_LEN]; /* large enough for millions of years */

    ret = write_led_file("state", "1");
    if (ret)
        return ret;

    snprintf(value, sizeof(value), "%u\n", timeout_ms);
    ret = write_led_file("duration", value);
    if (ret)
        return ret;

    return write_led_file("activate", "1");
}

static int vibra_led_off(vibrator_device_t* vibradev __unused)
{
    return write_led_file("activate", "0");
}

static int vibra_close(hw_device_t *device)
{
    free(device);
    return 0;
}

static int vibra_open(const hw_module_t* module, const char* id __unused,
                      hw_device_t** device __unused) {
    vibrator_device_t *vibradev = calloc(1, sizeof(vibrator_device_t));

    if (!vibradev) {
        ALOGE("Can not allocate memory for the vibrator device");
        return -ENOMEM;
    }

    vibradev->common.tag = HARDWARE_DEVICE_TAG;
    vibradev->common.module = (hw_module_t *) module;
    vibradev->common.version = HARDWARE_DEVICE_API_VERSION(1,0);
    vibradev->common.close = vibra_close;

    vibradev->vibrator_on = vibra_led_on;
    vibradev->vibrator_off = vibra_led_off;

    *device = (hw_device_t *) vibradev;

    return 0;
}

/*===========================================================================*/
/* trident vibrator HW module interface definition                           */
/*===========================================================================*/

static struct hw_module_methods_t vibrator_module_methods = {
    .open = vibra_open,
};

struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .module_api_version = VIBRATOR_API_VERSION,
    .hal_api_version = HARDWARE_HAL_API_VERSION,
    .id = VIBRATOR_HARDWARE_MODULE_ID,
    .name = "trident vibrator HAL",
    .author = "The MoKee Open Source Project",
    .methods = &vibrator_module_methods,
};
