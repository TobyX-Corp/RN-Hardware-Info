#import <sys/sysctl.h>
#import <mach/mach.h>
#import <assert.h>

+ (CGFloat)appCpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    long total_time     = 0;
    long total_userTime = 0;
    CGFloat total_cpu   = 0;
    int j;
    
    // for each thread
    for (j = 0; j < (int)thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            total_time     = total_time + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            total_userTime = total_userTime + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            total_cpu      = total_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * kMaxPercent;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return total_cpu;
}

- (double)availableMemory {
  vm_statistics_data_t vmStats;
  mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;

  kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);

  if (kernReturn != KERN_SUCCESS) {
    return NSNotFound;
    }
  
  return ((vm_page_size *vmStats.free_count) /1024.0) / 1024.0;
}

- (double)usedMemory {
  task_basic_info_data_t taskInfo;
  mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;

  kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);

  if (kernReturn != KERN_SUCCESS) {
    return NSNotFound;
    }
  
  return taskInfo.resident_size / 1024.0 / 1024.0;
}

int64_t getUsedMemory()
{
    size_t length = 0;
    int mib[6] = {0};
    
    int pagesize = 0;
    mib[0] = CTL_HW;
    mib[1] = HW_PAGESIZE;
    length = sizeof(pagesize);
    if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
    {
        return 0;
    }
    
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    
    vm_statistics_data_t vmstat;
    
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
    {
		return 0;
    }
    
    int wireMem = vmstat.wire_count * pagesize;
    int activeMem = vmstat.active_count * pagesize;
    return wireMem + activeMem;
}