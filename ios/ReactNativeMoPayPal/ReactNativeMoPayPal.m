#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@import PayPalCheckout;

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

RCT_EXPORT_METHOD(testPayPal:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  NSLog(@"testPayPal");

  // @TODO: check client id ?
  // @TODO: arguments object
  // @TODO: need to setup config in appdelegate maybe?
  // @TODO:

  PPCheckoutConfig* config = [[PPCheckoutConfig alloc]
    initWithClientID:@"todo..." // sandbox client_id
    returnUrl:@"own-budnle-id://paypalpay"
    createOrder:nil
    onApprove:nil
    onShippingChange:nil
    onCancel:nil
    onError:^(PPCErrorInfo * _Nonnull error) {
      NSLog(@"onError %@", error);
    }
    environment:PPCEnvironmentSandbox
  ];

  [PPCheckout setConfig:config];

  UIViewController* currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

  [PPCheckout
    startWithPresentingViewController:currentViewController
    createOrder:^(PPCCreateOrderAction * _Nonnull arg) {
      PPCPurchaseUnitAmount* purchaseUnitAmount = [[PPCPurchaseUnitAmount alloc]
        initWithCurrencyCode:PPCCurrencyCodeEur
        value:@"1.11"
        breakdown:nil
      ];
      PPCPurchaseUnit* purchaseUnit = [[PPCPurchaseUnit alloc]
        initWithAmount:purchaseUnitAmount
        referenceId:nil
        payee:nil
        paymentInstruction:nil
        purchaseUnitDescription:nil
        customId:nil
        invoiceId:nil
        softDescriptor:nil
        items:nil // (NSArray<PPCPurchaseUnitItem *> * _Nullable)
        shipping:nil
      ];
      PPCOrderRequest* orderRequest = [[PPCOrderRequest alloc]
        initWithIntent:PPCOrderIntentCapture
        purchaseUnits:@[purchaseUnit]
        processingInstruction:PPCOrderProcessingInstructionNone
        payer:nil
        applicationContext:nil
      ];
      NSLog(@"orderRequest %@", orderRequest);
      [arg
        createWithOrder:orderRequest
        completion:^(NSString * _Nullable arg2) {
          NSLog(@"completion %@", arg);
        }
      ];
    }
    onApprove:^(PPCApproval * _Nonnull arg) {
      // called.
      NSLog(@"onApprove %@", arg);
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
