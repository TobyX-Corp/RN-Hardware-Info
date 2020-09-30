#import <Foundation/Foundation.h>

#define __kCFAllocatorGCObjectMemory 0x400      /* GC:  memory needs to be finalized. */

#define kUIDeviceListenerNewDataNotification @"UIDeviceListenerNewDataNotification"

@interface UIDeviceListener : NSObject
{
    NSThread *listenerThread;
    
    Class dictionaryClass;
}

+ (instancetype) sharedUIDeviceListener;

- (void) startListener;
- (void) stopListener;

@end
