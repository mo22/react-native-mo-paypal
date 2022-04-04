package de.mxs.reactnativemopaypal;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nonnull;

public class ReactNativeMoPayPal extends ReactContextBaseJavaModule {

    ReactNativeMoPayPal(@Nonnull ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public @Nonnull
    String getName() {
        return "ReactNativeMoPayPal";
    }

}
