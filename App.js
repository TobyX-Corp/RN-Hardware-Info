import React, {Component} from 'react';
import {StyleSheet, Text, View, NativeModules} from 'react-native';
import MyView from './MyView.js';

const Test = NativeModules.Test;
Test.addEvent('Birthday Party', '4 Privet Drive, Surrey');

export default class App extends Component {
  render() {
    return (
      <View style={{padding: 10}} />
      // <View style={styles.container}>
      //   <Text style={{marginTop: 20, backgroundColor: 'red'}}>
      //     RN的text组件
      //   </Text>
      //   <MyView
      //     style={styles.nativeViewStyle}
      //     name="canshu"
      //     // onClickButton 封装代码 -  拿到OC传递过来的值，显示在自己的text组件上
      //     // 取值注意点：必须通过nativeEvent来获取
      //     onClickButton={(e) => {
      //       if (e.nativeEvent.boolKey) {
      //         this.setState({
      //           text: e.nativeEvent.key,
      //         });
      //       } else {
      //         this.setState({
      //           text: '原生label的文字消失了',
      //         });
      //       }
      //     }}
      //   />
      // </View>
    );
  }
}

var styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#F5FCFF',
  },
});

module.exports = App;
