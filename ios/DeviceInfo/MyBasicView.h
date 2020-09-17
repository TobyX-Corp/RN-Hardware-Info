#import <RCTComponent.h>

@interface MyBasicView : UIView

  @property (nonatomic, strong) NSString *name;  // Label上将来显示的文字

  @property (nonatomic, strong) RCTBubblingEventBlock onClickButton;  // 封装代码块 - 回调（用来接收oc传递的参数，并显示在text组件上）

@end