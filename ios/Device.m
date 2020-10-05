#import "Device.h"
#import <React/RCTLog.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/task_info.h>
#import <assert.h>
#import "NetworkInfo.h"

@implementation Device

RCT_EXPORT_MODULE();

static NSDictionary *appUsage(){
  //cpu uage
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
    CGFloat used_memory = 0;
    CGFloat available_memory = 0;
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
    
    //available memory
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;

    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);

    if (kernReturn != KERN_SUCCESS) {
      return NULL;
    }
    
    //used memory
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount2 = TASK_BASIC_INFO_COUNT;

    kern_return_t kernReturn2 = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount2);

    if (kernReturn2 != KERN_SUCCESS) {
      return NULL;
    }
    
    used_memory = taskInfo.resident_size / 1024.0 / 1024.0;
    available_memory = ((vm_page_size *vmStats.free_count) /1024.0) / 1024.0;
    
    //network usage
    NSDictionary *netWorkSpeed = [NSObject getNetworkSpeed];
  
    NSDictionary *dict =@{@"cpu_usage": @(total_cpu),
                        @"memory_usage": @(used_memory / (used_memory + available_memory) * 100),
                        @"download_speed": [netWorkSpeed valueForKey: @"downLoadSpeed"],
                        @"upload_speed": [netWorkSpeed valueForKey: @"upLoadSpeed"]
                      };
  return dict;
}

RCT_EXPORT_METHOD(getAppUsage:(RCTResponseSenderBlock)callback) {
    callback(@[[NSNull null], appUsage()]);
}

@end
