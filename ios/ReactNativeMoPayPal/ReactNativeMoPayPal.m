#import <React/RCTBridgeModule.h>

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

@end
