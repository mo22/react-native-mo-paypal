package de.mxs.reactnativemopaypal;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.Collections;
import java.util.List;

import javax.annotation.Nonnull;

@SuppressWarnings("unused")
public final class ReactNativeMoPayPalPackage implements ReactPackage {

    @Override
    public @Nonnull List<ViewManager> createViewManagers(@Nonnull ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }

    @Override
    public @Nonnull List<NativeModule> createNativeModules(@Nonnull ReactApplicationContext reactContext) {
        return Collections.singletonList(new ReactNativeMoPayPal(reactContext));
    }

}
