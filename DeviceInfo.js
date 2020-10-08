import React, {useState} from 'react';
import {StyleSheet, Text, View, TouchableOpacity, NativeModules} from 'react-native';

let Device = NativeModules.Device;

// componentDidMount() {
//   this._interval = setInterval(() => {
//     let Device = NativeModules.Device;
//     Device.getAppUsage((error, usage) => {
//       if (error) {
//         console.log(error);
//       } else {
//         console.log('get app usage');
//         console.log(usage.download_speed);
//       }
//     });
//   }, 5000);
// };

// componentWillUnmount() {
//   clearInterval(this._interval);
// };

const DeviceInfo = () => {
  const [cpu_freq, setCpuFreq] = useState('0');
  const [ram_usg, setMemUsg] = useState('0');
  const [up_spd, setUpSpd] = useState('0');
  const [down_spd, setDownSpd] = useState('0');

  const update_device_info = () => {
    if (Device != null) {
      Device.getAppUsage((error, usage) => {
        if (error) {
          console.log(error);
        } else {
          console.log('get app usage');
          console.log(usage);
          setCpuFreq(usage.cpu_usage);
          setMemUsg(usage.memory_usage);
          setDownSpd(usage.download_speed);
          setUpSpd(usage.upload_speed);
        }
      });
    }
  };

  return (
    <View style={styles.container}>
      <Text> CPU Usage: {cpu_freq}%</Text>
      <Text> RAM Usage: {ram_usg}% </Text>
      <Text> Download Speed: {down_spd} </Text>
      <Text> Upload Speed: {up_spd} </Text>
      <TouchableOpacity onPress={update_device_info} style={styles.button}>
        <Text> Refresh </Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginTop: 50,
  },
  button: {
    backgroundColor: '#4ba37b',
    width: 200,
    borderRadius: 50,
    alignItems: 'center',
    marginTop: 50,
    marginLeft: 50,
  },
});
export default DeviceInfo;
