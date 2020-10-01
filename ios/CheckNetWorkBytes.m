//
//  CheckNetWorkBytes.m
//  DeviceInfo
//
//  Created by Thea on 2020-10-01.
//

#import <Foundation/Foundation.h>
#import "CheckNetWorkBytes.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>

//1秒一次太过于频繁
static NSUInteger const kOYNetSpeedToolTimeInterval = 2;

@interface CheckNetWorkBytes()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign, getter=isFirstTime) BOOL firstTime;
@property (nonatomic, assign) unsigned long long reData;
@property (nonatomic, assign) unsigned long long lastReData;
@property (nonatomic, assign) unsigned long long seData;
@property (nonatomic, assign) unsigned long long lastSeData;
@end


uint64_t _lastBytes_CheckNetWorkBytes;
@implementation NSObject (CheckNetWorkBytes)
+(instancetype)shareTool{
    static dispatch_once_t onceToken;
    static CheckNetWorkBytes *tool;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
        tool.firstTime = YES;
    });
    return tool;
}

- (void)startMonitor{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kOYNetSpeedToolTimeInterval target:self selector:@selector(getCurrentSpeed) userInfo:nil repeats:YES];
}
- (void)stopMonitor{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)getCurrentSpeed{
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs) == 0) {
        while (addrs != NULL) {
            struct if_data *ifa_data = (struct if_data*)addrs->ifa_data;
            if(ifa_data){
                self.reData += ifa_data->ifi_ibytes;
                self.seData += ifa_data->ifi_obytes;
            }
            addrs = addrs->ifa_next;
        }
    }
    freeifaddrs(addrs);
    
    if (!self.isFirstTime) {
        if ([self.delegate respondsToSelector:@selector(onUpdateNetReceiveSpeed:)]) {
            [self.delegate onUpdateNetReceiveSpeed:(self.reData - self.lastReData)/kOYNetSpeedToolTimeInterval];
        }
        if ([self.delegate respondsToSelector:@selector(onUpdateNetSendSpeed:)]) {
            [self.delegate onUpdateNetSendSpeed:(self.seData - self.lastSeData)/kOYNetSpeedToolTimeInterval];
        }
    }else{
        self.firstTime = NO;
    }
    self.lastReData = self.reData;
    self.lastSeData = self.seData;
    self.reData = 0;
    self.seData = 0;
    

}


@end
