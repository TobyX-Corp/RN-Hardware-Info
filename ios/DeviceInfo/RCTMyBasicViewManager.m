#import "RCTMyBasicViewManager.h"

#import "MyBasicView.h"

@implementation RCTMyBasicViewManager

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(name, NSString)// 导出参数供RN 使用

RCT_EXPORT_VIEW_PROPERTY(onClickButton, RCTBubblingEventBlock)// 导出参数供RN 使用

- (UIView *)view
{
  return [[MyBasicView alloc] init];   // MyBasicView的尺寸位置以及样式由RN来控制
}

@end