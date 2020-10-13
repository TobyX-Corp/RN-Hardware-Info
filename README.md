# RN-Hardware-Info


## For Android

### Getting started
`- Add the following dependency to package.json:
  "rn-hardware-info": "TobyX-Corp/RN-Hardware-Info#master"`
  
 `- Run "npm install" in the project directory`

### Mostly automatic installation(autolinking from RN 0.60 and later versions)

`$ react-native link rn-hardware-info`

### Check and Request Permissions

#### Cellar Usage Permission
One option is to:
  Use PermissionsAndroid as instructed on https://reactnative.dev/docs/permissionsandroid

#### Wifi Usage Permission
```javascript
MainView.checkWifiUsagePermission((request_cb) => {
  #TODO
})
```

### How to use
```javascript
import RnHardwareInfo from 'rn-hardware-info';

// get cpu frequency
MainView.getDeviceCpuFreqNow((cpu_cb) => {
  #TODO
})
// get ram usage
MainView.getDeviceMemInfo((ram_cb) => {
  #TODO
})
// get battery temperature
MainView.getBatteryTemperature((temp_cb) => {
  #TODO
})
// get network stats
MainView.getNetworkStats((down_cb, up_cb) => {
  #TODO
})
```


## For IOS

### Getting started
`- Add the following dependency to package.json:
  "rn-hardware-info": "TobyX-Corp/RN-Hardware-Info#master"`
  
 `- Run "npm install" in the project directory`
 
 `- Run "pod install" in the ios directory`

### Mostly automatic installation(autolinking from RN 0.60)

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
