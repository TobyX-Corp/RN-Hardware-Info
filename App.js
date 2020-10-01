import React, {Component} from 'react';
import {StyleSheet, Text, View, NativeModules} from 'react-native';
import networkSpeed from './NetworkSpeed.js';
// start
networkSpeed.startListenNetworkSpeed(
  ({downLoadSpeed, downLoadSpeedCurrent, upLoadSpeed, upLoadSpeedCurrent}) => {
    console.log(downLoadSpeed + 'kb/s'); // download speed for the entire device 整个设备的下载速度
    console.log(downLoadSpeedCurrent + 'kb/s'); // download speed for the current app 当前app的下载速度(currently can only be used on Android)
    console.log(upLoadSpeed + 'kb/s'); // upload speed for the entire device 整个设备的上传速度
    console.log(upLoadSpeedCurrent + 'kb/s'); // upload speed for the current app 当前app的上传速度(currently can only be used on Android)
  },
);
// stop
networkSpeed.stopListenNetworkSpeed();

let Device = NativeModules.Device;
Device.printAction();
Device.getAppCpuUsage((error, usage) => {
  if (error) {
    console.log(error);
  } else {
    console.log('get app usage');
    console.log(usage);
  }
});

export default class App extends Component {
  render() {
    return <View style={{padding: 10}} />;
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
