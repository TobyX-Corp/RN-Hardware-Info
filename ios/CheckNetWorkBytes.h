//
//  Speed.h
//  DeviceInfo
//
//  Created by Thea on 2020-10-01.
//

#ifndef Speed_h
#define Speed_h

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol OYNetSpeedToolDelegate <NSObject>
@optional
- (void)onUpdateNetReceiveSpeed:(unsigned long long)speed;
- (void)onUpdateNetSendSpeed:(unsigned long long)speed;
@end

@interface CheckNetWorkBytes : NSObject
@property (nonatomic, weak) id<OYNetSpeedToolDelegate> delegate;
+ (instancetype)shareTool;
- (void)startMonitor;
- (void)stopMonitor;
@end

NS_ASSUME_NONNULL_END
