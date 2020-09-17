#import "Test.h"
#import <React/RCTLog.h>

@implementation Test

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
  RCTLogInfo(@"Hello World %@ at %@", name, location);
}

@end