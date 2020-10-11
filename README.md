# RN-Hardware-Info


## For Android

### Getting started
`- Add the following dependency to package.json:
  "rn-hardware-info": "TobyX-Corp/RN-Hardware-Info#master"`
  
 `- Run "npm install" in the project directory`

### Mostly automatic installation

`$ react-native link rn-hardware-info`

### How to use
```javascript
import RnHardwareInfo from 'rn-hardware-info';

// get cpu frequency
RnHardwareInfo.getDeviceCpuFreqNow(freq_callback);
// get ram usage
RnHardwareInfo.getDeviceMemInfo(ram_callback);
// get battery temperature
RnHardwareInfo.getBatteryTemperature(temp_callback);
// get network stats
RnHardwareInfo.getNetworkStats(down_callback, up_callback);
```


## For IOS

### Getting started
`- Add the following dependency to package.json:
  "rn-hardware-info": "TobyX-Corp/RN-Hardware-Info#master"`
  
 `- Run "npm install" in the project directory`
 
 `- Run "pod install" in the ios directory`

### Mostly automatic installation

`$ react-native link rn-hardware-info`

### How to use
```javascript
import RnHardwareInfo from 'rn-hardware-info';

//Display hardware info
RnHardwareInfo.getAppUsage((error, usage) => {
  if (error) {
    console.log(error);
  } else {
    console.log(usage);
    console.log(usage.cpu_usage);
    console.log(usage.memory_usage);
    console.log(usage.download_speed);
    console.log(usage.upload_speed);
  }
});
```
