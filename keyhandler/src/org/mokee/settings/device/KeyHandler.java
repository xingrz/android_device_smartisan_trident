/*
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

package org.mokee.settings.device;

import android.content.Context;
import android.hardware.input.InputManager;
import android.os.Handler;
import android.os.Looper;
import android.os.PowerManager;
import android.os.RemoteException;
import android.os.SystemClock;
import android.util.Log;
import android.view.InputDevice;
import android.view.KeyCharacterMap;
import android.view.KeyEvent;
import android.view.ViewConfiguration;
import android.view.WindowManager;
import android.view.WindowManagerGlobal;

import com.android.internal.os.DeviceKeyHandler;

import mokee.providers.MKSettings;

import org.mokee.internal.util.FileUtils;

public class KeyHandler implements DeviceKeyHandler {

    private static final String TAG = "KeyHandler";

    private static final int KEY_POWER = 0;
    private static final int KEY_SHORTCUTS = 1;

    private final int longPressTimeout = ViewConfiguration.getLongPressTimeout();

    private final KeyInfo[] keys = new KeyInfo[] {
        new KeyInfo("power", "qpnp_pon"),
        new KeyInfo("shortcuts", "gpio-keys"),
    };

    private Context context;
    private PowerManager pm;

    private boolean shortcutsKeyPressed = false;
    private boolean powerKeyPressed = false;

    private Handler handler = new Handler(Looper.getMainLooper());

    private final Runnable triggerPartialScreenshot = new Runnable() {
        @Override
        public void run() {
            if (shortcutsKeyPressed && powerKeyPressed) {
                takeScreenshot(true);
                injectKey(keys[KEY_SHORTCUTS].keyCode, KeyEvent.ACTION_UP, KeyEvent.FLAG_CANCELED);
                injectKey(keys[KEY_POWER].keyCode, KeyEvent.ACTION_UP, KeyEvent.FLAG_CANCELED);
                shortcutsKeyPressed = false;
                powerKeyPressed = false;
            }
        }
    };

    public KeyHandler(Context context) {
        this.context = context;
        this.pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
    }

    public KeyEvent handleKeyEvent(KeyEvent event) {
        boolean handled = false;
        handled = handleShortcutsKeyEvent(event) || handled;
        handled = handlePowerKeyEvent(event) || handled;
        return handled ? null : event;
    }

    private boolean handleShortcutsKeyEvent(KeyEvent event) {
        final KeyInfo keyShortcuts = keys[KEY_SHORTCUTS];

        if (!keyShortcuts.match(event)) {
            return false;
        }

        switch (event.getAction()) {
            case KeyEvent.ACTION_DOWN:
                if (powerKeyPressed) {
                    injectKey(keys[KEY_POWER].keyCode, KeyEvent.ACTION_UP, KeyEvent.FLAG_CANCELED);
                    handler.postDelayed(triggerPartialScreenshot, longPressTimeout);
                } else {
                    injectKey(keyShortcuts.keyCode, KeyEvent.ACTION_DOWN, 0);
                }
                if (pm.isInteractive()) {
                    shortcutsKeyPressed = true;
                }
                break;
            case KeyEvent.ACTION_UP:
                if (powerKeyPressed) {
                    takeScreenshot(false);
                    powerKeyPressed = false;
                } else {
                    injectKey(keyShortcuts.keyCode, KeyEvent.ACTION_UP, 0);
                }
                handler.removeCallbacks(triggerPartialScreenshot);
                shortcutsKeyPressed = false;
                break;
        }

        return true;
    }

    private boolean handlePowerKeyEvent(KeyEvent event) {
        final KeyInfo keyPower = keys[KEY_POWER];

        if (!keyPower.match(event)) {
            return false;
        }

        switch (event.getAction()) {
            case KeyEvent.ACTION_DOWN:
                if (shortcutsKeyPressed) {
                    injectKey(keys[KEY_SHORTCUTS].keyCode, KeyEvent.ACTION_UP, KeyEvent.FLAG_CANCELED);
                    handler.postDelayed(triggerPartialScreenshot, longPressTimeout);
                } else {
                    injectKey(keyPower.keyCode, KeyEvent.ACTION_DOWN, 0);
                }
                if (pm.isInteractive()) {
                    powerKeyPressed = true;
                }
                break;
            case KeyEvent.ACTION_UP:
                if (shortcutsKeyPressed) {
                    takeScreenshot(false);
                    shortcutsKeyPressed = false;
                } else {
                    injectKey(keyPower.keyCode, KeyEvent.ACTION_UP, 0);
                }
                handler.removeCallbacks(triggerPartialScreenshot);
                powerKeyPressed = false;
                break;
        }

        return true;
    }

    private String getDeviceName(KeyEvent event) {
        final int deviceId = event.getDeviceId();
        final InputDevice device = InputDevice.getDevice(deviceId);
        return device == null ? null : device.getName();
    }

    private void injectKey(int code, int action, int flags) {
        final long now = SystemClock.uptimeMillis();
        InputManager.getInstance().injectInputEvent(new KeyEvent(
                        now, now, action, code, 0, 0,
                        KeyCharacterMap.VIRTUAL_KEYBOARD,
                        0, flags,
                        InputDevice.SOURCE_KEYBOARD),
                InputManager.INJECT_INPUT_EVENT_MODE_ASYNC);
    }

    private void takeScreenshot(final boolean partial) {
        final int type = partial
                ? WindowManager.TAKE_SCREENSHOT_SELECTED_REGION
                : WindowManager.TAKE_SCREENSHOT_FULLSCREEN;

        try {
            WindowManagerGlobal.getWindowManagerService().mokeeTakeScreenshot(type);
        } catch (RemoteException e) {
            Log.e(TAG, "Error while trying to takeScreenshot.", e);
        }
    }

    private class KeyInfo {

        final String file;
        final String deviceName;
        final int scanCode;
        int deviceId;
        int keyCode;

        KeyInfo(String file, String deviceName) {
            int scanCode;
            this.file = "/proc/keypad/" + file;
            this.deviceName = deviceName;
            try {
                scanCode = Integer.parseInt(FileUtils.readOneLine(this.file));
            } catch (NumberFormatException ignored) {
                scanCode = 0;
            }
            this.scanCode = scanCode;
        }

        boolean match(KeyEvent event) {
            if (deviceId == 0) {
                final String deviceName = getDeviceName(event);
                if (this.deviceName.equals(deviceName)) {
                    deviceId = event.getDeviceId();
                } else {
                    return false;
                }
            } else {
                if (deviceId != event.getDeviceId()) {
                    return false;
                }
            }

            if (event.getScanCode() == scanCode) {
                keyCode = event.getKeyCode();
            } else {
                return false;
            }

            return true;
        }

    }

}
