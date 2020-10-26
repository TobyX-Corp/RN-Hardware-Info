# RN-Hardware-Info


## For Android

### Installation
  
- Run `npm i rn-hardware-info` in the project directory

Mostly automatic installation(autolinking from RN 0.60 and later versions)

`$ react-native link rn-hardware-info`

### How to use
```javascript
import RnHardwareInfo from 'rn-hardware-info';
```
### Check and Request Permissions:

Wifi Usage Permission:
```javascript
MainView.checkWifiUsagePermission((permsn_cb) => {
  #your code on how to use permsn_cb
})
```
### Getting Data
```javascript
// get cpu frequency
RnHardwareInfo.getDeviceCpuFreqNow((cpu_cb) => {
  #your code on how to use cpu_cb
})
// get ram usage
RnHardwareInfo.getDeviceMemInfo((ram_cb) => {
  #your code on how to use ram_cb
})
// get battery temperature
RnHardwareInfo.getBatteryTemperature((temp_cb) => {
  #your code on how to use temp_cb
})
// get network stats
RnHardwareInfo.getNetworkStats((down_cb, up_cb) => {
  #your code on how to use down_cb and up_cb
})
```




## For IOS

### Installation
  
- Run `npm i rn-hardware-info` in the project directory
 
- Run  `pod install` in the ios directory

Mostly automatic installation(autolinking from RN 0.60)

`$ react-native link rn-hardware-info`

### How to use
```javascript
RnHardwareInfo.getAppUsage((error, usage) => {
  if (error) {
    console.log(error);
  } else {
    console.log(usage.cpu_usage);
    console.log(usage.memory_usage);
    console.log(usage.download_speed);
    console.log(usage.upload_speed);
  }
});
```
### Example
```javascript
import React, {useState, useEffect} from 'react';
import RnHardwareInfo from 'rn-hardware-info';

//Display hardware info eg. cpu
const DeviceInfo = () => {
  const [cpu, setCpu] = useState('0');

  useEffect(() => {
    const interval = setInterval(() => {
      if (RnHardwareInfo != null) {
        RnHardwareInfo.getAppUsage((error, usage) => {
          if (error) {
            console.log(error);
          } else {
            console.log('get app usage');
            console.log(usage);
            setCpu(usage.cpu_usage);
          }
        });
      }
    }, 1000);
    return () => clearInterval(interval);
  }, []);
  
  return (
    <View style={styles.container}>
      <Text> CPU Usage: {cpu}%</Text>
    </View>
  );
};
```
