#import "Device.h"
#import <React/RCTLog.h>

@implementation Device

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(printAction) {
  RCTLogInfo(@"This is my test module!");
}

@end
