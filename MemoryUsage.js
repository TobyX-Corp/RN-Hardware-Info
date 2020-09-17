import React, {useState} from 'react';
import {StyleSheet, View, Text} from 'react-native';
import DeviceInfo from 'react-native-device-info';

export default function MemoryUsage() {
  // const [usage, setUsage] = useState(0);

  const total = DeviceInfo.getTotalMemory();
  const used = DeviceInfo.getUsedMemory();
  const usage = (used / total) * 100;

  return (
    <View>
      <Text style={styles.text}>Memory total: {total} </Text>
      <Text style={styles.text}>Memory used: {used}% </Text>
      <Text style={styles.text}>Memory Usage: {usage}% </Text>
    </View>
  );
}
const styles = StyleSheet.create({
  text: {
    fontSize: 8,
    color: '#606070',
    padding: 10,
  },
});

// export default class MemoryUsage extends Component {
//   constructor() {
//     super();
//     this.state = {
//       memoryUage: 0,
//     };
//   }
//   componentDidMount() {
//     const total = DeviceInfo.getTotalMemory();
//     const used = DeviceInfo.getUsedMemory();
//     const usage = (used / total) * 100;

//     this.setState({memoryUage: usage});
//   }
//   render() {
//     return <Text style={styles.text}>Memory Usage: {usage}% </Text>;
//   }
// }

// const styles = StyleSheet.create({
//   text: {
//     fontSize: 8,
//     color: '#606070',
//     padding: 10,
//   },
// });

module.exports = MemoryUsage;
