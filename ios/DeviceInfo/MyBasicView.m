#import "MyBasicView.h"

@interface MyBasicView ()

    @property (nonatomic, weak) UILabel *myLabel;
    @property (nonatomic, weak) UIButton *myButton;

@end

@implementation MyBasicView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor orangeColor];
    _myLabel = label;
    [self addSubview:label];
    
    UIButton *button = [[UIButton alloc] init];
    [_myButton sizeToFit];
    _myButton = button;
    [button setTitle:@"点击我显示文字" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showText) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  self.myLabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
  
  self.myButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5 + 20);
  
}

- (void)showText
{
  self.myLabel.text = self.name;
  [self.myLabel sizeToFit];
// 执行 block封装的代码 并向RN传递参数（NSDictionary *）
  if (self.onClickButton) {
    self.onClickButton(@{@"key":@"我是原生传递给RN的文字 - 小小", @"boolKey":@(self.myLabel.text.length)});
  }
}