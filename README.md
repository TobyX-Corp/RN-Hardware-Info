# RN-Hardware-Info

# For Android

## Getting started
`- Add the following dependency to package.json:
  "rn-hardware-info": "TobyX-Corp/RN-Hardware-Info#master"`
  
 `- Run "npm install" in the project directory`

### Mostly automatic installation

`$ react-native link rn-hardware-info`

## How to use
```javascript
import RnHardwareInfo from 'rn-hardware-info';

// TODO: What to do with the module?
RnHardwareInfo;
```

# For IOS

## Getting started
`- Add the following dependency to package.json:
  "rn-hardware-info": "TobyX-Corp/RN-Hardware-Info#master"`
  
 `- Run "npm install" in the project directory`
 
 `- Run "pod install" in the ios directory`

### Mostly automatic installation

`$ react-native link rn-hardware-info`

## How to use
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
