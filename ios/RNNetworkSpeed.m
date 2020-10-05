#import "RNNetworkSpeed.h"
#import "./NSObject+CheckNetWorkBytes.h"
@implementation RNNetworkSpeed {
    NSTimer *timer;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE();

#pragma mark - react方法

RCT_EXPORT_METHOD(findEvents:(RCTResponseSenderBlock)callback) {
    NSArray *events = @[@1, @"test"];
    callback(@[[NSNull null], events]);
};

RCT_EXPORT_METHOD(startListenNetworkSpeed) {
    if(timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getNetworkTraffic) userInfo:nil repeats:true];
        [NSObject initCheck];
        [timer fireDate];
    }
}

RCT_EXPORT_METHOD(stopListenNetworkSpeed) {
    if(timer) {
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark 
- (void)getNetworkTraffic {
    NSDictionary *netWorkSpeed = [NSObject getNetworkSpeed]; //get current network speed
    [self sendEventWithName:@"onSpeedUpdate" body:netWorkSpeed];
    NSLog(@"ownLoadSpeed@",[netWorkSpeed valueForKey: @"downLoadSpeed"]);
    NSLog(@"upLoadSpeed%@",[netWorkSpeed valueForKey: @"upLoadSpeed"]);
}


#pragma mark 
- (NSArray<NSString *> *)supportedEvents {
    return @[@"onSpeedUpdate"];
}

static NSDictionary *getNetworkTraffic() {
  NSDictionary *netWorkSpeed = [NSObject getNetworkSpeed];
  NSDictionary *dict =@{@"download speed": [netWorkSpeed valueForKey: @"downLoadSpeed"],
                        @"upload speed": [netWorkSpeed valueForKey: @"upLoadSpeed"],
                      };
  
  return dict;
  
}
RCT_EXPORT_METHOD(getNetworkTraffic:(RCTResponseSenderBlock)callback) {
    callback(@[[NSNull null], getNetworkTraffic()]);
}
@end
  
