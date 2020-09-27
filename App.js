import React, {Component} from 'react';
import {StyleSheet, Text, View, NativeModules} from 'react-native';

let Device = NativeModules.Device;
Device.printAction();

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
