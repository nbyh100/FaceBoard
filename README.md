FaceBoard
=========

提供一个可以输入表情的自定义键盘和用于显示带自定义表情消息的文本框。
在http://code4app.com/ios/FaceBoardPlus/52a9ba56cb7e841e178b69d0基础上修改，代码重构，并修复了bug。

# 软件截图
![github logo](/jt1.png)

![github logo](/jt2.png)

# 接口文档

##FaceBoard.h

```
@interface FaceBoard : UIView

// 表情会被输入到这个文本框
- (instancetype)initWithTextView:(UITextView *)faceTextView;

// 分析消息文本, 生成表情编码和文本组成的数组
+ (void)getMessageRange:(NSString*)message :(NSMutableArray*)array;

@end
````

##MessageView.h

```
@interface MessageView : UIView

// 需要显示的文本
@property (nonatomic, strong) NSString *text;

// 计算给定文本时视图的大小
+ (CGSize)sizeForText:(NSString *)text;

@end
```
