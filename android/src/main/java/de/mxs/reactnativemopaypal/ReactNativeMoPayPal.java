package de.mxs.reactnativemopaypal;

import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.paypal.checkout.PayPalCheckout;
import com.paypal.checkout.config.CheckoutConfig;
import com.paypal.checkout.config.Environment;
import com.paypal.checkout.createorder.CurrencyCode;
import com.paypal.checkout.createorder.OrderIntent;
import com.paypal.checkout.order.Amount;
import com.paypal.checkout.order.Order;
import com.paypal.checkout.order.PurchaseUnit;

import java.util.Arrays;
import java.util.Objects;

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

    @SuppressWarnings("unused")
    @ReactMethod
    public void test(ReadableMap args, Promise promise) {
        Log.i("PayPal", "start");
        Log.i("PayPal", "args=" + args);

        PayPalCheckout.setConfig(
            new CheckoutConfig(
                Objects.requireNonNull(getReactApplicationContext().getCurrentActivity()).getApplication(),
                Objects.requireNonNull(args.getString("clientID")),
                Environment.valueOf(Objects.requireNonNull(args.getString("environment")).toUpperCase()),
                getReactApplicationContext().getPackageName() + "://paypalpay"
            )
        );

        PurchaseUnit purchaseUnit = new PurchaseUnit.Builder()
            .amount(
                new Amount.Builder()
                    .currencyCode(CurrencyCode.EUR)
                    .value("1.22")
                    .build()
            )
//            .customId("custom-id")
//            .invoiceId("invoice-id")
            .build();

        Order order = new Order.Builder()
            .intent(OrderIntent.AUTHORIZE)
            .purchaseUnitList(Arrays.asList(purchaseUnit))
            .build();

        Log.i("PayPal", "order=" + order);

        PayPalCheckout.registerCallbacks(
            approval -> {
                Log.i("PayPal", "onApprove " + approval);
            },
            null,
            () -> {
                Log.i("PayPal", "onCancel");
            },
            errorInfo -> {
                Log.i("PayPal", "onError " + errorInfo);
            }
        );

        Log.i("PayPal", "startCheckout");
        PayPalCheckout.startCheckout(createOrderActions -> {
            Log.i("PayPal", "create " + createOrderActions);
            createOrderActions.create(order, s -> {
                Log.i("PayPal", "onCreated " + s);
            });
        });


//        val createOrderRequest =
//            CreateOrderRequest(
//                orderIntent = selectedOrderIntent,
//                userAction = selectedUserAction,
//                shippingPreference = selectedShippingPreference,
//                currencyCode = currencyCode,
//                createdItems = createdItems
//            )
//        val order = createOrderUseCase.execute(createOrderRequest)

//        PayPalCheckout.startCheckout(...)
//        const val PAYPAL_CLIENT_ID = "YOUR-CLIENT-ID-HERE"
//        const val PAYPAL_SECRET = "ONLY-FOR-QUICKSTART-DO-NOT-INCLUDE-SECRET-IN-CLIENT-SIDE-APPLICATIONS"
//        com.paypal.checkoutsamples://paypalpay
    }

}
