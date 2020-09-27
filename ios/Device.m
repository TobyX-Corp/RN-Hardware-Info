#import "Device.h"
#import <React/RCTLog.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <assert.h>

@implementation Device

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(printAction) {
  RCTLogInfo(@"This is my test module!");
}

static NSDictionary *appCpuUsage(){
  kern_return_t kr;
  task_info_data_t tinfo;
  mach_msg_type_number_t task_info_count;
  task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return NULL;
    }
    
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return NULL;
    }
    
    long total_time     = 0;
    long total_userTime = 0;
    CGFloat total_cpu   = 0;
    int j;
    
    // for each thread
    static NSUInteger const kMaxPercent = 100;
    for (j = 0; j < (int)thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return NULL;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            total_time     = total_time + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            total_userTime = total_userTime + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            total_cpu      = total_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE *kMaxPercent;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return @{@"total_cpu": @(total_cpu)
           };
}
 
RCT_EXPORT_METHOD(getAppCpuUsage:(RCTResponseSenderBlock)callback) {
    callback(@[[NSNull null], appCpuUsage()]);
}

@end
