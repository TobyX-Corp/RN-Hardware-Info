import React, {Component} from 'react';
import {StyleSheet, Text, View, NativeModules} from 'react-native';

let Device = NativeModules.Device;
let RNNetworkSpeed = NativeModules.RNNetworkSpeed;
let defualtCallback = null
let eventEmitter = null

Device.printAction();
console.log('test');
Device.getAppCpuUsage((error, usage) => {
  if (error) {
    console.log(error);
  } else {
    console.log('get app usage');
    console.log(usage);
  }
});

RNNetworkSpeed.getNetworkTraffic((error, speed) => {
  if (error) {
    console.log(error);
  } else {
    console.log('get app speed');
    console.log(speed);
  }
});

console.log('test');
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
