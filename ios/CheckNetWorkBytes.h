//
//  Speed.h
//  DeviceInfo
//
//  Created by Thea on 2020-10-01.
//

#ifndef Speed_h
#define Speed_h

#import <Foundation/Foundation.h>

@interface NSObject (CheckNetWorkBytes)
+ (void )initCheck;
+ (long long )getNetWorkBytesPerSecond;
+ (long long )getGprsWifiFlowIOBytes;
+ (NSString *)convertStringWithbyte:(long)bytes;
@end

#endif /* Speed_h */
