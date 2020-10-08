import React, {Component} from 'react';
import DeviceInfo from './DeviceInfo';
import {View, NativeModules} from 'react-native';

export default class App extends Component {
  // componentDidMount() {
  //   this._interval = setInterval(() => {
  //     let Device = NativeModules.Device;
  //     Device.getAppUsage((error, usage) => {
  //       if (error) {
  //         console.log(error);
  //       } else {
  //         console.log('get app usage');
  //         console.log(usage);
  //       }
  //     });
  //   }, 5000);
  // }

  // componentWillUnmount() {
  //   clearInterval(this._interval);
  // }
  render() {
    return <DeviceInfo />;
  }
}
