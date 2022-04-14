#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@import PayPalCheckout;


PPCPurchaseUnitAmount* PPCPurchaseUnitAmountFromDictionary(NSDictionary* _Nonnull rs) {
    // @TODO: remaining fields, currency
    return [[PPCPurchaseUnitAmount alloc]
      initWithCurrencyCode:PPCCurrencyCodeEur
      value:[rs[@"value"] stringValue]
      breakdown:nil
    ];
}

PPCPurchaseUnit* PPCPurchaseUnitFromDictionary(NSDictionary* _Nonnull rs) {
    // @TODO: remaining fields
    NSLog(@"test [%@]", [rs[@"referenceId"] stringValue]);
    return [[PPCPurchaseUnit alloc]
        initWithAmount:PPCPurchaseUnitAmountFromDictionary(rs[@"amount"])
        referenceId:nil // string
        payee:nil // PPCPurchaseUnitPayee
        paymentInstruction:nil // PPCPurchaseUnitPaymentInstruction
        purchaseUnitDescription:nil // string
        customId:nil // string
        invoiceId:nil // string
        softDescriptor:nil // string
        items:nil // (NSArray<PPCPurchaseUnitItem *> * _Nullable)
        shipping:nil // PPCPurchaseUnitShipping
    ];
}

PPCOrderRequest* PPCOrderRequestFromDictionary(NSDictionary* _Nonnull rs) {
    NSMutableArray<PPCPurchaseUnit*>* purchaseUnits = [NSMutableArray new];
    for (NSDictionary* tmp in rs[@"purchaseUnits"]) {
        [purchaseUnits addObject:PPCPurchaseUnitFromDictionary(tmp)];
    }
    // @TODO: fields
    return [[PPCOrderRequest alloc]
        initWithIntent:PPCOrderIntentCapture // PPCOrderIntentCapture, PPCOrderIntentAuthorize
        purchaseUnits:purchaseUnits
        processingInstruction:PPCOrderProcessingInstructionNone
        payer:nil
        applicationContext:nil
    ];
}

PPCEnvironment PPCEnvironmentFromString(NSString* _Nonnull str) {
    NSDictionary* values = @{
        @"live": @(PPCEnvironmentLive),
        @"sandbox": @(PPCEnvironmentSandbox),
        @"stage": @(PPCEnvironmentStage),
    };
    return [values[str] intValue];
}

// RCTEventEmitter ?

@interface ReactNativeMoPayPal : NSObject <RCTBridgeModule>

@end

@implementation ReactNativeMoPayPal

RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (NSArray<NSString*>*)supportedEvents {
    return @[ ];
}

RCT_EXPORT_METHOD(test:(NSDictionary*)args resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    NSLog(@"paypal test");
   
    NSLog(@"args %@", args);
    
    NSString* returnUrl = [NSString stringWithFormat:@"%@://paypalpay", [[NSBundle mainBundle] bundleIdentifier]];
    // @TODO: do we handle this?
    
    PPCheckoutConfig* config = [[PPCheckoutConfig alloc]
        initWithClientID:[args[@"clientID"] stringValue]
        returnUrl:returnUrl
        createOrder:nil
        onApprove:nil
        onShippingChange:nil
        onCancel:nil
        onError:^(PPCErrorInfo * _Nonnull error) {
            // @TODO reject?
            NSLog(@"PPCheckoutConfig onError %@", error);
        }
        environment:PPCEnvironmentFromString(args[@"environment"])
    ];
    [PPCheckout setConfig:config];

    UIViewController* currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [PPCheckout
        startWithPresentingViewController:currentViewController
        createOrder:^(PPCCreateOrderAction * _Nonnull createOrderAction) {
            PPCOrderRequest* orderRequest = PPCOrderRequestFromDictionary(args[@"orderRequest"]);
            NSLog(@"orderRequest %@", orderRequest);

            [createOrderAction
                createWithOrder:orderRequest
                completion:^(NSString * _Nullable arg2) {
                    NSLog(@"completion %@", arg2);
                    // @TODO: resolve?
                }
            ];

        }
        onApprove:^(PPCApproval * _Nonnull arg) {
            // called.
            NSLog(@"onApprove %@", arg);
            NSLog(@"onApprove data %@", arg.data);
            resolve(@{
                @"result": @"approved",
                @"t1": arg.data.payerID,
                @"t2": arg.data.ecToken,
                @"t3": arg.data.paymentID,
            });
        }
        onShippingChange:nil
        onCancel:^{
            // called.
            NSLog(@"onCancel");
            resolve(@{
                @"result": @"cancelled",
            });
        }
        onError:^(PPCErrorInfo * _Nonnull error) {
            NSLog(@"onError %@", error);
            resolve(@{
            @"result": @"error",
            @"reason": error.reason,
            @"error": error.error.description,
            });
        }
    ];
}

@end
