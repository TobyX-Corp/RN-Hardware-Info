import React, {Component} from 'react';
import {requireNativeComponent} from 'react-native';
let RCTMyBasicView = requireNativeComponent('RCTMyBasicView', MyView);
export default class MyView extends Component {
  render() {
    return <RCTMyBasicView {...this.props} />;
  }
}
